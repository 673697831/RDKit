//
//  UILabel+RDLinkAttributes.m
//  RiceDonate
//
//  Created by ozr on 16/11/3.
//  Copyright © 2016年 ricedonate. All rights reserved.
//

#import "UILabel+RDLinkAttributes.h"
#import <objc/runtime.h>

NSString * const RDLinkAttributeName  = @"RDLink";

static char kTapKey;
static char kLinkBlockKey;

@implementation UILabel (RDLinkAttributes)

@dynamic rd_linkBlock;

- (void)setRd_linkBlock:(void (^)(id))rd_linkBlock
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [self getTap];
    if (!tap) {
        tap = [UITapGestureRecognizer new];
        [tap addTarget:self action:@selector(rd_handleTapOnLabel:)];
        [self addGestureRecognizer:tap];
        [self setTap:tap];
    }
    objc_setAssociatedObject(self, &kLinkBlockKey, [rd_linkBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void (^)(id))rd_linkBlock
{
    return objc_getAssociatedObject(self, &kLinkBlockKey);
}

- (void)setTap:(UITapGestureRecognizer *)tap
{
    objc_setAssociatedObject(self, &kTapKey, tap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UITapGestureRecognizer *)getTap
{
    return objc_getAssociatedObject(self, &kTapKey);
}

- (void)rd_handleTapOnLabel:(UITapGestureRecognizer *)tapGesture
{
    __weak typeof(self) wself = self;
    NSAttributedString *attributedText = self.attributedText;
    [attributedText enumerateAttributesInRange:NSMakeRange(0, attributedText.length) options:NSAttributedStringEnumerationReverse usingBlock:
     ^(NSDictionary *attributes, NSRange range, BOOL *stop) {
         for (NSString *key in attributes) {
             if ([key isEqualToString:RDLinkAttributeName]) {
                 if ([wself rd_didTapAttributedTextInRange:range tap:tapGesture]) {
                     if (wself.rd_linkBlock) {
                         wself.rd_linkBlock(attributes[key]);
                     }
                     *stop = YES;
                     break;
                 }
             }
         }
     }];
}

- (BOOL)rd_didTapAttributedTextInRange:(NSRange)targetRange
                                   tap:(UITapGestureRecognizer *)tap
{
    CGSize labelSize = self.bounds.size;
    // create instances of NSLayoutManager, NSTextContainer and NSTextStorage
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGSizeZero];
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:self.attributedText];
    
    // configure layoutManager and textStorage
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];
    
    // configure textContainer for the label
    
    CGFloat constant = 0;
    
    //有待改进
    if (self.textAlignment == NSTextAlignmentLeft) {
        constant = 0;
    }else if (self.textAlignment == NSTextAlignmentCenter) {
        constant = .5;
    }else if (self.textAlignment == NSTextAlignmentRight) {
        constant = 1;
    }
    
    textContainer.lineFragmentPadding = 0.0;
    textContainer.lineBreakMode = self.lineBreakMode;
    textContainer.maximumNumberOfLines = self.numberOfLines;
    textContainer.size = labelSize;
    
    // find the tapped character location and compare it to the specified range
    CGPoint locationOfTouchInLabel = [tap locationInView:self];
    CGRect textBoundingBox = [layoutManager usedRectForTextContainer:textContainer];
    CGPoint textContainerOffset = CGPointMake((labelSize.width - textBoundingBox.size.width) * constant - textBoundingBox.origin.x,
                                              (labelSize.height - textBoundingBox.size.height) * constant - textBoundingBox.origin.y);
    CGPoint locationOfTouchInTextContainer = CGPointMake(locationOfTouchInLabel.x - textContainerOffset.x,
                                                         locationOfTouchInLabel.y - textContainerOffset.y);
    NSInteger indexOfCharacter = [layoutManager characterIndexForPoint:locationOfTouchInTextContainer
                                                       inTextContainer:textContainer
                              fractionOfDistanceBetweenInsertionPoints:nil];
    if (NSLocationInRange(indexOfCharacter, targetRange)) {
        return YES;
    } else {
        return NO;
    }
    
}

@end
