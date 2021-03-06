//
//  ggjObstacleFactory.h
//  Cardiac Castle
//
//  Created by Michael Robinson on 26/01/2013.
//  Copyright (c) 2013 GGJ13. All rights reserved.
//

#import "ggjActorFactory.h"
#import "ggjObstacleActor.h"

@interface ggjObstacleFactory : ggjActorFactory
{
    NSDate *lastSpawnTime;
}


@property (strong) UIImage *obstacleImage;

- (ggjObstacleActor*) spawnActor;

@end
