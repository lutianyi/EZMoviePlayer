//
//  EZFileManager.h
//  EZMoviePlayer
//
//  Created by 卢天翊 on 15/1/13.
//  Copyright (c) 2015年 Ezer. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, EZDirectory) {
    EZDirectoryDocuments     = 0,
    EZDirectoryLibrary      = 1,
    EZDirectoryTemp         = 2,
};

@interface NSString (Directory)

+ (NSString *)stringWithDirectory:(EZDirectory)name;

@end
