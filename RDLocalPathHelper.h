//
//  RDLocalPathHelper.h
//  RiceDonate
//
//  Created by ozr on 16/7/4.
//  Copyright © 2016年 ricedonate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RDLocalPathHelper : NSObject

+ (NSString*) documentsPath;
+ (NSString*) libraryPath;
+ (NSString*) tempPath;
+ (NSString*) mimeTypeWithFilePath:(NSString*) filePath;

@end
