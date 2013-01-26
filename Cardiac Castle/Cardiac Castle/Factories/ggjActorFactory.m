//
//  ggjActorFactory.m
//  Cardiac Castle
//
//  Created by Andrew Boyd on 26/01/2013.
//  Copyright (c) 2013 GGJ13. All rights reserved.
//

#import "ggjActorFactory.h"

@implementation ggjActorFactory

- (BOOL)shouldSpawnThisWave{
    if (true) {
        return TRUE;
    }
    return FALSE;
}

- (ggjActor *)spawnActor{
    ggjActor *newActor = [[ggjActor alloc] init];
    
    return newActor;
}

@end
