//
//  NSString+RDJSON.m
//  RiceDonate
//
//  Created by ozr on 16/7/11.
//  Copyright © 2016年 ricedonate. All rights reserved.
//

#import "NSString+RDJSON.h"

@implementation NSString (RDJSON)

- (NSString*) rd_jsonSerialization
{
    const char* str = [self cStringUsingEncoding:NSUTF8StringEncoding];
    
    NSError* error;
    id result = [NSJSONSerialization JSONObjectWithData:[NSData dataWithBytes: str
                                                                       length: strlen(str)]
                                                options:0
                                                  error:&error];
    if (error) return nil;
    else
        return result;
}

@end
