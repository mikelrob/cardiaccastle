//
//  ggjMonsterFactory.h
//  Cardiac Castle
//
//  Created by Michael Robinson on 26/01/2013.
//  Copyright (c) 2013 GGJ13. All rights reserved.
//

#import "ggjActorFactory.h"
#import "ggjMonsterActor.h"

@interface ggjMonsterFactory : ggjActorFactory{
}

@property (strong) UIImage *monsterImage;

- (ggjMonsterActor *)spawnActor;

@end
