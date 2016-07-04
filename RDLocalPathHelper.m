//
//  RDLocalPathHelper.m
//  RiceDonate
//
//  Created by ozr on 16/7/4.
//  Copyright © 2016年 ricedonate. All rights reserved.
//

#import "RDLocalPathHelper.h"
@import MobileCoreServices;

@implementation RDLocalPathHelper

+ (NSString*) documentsPath
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/"];
}

+ (NSString*) libraryPath
{
    return [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/"];
}

+ (NSString*) tempPath
{
    return NSTemporaryDirectory();
}

+ (NSString*) mimeTypeWithFilePath: (NSString *) path {
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return nil;
    }
    
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)[path pathExtension], NULL);
    CFStringRef mimeType = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
    CFRelease(UTI);
    if (!mimeType) {
        return @"application/octet-stream";
    }
    return (__bridge NSString *)mimeType;
}

@end
