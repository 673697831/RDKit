//
//  UIImageView+RDWebCache.h
//  RiceDonate
//
//  Created by ozr on 16/9/28.
//  Copyright © 2016年 ricedonate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImageView (RDWebCache)

- (void)rd_setImageWithURL:(NSURL *)url
          placeholderImage:(UIImage *)placeholder;

@end
