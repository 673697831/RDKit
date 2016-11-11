//
//  RDHealthKitManager.m
//  RiceDonate
//
//  Created by ozr on 16/5/16.
//  Copyright © 2016年 ricedonate. All rights reserved.
//

#import "RDHealthKitModel.h"
#import "NSDate+RDLogic.h"
#import <CoreMotion/CoreMotion.h>
#import <HealthKit/HealthKit.h>

static const NSInteger readInterval = 10;

@interface RDHealthKitModel ()

@property (nonatomic, strong) HKHealthStore *healthKitStore;
@property (nonatomic, copy)   RDStepTodayCountHandler stepsHandler;
@property (nonatomic, weak)   NSTimer *stepUpdateTimer;
@property (nonatomic, strong) CMPedometer *pedonmeter;
@property (nonatomic, assign) NSInteger lastSynSteps;

@end

@implementation RDHealthKitModel

+ (BOOL)isHealthDataAvailable
{
    return [HKHealthStore isHealthDataAvailable];
}

- (HKHealthStore *)healthKitStore
{
    if (!_healthKitStore) {
        
        _healthKitStore = [HKHealthStore new];
    }
    
    return _healthKitStore;
}

- (CMPedometer *)pedonmeter
{
    if (!_pedonmeter) {
        _pedonmeter = [CMPedometer new];
    }
    
    return _pedonmeter;
}

- (void)authorizeHealthKitWithCompletion:(void (^)(BOOL, NSError *))completion
{
    //写
    //NSSet *healthDataToWrite = [NSSet setWithObjects:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning], nil];
    //读
    NSSet *healthDataToRead = [NSSet setWithObjects:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning], [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount], nil];
    [self.healthKitStore requestAuthorizationToShareTypes:nil
                                                readTypes:healthDataToRead
                                               completion:^(BOOL success, NSError * _Nullable error)
    {
        if (completion) {
            completion(success, error);
        }
        
    }];
}

- (void)requsetForStepCountWithStartDate:(NSDate *)startDate
                                 endDate:(NSDate *)endDate
                              completion:(void (^)(NSInteger stepCount, NSError *error))completion;
{
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionNone];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierStartDate ascending:YES];
    HKSampleType *type = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    HKSampleQuery *stepQuery = [[HKSampleQuery alloc] initWithSampleType:type
                                                               predicate:predicate
                                                                   limit:HKObjectQueryNoLimit
                                                         sortDescriptors:@[sortDescriptor]
                                                          resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error)
    {
        NSInteger steps = 0;
        for (HKQuantitySample *sample in results) {
            steps += [sample.quantity doubleValueForUnit:[HKUnit countUnit]];
        }
        
        if (completion) {
            completion(steps, error);
        }
        
    }];
    [self.healthKitStore executeQuery:stepQuery];
    
}

- (void)requsetForTodayStepCountWithCompletion:(void (^)(NSInteger stepCount, NSError *error))completion
{
    NSDateFormatter *getformatter = [[NSDateFormatter alloc] init];
    [getformatter setDateFormat:@"yyyy-MM-dd "];
    NSString *dateString = [getformatter stringFromDate:[NSDate date]];
    NSDate *startDate = [getformatter dateFromString:dateString];
    NSDate *endDate = [NSDate date];
    [self requsetForStepCountWithStartDate:startDate
                                   endDate:endDate
                                completion:completion];
}

- (void)requestForStepCountUsingStatisticsCollectionWithCompletion:(RDStepHistoryHandler)completion
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = 1;

    [self requestForStepCountUsingStatisticsCollectionWithComponents:dateComponents completion:^(NSArray<__kindof HKStatistics *> *results) {
        NSMutableDictionary *mutableDic = [NSMutableDictionary new];
        for (HKStatistics *statistic in results) {
            //减去8个小时时差得到正确时间戳
            NSString *key = @(statistic.startDate.timeIntervalSince1970 - 8 * 60 * 60).stringValue;
            NSInteger steps = [mutableDic[key] integerValue];
            for (HKSource *source in statistic.sources) {
                NSInteger increaseSteps = [[statistic sumQuantityForSource:source] doubleValueForUnit:[HKUnit countUnit]];
                steps += increaseSteps;
            }
            mutableDic[key] = @(steps);
        }
        //NSLog(@"%@", mutableDic);
        completion(mutableDic);
    } startDate:[NSDate startDateFromTodayUTCWithDayCount:9] endDate:[NSDate date]];
}

