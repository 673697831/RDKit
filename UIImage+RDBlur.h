//
//  UIImage+RDBlur.h
//  RiceDonate
//
//  Created by ozr on 16/10/9.
//  Copyright © 2016年 ricedonate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (RDBlur)

- (UIImage *)rd_blurImageWithImage:(UIImage *)image
                            radius:(CGFloat)radius;

@end
