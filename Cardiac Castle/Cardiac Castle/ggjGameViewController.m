//
//  ggjGameViewController.m
//  Cardiac Castle
//
//  Created by Michael Robinson on 26/01/2013.
//  Copyright (c) 2013 GGJ13. All rights reserved.
//

#import "ggjGameViewController.h"
#import "ggjMonsterActor.h"
#import "ggjObstacleActor.h"

@interface ggjGameViewController ()

@end

@implementation ggjGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setupBackgroundImage
{
    
}

- (void) measureHeartRate
{
    
}

- (void) spawnPlayer
{
    [self setPlayer: [[ggjPlayerActor alloc]init]];
    [[self player] setPosition: CGPointMake( [[self view] frame].origin.x + (0.5 * [[self view] frame].size.width) , [[self view] frame].origin.y + (0.5 * [[self view] frame].size.height))];
    
}

- (void) spawnMonsters
{
    
}

- (void) spawnObstacles
{
    
}

- (void) moveMonsters
{
    
}

- (void) moveObstacles
{
    
}

- (void) moveBackground
{
    
}

- (void) startGameLoop
{
    [self setMonsterFactory: [[ggjActorFactory alloc] init]];
    [[self monsterFactory] setActorToSpawn: [[ggjMonsterActor alloc] init]];
    [[self monsterFactory] setDistTravelled:0.0];
    [[self monsterFactory] setBaseSpawnProb:0.003];
    [[self monsterFactory] setHeartRate:heartRate];
    [[self monsterFactory] setNumActorsAlive:0];
    
    
    [self setObstacleFactory: [[ggjActorFactory alloc] init]];
    [[self obstacleFactory] setActorToSpawn: [[ggjObstacleActor alloc] init]];
    [[self obstacleFactory] setDistTravelled:0.0];
    [[self obstacleFactory] setBaseSpawnProb:0.03];
    [[self obstacleFactory] setHeartRate:heartRate];
    [[self obstacleFactory] setNumActorsAlive:0];
    
    
    [self setVictoryChecker: [[ggjVictoryChecker alloc] init]];
    [[self victoryChecker] setMonsterFactory:[self monsterFactory]];
    [[self victoryChecker] setPlayerDistanceTravelled:0.0];
    [[self victoryChecker] setPlayerPosition: [[self player] position]];
    [[self victoryChecker] setMonsterPositions: [@[] mutableCopy]];
    [[self victoryChecker] setObstaclePositions: [@[] mutableCopy]];
    
    [self setupBackgroundImage];
    [self spawnPlayer];
    
    gameLoopQueue = dispatch_queue_create("cardiacCastleGameLoopQueue", NULL);
    
    __block NSDate *lastLoopDate = [NSDate date];
    dispatch_async(gameLoopQueue, ^{
        
        NSDate *currentTime = [NSDate date];
        
        NSTimeInterval timeElapsed = [currentTime timeIntervalSinceDate: lastLoopDate];
        lastLoopDate = currentTime;
        
        [self moveMonsters];
        [self moveBackground];
        [self moveObstacles];
        
        if(NO == [[self victoryChecker] endGame])
        {
            [self spawnMonsters];
            [self spawnObstacles];
        }
        
    });
}

- (void) stopGameLoop
{
    
}

@end
