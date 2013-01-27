//
//  ggjObstacleFactory.m
//  Cardiac Castle
//
//  Created by Michael Robinson on 26/01/2013.
//  Copyright (c) 2013 GGJ13. All rights reserved.
//

#import "ggjObstacleFactory.h"

@implementation ggjObstacleFactory

- (id) init
{
    self = [super init];
    if (self)
    {
        lastSpawnTime = [NSDate date];
    }
    
    return self;
}


- (BOOL)shouldSpawnThisWave
{
    NSTimeInterval timeSinceLastSpawn = [[NSDate date] timeIntervalSinceDate: lastSpawnTime];
    if (timeSinceLastSpawn >= 1.0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (ggjObstacleActor *)spawnActor
{
    lastSpawnTime = [NSDate date];
    self.numActorsAlive++;
    ggjObstacleActor* newObstacle = [[ggjObstacleActor alloc] init];
    [newObstacle setImage: [self obstacleImage]];
    [newObstacle setSize: [[self obstacleImage] size]];
    [newObstacle setActorImageView: [[UIImageView alloc] initWithImage: [self obstacleImage]]];
    return newObstacle;
}


@end
