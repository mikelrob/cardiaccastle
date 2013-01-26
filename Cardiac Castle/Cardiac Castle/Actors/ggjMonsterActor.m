//
//  ggjMonsterActor.m
//  Cardiac Castle
//
//  Created by Andrew Boyd on 26/01/2013.
//  Copyright (c) 2013 GGJ13. All rights reserved.
//

#import "ggjMonsterActor.h"

@implementation ggjMonsterActor

- (id) init
{
    self = [super init];
    if (self)
    {
        [self setVelocity: CGPointMake(0, 1)];
        [self setImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mon2_walk" ofType:@"png"]]];
        [self setSize: [[self image] size] ];
    }
    return self;
}

@end
