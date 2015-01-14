//
//  EZFileManager.m
//  EZMoviePlayer
//
//  Created by 卢天翊 on 15/1/13.
//  Copyright (c) 2015年 Ezer. All rights reserved.
//

#import "NSString+Directory.h"

@implementation NSString (Directory)

+ (NSString *)stringWithDirectory:(EZDirectory)name
{
    NSString * directory;
    
    switch (name) {
        case 0: {
            directory = @"Documents";
            break;
        } case 1: {
            directory = @"Library";
            break;
        } case 2: {
            directory = @"tmp";
            break;
        }
        default:
            break;
    }
    NSString * path = [NSHomeDirectory() stringByAppendingPathComponent:directory];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

@end
