//
//  UIImage+RDQRCode.h
//  RiceDonate
//
//  Created by ozr on 16/7/11.
//  Copyright © 2016年 ricedonate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (RDQRCode)

+ (UIImage *)rd_qrCodeImageWithUTF8String:(NSString *)UTF8String
                                  onColor:(UIColor *)onColor
                                 offColor:(UIColor *)offColor
                                     size:(CGSize)size
                              centerImage:(UIImage *)centerImage;

//iOS8
+ (NSString *)rd_qrCodeWithImage:(UIImage *)image NS_CLASS_AVAILABLE(10_10, 8_0); 

@end
