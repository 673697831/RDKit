//
//  RDHealthKitManager.h
//  RiceDonate
//
//  Created by ozr on 16/5/16.
//  Copyright © 2016年 ricedonate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RDStepCountDef.h"

@interface RDHealthKitModel : NSObject

/**
 *  判断健康中心是否可用
 *
 *  @return b
 */
+ (BOOL)isHealthDataAvailable;

/**
 *  授权
 *
 *  @param completion 回调
 */
- (void)authorizeHealthKitWithCompletion:(void (^)(BOOL success, NSError *error))completion;

/**
 *  获取两个时间段之间个步数
 *
 *  @param startDate  起始时间
 *  @param endDate    结束时间
 *  @param completion 回调
 */
- (void)requsetForStepCountWithStartDate:(NSDate *)startDate
                                 endDate:(NSDate *)endDate
                              completion:(void (^)(NSInteger stepCount, NSError *error))completion;
/**
 *  精确到今天步数
 *
 *  @param completion 回调
 */
- (void)requsetForTodayStepCountWithCompletion:(void (^)(NSInteger stepCount, NSError *error))completion;

/**
 *  采集每小时数据
 *
 *  @param completion 回调
 */
- (void)requestForStepCountByHourUsingStatisticsCollectionWithCompletion:(RDStepTodayCountHandler)completion;
/**
 *  采集每天数据
 *
 *  @param completion 回调
 */
- (void)requestForStepCountUsingStatisticsCollectionWithCompletion:(RDStepHistoryHandler)completion;
/**
 *  返回步数
 *
 *  @param components <#components description#>
 *  @param completion <#completion description#>
 */
- (void)requestForStepCountUsingStatisticsCollectionWithComponents:(NSDateComponents *)components
                                                        completion:(RDStepCountCollectionHandler)completion
                                                         startDate:(NSDate *)startDate
                                                           endDate:(NSDate *)endDate;
/**
 *  实时获取今天步数
 *
 *  @param handler 回调
 */
- (void)startUpdateStepsWithHandler:(RDStepTodayCountHandler)handler;

/**
 *  停止获取步数
 */
- (void)stopUpdateSteps;

+ (RDHealthKitModel*) sharedManager;

@end
