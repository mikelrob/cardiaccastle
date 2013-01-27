//
//  ggjMonsterFactory.m
//  Cardiac Castle
//
//  Created by Michael Robinson on 26/01/2013.
//  Copyright (c) 2013 GGJ13. All rights reserved.
//

#import "ggjMonsterFactory.h"

@implementation ggjMonsterFactory



- (BOOL)shouldSpawnThisWave
{
    if (self.numActorsAlive >= 5)
    {
        return false;
    }
    if (self.numActorsAlive == 0)
    {
        return true;
    }
    
    CGFloat randomNumber = (rand() % 100) * 0.01;
    if (self.heartRate > 75.0)
    {
        randomNumber *= 0.5;
    }
    
    return  randomNumber <= self.baseSpawnProb;
    
//    return [super shouldSpawnThisWave];
}

- (ggjMonsterActor *)spawnActor
{
    self.numActorsAlive++;
    ggjMonsterActor* newMonster = [[ggjMonsterActor alloc] init];
    [newMonster setImage: [self monsterImage]];
    [newMonster setSize: [[self monsterImage] size]];
    [newMonster setActorImageView: [[UIImageView alloc] initWithImage: [self monsterImage]]];
    return newMonster;
}
@end
