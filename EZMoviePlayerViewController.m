//
//  EZMoviePlayerViewController.m
//  EZMoviePlayer
//
//  Created by 卢天翊 on 15/1/13.
//  Copyright (c) 2015年 Ezer. All rights reserved.
//

#import "EZMoviePlayerViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "EZAppDelegate.h"
#import "AFNetworking.h"
#import "NSString+Directory.h"

#warning 视频地址
#define kMovieURLString @""

@interface EZMoviePlayerViewController ()

@property (nonatomic) BOOL isPlay;

@end

@implementation EZMoviePlayerViewController

@synthesize isPlay;

static NSString * movieName = @"movieName";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)didPlayerButtonClicked:(id)sender
{
    NSString * moviePath = [[NSString stringWithDirectory:(EZDirectoryTemp)]stringByAppendingPathComponent:[movieName stringByAppendingString:@".mp4"]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:moviePath]) {
        
        [self moviePlay];
        
    } else {
        
        AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:kMovieURLString]]];
        
        /**
         *  忽略无效的证书.
         */
        [operation.securityPolicy setAllowInvalidCertificates:YES];
        
        operation.outputStream = [NSOutputStream outputStreamToFileAtPath:moviePath append:YES];
        [operation start];
        
        [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
            /**
             *  当前累计下载超过200k, 开始播放视频.
             */
            if ((totalBytesRead > 200000 && !isPlay) || totalBytesExpectedToRead < 200000)
            {
                /**
                 *  播放状态
                 */
                isPlay = true;
                [self moviePlay];
            }
        }];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
}

- (void)moviePlay
{
    /**
     *  IP和端口号对应AppDelegate中HTTPServer设置的属性.
     */
    NSURL * fileURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://127.0.0.1:10001/%@.mp4", movieName]];
    
    MPMoviePlayerViewController * playerViewController =[[MPMoviePlayerViewController alloc]initWithContentURL:fileURL];
    
    //    playerViewController.moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDidFinish) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
        [self presentMoviePlayerViewControllerAnimated:playerViewController];
}

- (void)moviePlayBackDidFinish {
    
    isPlay = NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
