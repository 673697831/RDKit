//
//  UIFont+RDFont.m
//  RiceDonate
//
//  Created by ozr on 16/8/23.
//  Copyright © 2016年 ricedonate. All rights reserved.
//

#import "UIFont+RDFont.h"

@implementation UIFont (RDFont)

+ (UIFont *)rd_fontInPixels:(CGFloat)pixels
{
    return [self rd_systemFontInPixels:pixels isBold:NO];
}

+ (UIFont *)rd_boldFontInPixels:(CGFloat)pixels
{
    return [self rd_systemFontInPixels:pixels isBold:YES];
}

+ (UIFont *)rd_systemFontOfSize:(CGFloat)size
                         isBold:(BOOL)isBold
{
    if (isBold) {
        return [UIFont boldSystemFontOfSize:size];
    }else
    {
        return [UIFont systemFontOfSize:size];
    }
}

+ (UIFont *)rd_systemFontInPixels:(CGFloat)pixels
                           isBold:(BOOL)isBold
{
    static NSMutableDictionary *fontDict; // to hold the font dictionary
    pixels = pixels / [UIScreen mainScreen].scale; // @2x, @3x
    if ( fontDict == nil ) {
        fontDict = [ @{} mutableCopy ];
    }
    // create a key string to see if font has already been created
    //
    NSString *strFontHash = [NSString stringWithFormat:@"%f", pixels];
    UIFont *fnt = fontDict[strFontHash];
    if ( fnt != nil ) {
        return fnt; // we have already created this font
    }
    // lets play around and create a font that falls near the point size needed
    CGFloat pointStart = pixels/4;
    CGFloat lastHeight = -1;
    UIFont *lastFont = [UIFont rd_systemFontOfSize:.5 isBold:isBold];
    
    NSMutableDictionary * dictAttrs = [ @{ } mutableCopy ];
    NSString *fontCompareString = @"Mgj^";
    for ( CGFloat pnt = pointStart ; pnt < 1000 ; pnt += .5 ) {
        UIFont *font = [UIFont rd_systemFontOfSize:pnt isBold:isBold];
        if ( font == nil ) {
            NSAssert(font == nil, @"font name not found in fontWithName:sizeInPixels" ); // correct the font being past in
        }
        dictAttrs[NSFontAttributeName] = font;
        CGSize cs = [fontCompareString sizeWithAttributes:dictAttrs];
        CGFloat fheight =  cs.height;
        if ( fheight == pixels  ) {
            // that will be rare but we found it
            fontDict[strFontHash] = font;
            return font;
        }
        if ( fheight > pixels ) {
            if ( lastFont == nil ) {
                fontDict[strFontHash] = font;
                return font;
            }
            // check which one is closer last height or this one
            // and return the user
            CGFloat fc1 = fabs( fheight - pixels );
            CGFloat fc2 = fabs( lastHeight  - pixels );
            // return the smallest differential
            if ( fc1 < fc2 ) {
                fontDict[strFontHash] = font;
                return font;
            } else {
                fontDict[strFontHash] = lastFont;
                return lastFont;
            }
        }
        lastFont = font;
        lastHeight = fheight;
    }
    NSAssert( false, @"Hopefully should never get here");
    return nil;

}

@end
