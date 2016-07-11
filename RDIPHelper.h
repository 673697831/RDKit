//
//  RDIPHelper.h
//  RiceDonate
//
//  Created by ozr on 15/8/21.
//  Copyright (c) 2015年 ricedonate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RDIPHelper : NSObject

+ (NSString *)deviceIPAddress:(BOOL)preferIPv4;

+ (NSString *)deviceWIFIAdress;

@end
