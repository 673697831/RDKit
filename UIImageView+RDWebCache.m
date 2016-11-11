//
//  UIImageView+RDWebCache.m
//  RiceDonate
//
//  Created by ozr on 16/9/28.
//  Copyright © 2016年 ricedonate. All rights reserved.
//

#import "UIImageView+RDWebCache.h"
#import <UIImageView+WebCache.h>

@implementation UIImageView (RDWebCache)

- (void)rd_setImageWithURL:(NSURL *)url
          placeholderImage:(UIImage *)placeholder
{
    @weakify(self);
    [self.layer removeAllAnimations];
    [self sd_setImageWithURL:url
            placeholderImage:placeholder
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
    {
        @strongify(self);
        [UIView transitionWithView:self
                          duration:.4
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
        self.image = image;
        } completion:nil];
    }];
}

@end
