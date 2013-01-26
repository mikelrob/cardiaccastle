//
//  ggjGameViewController.h
//  Cardiac Castle
//
//  Created by Michael Robinson on 26/01/2013.
//  Copyright (c) 2013 GGJ13. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ggjActorFactory.h"
#import "ggjVictoryChecker.h"
#import "ggjPlayerActor.h"
#import <AVFoundation/AVFoundation.h>

@interface ggjGameViewController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate>
{
    dispatch_queue_t gameLoopQueue;
    NSRunLoop *gameLoop;
    
    UIImage *backgroundImage;
    
    dispatch_queue_t measureQueue;
    dispatch_queue_t myQueue;
    AVCaptureSession *session;
    
    BOOL isMeasuring;
    BOOL isStillCounting;
    BOOL isPlaying;
    BOOL redIsHigh;
    BOOL redWasHigh;
    BOOL isFirstFlipFound;
    NSTimeInterval lastFlipTime;
    NSMutableArray *valuesArray;
    NSMutableArray *ratesArray;
    NSMutableArray *redsArray;
    int valuesCount;
    CGFloat highValue;
    CGFloat lowValue;
    CGFloat midValue;
    CGFloat heartRate;
    CGFloat movingRedAve;
    NSTimer *measuringTimer;
}

@property (strong) ggjActorFactory *monsterFactory;
@property (strong) ggjActorFactory *obstacleFactory;
@property (strong) ggjPlayerActor *player;
@property (strong) NSArray *monsters;
@property (strong) NSArray *obstacles;
@property (strong) ggjVictoryChecker *victoryChecker;


@property (weak, nonatomic) IBOutlet UILabel *HRLabel;

@end
