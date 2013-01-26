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

@interface ggjGameViewController : UIViewController
{
    dispatch_queue_t gameLoopQueue;
    NSRunLoop *gameLoop;
    
    CGFloat heartRate;
    UIImage *backgroundImage;
}

@property (strong) ggjActorFactory *monsterFactory;
@property (strong) ggjActorFactory *obstacleFactory;
@property (strong) ggjPlayerActor *player;
@property (strong) NSArray *monsters;
@property (strong) NSArray *obstacles;
@property (strong) ggjVictoryChecker *victoryChecker;



@end