- (void)requestForStepCountByHourUsingStatisticsCollectionWithCompletion:(RDStepTodayCountHandler)completion
{
    __weak typeof(self) weakSelf = self;
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.hour = 1;
    [self requestForStepCountUsingStatisticsCollectionWithComponents:dateComponents completion:^(NSArray<__kindof HKStatistics *> *results) {
        NSInteger todaySteps = 0;
        NSMutableArray *mutableArray = [NSMutableArray new];
        for (int i = 0; i < 24; i ++) {
            [mutableArray addObject:@0];
        }
        
        for (HKStatistics *statistic in results) {
            NSDateComponents *componets = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear| NSCalendarUnitWeekday | NSWeekCalendarUnit | NSCalendarUnitHour fromDate:statistic.startDate];
            if (componets.hour < mutableArray.count) {
                NSInteger steps = [mutableArray[componets.hour] integerValue];
                for (HKSource *source in statistic.sources) {
                    NSInteger increaseSteps = [[statistic sumQuantityForSource:source] doubleValueForUnit:[HKUnit countUnit]];
                    steps += increaseSteps;
                    todaySteps += increaseSteps;
                }
                mutableArray[componets.hour] = @(steps);
            }
        }
        
        //NSLog(@"%@", mutableArray);
        NSInteger increaseSteps = todaySteps - weakSelf.lastSynSteps;

        completion(todaySteps, mutableArray, increaseSteps);
    } startDate:[NSDate startDateFromTodayUTCWithDayCount:0] endDate:[NSDate date]];
}

- (void)requestForStepCountUsingStatisticsCollectionWithComponents:(NSDateComponents *)components
                                                        completion:(RDStepCountCollectionHandler)completion
                                                         startDate:(NSDate *)startDate
                                                           endDate:(NSDate *)endDate
{
    HKQuantityType *quantityType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
    HKStatisticsCollectionQuery *collectionQuery = [[HKStatisticsCollectionQuery alloc] initWithQuantityType:quantityType quantitySamplePredicate:predicate options: HKStatisticsOptionCumulativeSum | HKStatisticsOptionSeparateBySource anchorDate:[NSDate dateWithTimeIntervalSince1970:0] intervalComponents:components];
    collectionQuery.initialResultsHandler = ^(HKStatisticsCollectionQuery *query, HKStatisticsCollection * __nullable result, NSError * __nullable error) {
        NSMutableArray *mutableArray = [NSMutableArray new];
        for (HKStatistics *statistic in result.statistics) {
            [mutableArray addObject:statistic];
            NSLog(@"\n%@ 至 %@", statistic.startDate, statistic.endDate);
            for (HKSource *source in statistic.sources) {
                //if ([source.name isEqualToString:[UIDevice currentDevice].name]) {
                NSLog(@"%@ -- %f",source, [[statistic sumQuantityForSource:source] doubleValueForUnit:[HKUnit countUnit]]);
                //}
            }
        }
        completion(mutableArray);
    };
    [self.healthKitStore executeQuery:collectionQuery];
}

- (void)timerUpdate
{
    __weak typeof(self) weakSelf = self;
    [self requestForStepCountByHourUsingStatisticsCollectionWithCompletion:^(NSInteger todaySteps, NSArray *allSteps, NSInteger increaseSteps) {
        if (weakSelf.stepsHandler) {
            weakSelf.stepsHandler(todaySteps, allSteps, increaseSteps);
        }
    }];
}

- (void)startUpdateStepsWithHandler:(RDStepTodayCountHandler)handler
{
    
    __weak typeof(self) weakSelf = self;
    if (self.stepUpdateTimer) {
        [self.stepUpdateTimer invalidate];
    }
    [self requestForStepCountByHourUsingStatisticsCollectionWithCompletion:^(NSInteger todaySteps, NSArray<__kindof NSNumber *> *results, NSInteger increaseSteps) {
        weakSelf.lastSynSteps = todaySteps;
        handler(todaySteps, results, 0);
    }];
    self.stepsHandler = handler;
    self.stepUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:readInterval target:self selector:@selector(timerUpdate) userInfo:nil repeats:YES];
}

- (void)stopUpdateSteps
{
    if (self.stepUpdateTimer) {
        [self.stepUpdateTimer invalidate];
    }
    self.stepUpdateTimer = nil;
    self.stepsHandler = nil;
    self.lastSynSteps = 0;
}

+ (RDHealthKitModel*) sharedManager
{
    static RDHealthKitModel* manager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [RDHealthKitModel new];
    });
    
    return manager;
}

@end
