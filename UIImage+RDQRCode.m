//
//  UIImage+RDQRCode.m
//  RiceDonate
//
//  Created by ozr on 16/7/11.
//  Copyright © 2016年 ricedonate. All rights reserved.
//

#import "UIImage+RDQRCode.h"
#import "UIImage+MergeImages.h"

@implementation UIImage (RDQRCode)

+ (UIImage *)rd_qrCodeImageWithUTF8String:(NSString *)UTF8String
                                  onColor:(UIColor *)onColor
                                 offColor:(UIColor *)offColor
                                     size:(CGSize)size
                              centerImage:(UIImage *)centerImage
{
    NSData *stringData = [UTF8String dataUsingEncoding: NSUTF8StringEncoding];
    //生成
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"Q" forKey:@"inputCorrectionLevel"];
    CIImage *qrImage;
    
    if (onColor && offColor) {
        CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"
                                           keysAndValues:
                                 @"inputImage",qrFilter.outputImage,
                                 @"inputColor0",[CIColor colorWithCGColor:onColor.CGColor],
                                 @"inputColor1",[CIColor colorWithCGColor:offColor.CGColor],
                                 nil];
        qrImage = colorFilter.outputImage;
        
    }else
    {
        qrImage = qrFilter.outputImage;
    }
    
    //绘制
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRelease(cgImage);
    
    if (!centerImage) {
        return codeImage;
    }
    
    return [UIImage addIconImage:codeImage withIcon:centerImage];
}

//iOS8
+ (NSString *)rd_qrCodeWithImage:(UIImage *)image NS_CLASS_AVAILABLE(10_10, 8_0)
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    CIImage *ciimage = [CIImage imageWithCGImage:image.CGImage];
    NSArray *features = [detector featuresInImage:ciimage];
    CIQRCodeFeature *feature = [features firstObject];
    return feature.messageString;
}

@end
