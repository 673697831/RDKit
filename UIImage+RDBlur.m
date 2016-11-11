//
//  UIImage+RDBlur.m
//  RiceDonate
//
//  Created by ozr on 16/10/9.
//  Copyright © 2016年 ricedonate. All rights reserved.
//

#import "UIImage+RDBlur.h"

@implementation UIImage (RDBlur)

- (UIImage *)rd_blurImageWithImage:(UIImage *)image
                            radius:(CGFloat)radius
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
    CIImage *outputCIImage;
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1) {
        outputCIImage = [inputImage imageByClampingToExtent];
        outputCIImage = [outputCIImage imageByApplyingFilter:@"CIGaussianBlur" withInputParameters:@{kCIInputRadiusKey:@(radius)}];
        outputCIImage = [outputCIImage imageByCroppingToRect:inputImage.extent];
    }else
    {
        CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
        [filter setValue:inputImage forKey:kCIInputImageKey];
        [filter setValue:@(radius) forKey:kCIInputRadiusKey];
        outputCIImage = filter.outputImage;
    }
    
    CGImageRef renderImage = [context createCGImage:outputCIImage fromRect:inputImage.extent];
    return [UIImage imageWithCGImage:renderImage];
}

@end
