//
//  UILabel+RDLinkAttributes.h
//  RiceDonate
//
//  Created by ozr on 16/11/3.
//  Copyright © 2016年 ricedonate. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString * const RDLinkAttributeName;

@interface UILabel (RDLinkAttributes)

@property (nonatomic, strong) void (^rd_linkBlock)(id);

@end
