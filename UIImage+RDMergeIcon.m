//
//  UIImage+RDMergeIcon.m
//  RiceDonate
//
//  Created by ozr on 16/7/11.
//  Copyright © 2016年 ricedonate. All rights reserved.
//

#import "UIImage+RDMergeIcon.h"

@implementation UIImage (RDMergeIcon)

+ (UIImage *)rd_image:(UIImage *)image withIcon:(UIImage *)icon;
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]){
        UIGraphicsBeginImageContextWithOptions(image.size, NO, [UIScreen mainScreen].scale);
    }
    else{
        UIGraphicsBeginImageContext(image.size);
    }
    
    //通过两张图片进行位置和大小的绘制，实现两张图片的合并；其实此原理做法也可以用于多张图片的合并
    CGFloat widthOfImage = image.size.width;
    CGFloat heightOfImage = image.size.height;
    CGFloat widthOfIcon = icon.size.width;
    CGFloat heightOfIcon = icon.size.height;
    
    [image drawInRect:CGRectMake(0, 0, widthOfImage, heightOfImage)];
    [icon drawInRect:CGRectMake((widthOfImage-widthOfIcon)/2, (heightOfImage-heightOfIcon)/2,
                                widthOfIcon, heightOfIcon)];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return img;
}

@end
