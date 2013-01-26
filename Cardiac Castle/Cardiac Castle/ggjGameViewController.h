//
//  ggjGameViewController.h
//  Cardiac Castle
//
//  Created by Michael Robinson on 26/01/2013.
//  Copyright (c) 2013 GGJ13. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ggjMonsterFactory.h"
#import "ggjObstacleFactory.h"
#import "ggjVictoryChecker.h"
#import "ggjPlayerActor.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMotion/CoreMotion.h>

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
    NSTimeInterval timeElapsedThisLoop;
    
    CMMotionManager *motionManager;
}

@property (strong) ggjMonsterFactory *monsterFactory;
@property (strong) ggjObstacleFactory *obstacleFactory;
@property (strong) ggjPlayerActor *player;
@property (strong) NSMutableArray *monsters;
@property (strong) NSMutableArray *obstacles;
@property (strong) ggjVictoryChecker *victoryChecker;
@property (strong, nonatomic) IBOutlet UIImageView *BGImage;

@property (strong) UIImageView *playerSprite;
//@property (strong) NSArray *monsterSprites;
//@property (strong) NSArray *obstacleSprites;


@property (weak, nonatomic) IBOutlet UILabel *HRLabel;

@end
