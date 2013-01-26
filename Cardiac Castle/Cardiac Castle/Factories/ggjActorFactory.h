//
//  ggjActorFactory.h
//  Cardiac Castle
//
//  Created by Andrew Boyd on 26/01/2013.
//  Copyright (c) 2013 GGJ13. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ggjActor.h"

@interface ggjActorFactory : NSObject

@property CGFloat distTravelled;
@property CGFloat baseSpawnProb;
@property NSUInteger numActorsAlive;
@property CGFloat heartRate;
@property (strong) ggjActor *actorToSpawn;

- (BOOL) shouldSpawnThisWave;
- (ggjActor *)spawnActor;

@end
