//
//  NSDictionary+RDJSON.m
//  RiceDonate
//
//  Created by ozr on 16/7/11.
//  Copyright © 2016年 ricedonate. All rights reserved.
//

#import "NSDictionary+RDJSON.h"

@implementation NSDictionary (RDJSON)

- (NSString*) rd_jsonSerialization
{
    NSError* error;
    NSData* data = [NSJSONSerialization dataWithJSONObject:self
                                                   options:0
                                                     error:&error];
    
    if (!error)
    {
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return nil;
}

@end
