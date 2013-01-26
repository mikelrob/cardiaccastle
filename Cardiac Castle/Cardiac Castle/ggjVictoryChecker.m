//
//  ggjVictoryChecker.m
//  Cardiac Castle
//
//  Created by Andrew Boyd on 26/01/2013.
//  Copyright (c) 2013 GGJ13. All rights reserved.
//

#import "ggjVictoryChecker.h"

@implementation ggjVictoryChecker

- (BOOL) endGame
{
    for (ggjMonsterActor *monster in self.monsters) {
        if (monster.position.x == self.playerPosition.x && monster.position.y == self.playerPosition.y) {
            NSLog(@"Player death by monster");
            return YES;
        }
    }
    for (ggjObstacleActor *obstacle in self.obstacles) {
        if (obstacle.position.x == self.playerPosition.x && obstacle.position.y == self.playerPosition.y) {
            NSLog(@"Player death by obstacle");
            return YES;
        }
    }
    return NO;
}



@end
