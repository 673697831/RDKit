//
//  UIImage+RDBoxBlur.h
//  RiceDonate
//
//  Created by ozr on 16/7/11.
//  Copyright © 2016年 ricedonate. All rights reserved.
//

// algorithm from: http://indieambitions.com/idevblogaday/perform-blur-vimage-accelerate-framework-tutorial/?utm_source=feedburner&utm_medium=feed&utm_campaign=Feed%3A+IndieAmbitions+%28Indie+Ambitions%29

#import <Foundation/Foundation.h>

@interface UIImage (RDBoxBlur)

- (UIImage*)rd_boxblurImageWithBlur:(CGFloat)blur;

@end
