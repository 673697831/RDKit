//
//  NSString+RDUUID.h
//  RiceDonate
//
//  Created by ozr on 16/7/11.
//  Copyright © 2016年 ricedonate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RDUUID)

+ (NSString *)rd_uuid;
+ (NSString *)rd_randomId;

@end
