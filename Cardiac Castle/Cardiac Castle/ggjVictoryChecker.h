//
//  ggjVictoryChecker.h
//  Cardiac Castle
//
//  Created by Andrew Boyd on 26/01/2013.
//  Copyright (c) 2013 GGJ13. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ggjActorFactory.h"

@interface ggjVictoryChecker : NSObject

@property CGPoint playerPosition;
@property CGFloat playerDistanceTravelled;
@property (strong) NSArray *monsterPositions;
@property (strong) NSArray *obstaclePositions;
@property (weak) ggjActorFactory *monsterFactory;

- (BOOL) killMonster: (NSUInteger) index;
- (BOOL) endGame;

@end
