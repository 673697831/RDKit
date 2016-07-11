//
//  UIImage+RDMergeIcon.h
//  RiceDonate
//
//  Created by ozr on 16/7/11.
//  Copyright © 2016年 ricedonate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (RDMergeIcon)

//合并两张图片,暂用与二维码的icon合并
+ (UIImage *)rd_image:(UIImage *)image withIcon:(UIImage *)icon;

@end
