//
//  ggjMonsterFactory.m
//  Cardiac Castle
//
//  Created by Michael Robinson on 26/01/2013.
//  Copyright (c) 2013 GGJ13. All rights reserved.
//

#import "ggjMonsterFactory.h"

@implementation ggjMonsterFactory



- (BOOL)shouldSpawnThisWave{
    return [super shouldSpawnThisWave];
}

- (ggjMonsterActor *)spawnActor{
    ggjMonsterActor* newMonster = [[ggjMonsterActor alloc] init];
    [newMonster setImage: [self monsterImage]];
    return newMonster;
}
@end
