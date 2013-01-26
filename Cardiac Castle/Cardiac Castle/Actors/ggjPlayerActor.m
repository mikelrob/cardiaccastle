//
//  ggjPlayerActor.m
//  Cardiac Castle
//
//  Created by Andrew Boyd on 26/01/2013.
//  Copyright (c) 2013 GGJ13. All rights reserved.
//

#import "ggjPlayerActor.h"

@implementation ggjPlayerActor

- (id) init
{
    self = [super init];
    if (self)
    {
        [self setVelocity: CGPointMake(0, 0)];
        [self setImage: [UIImage imageWithContentsOfFile:@""]];
        [self setSize: [[self image] size] ];
    }
    return self;
}

@end
