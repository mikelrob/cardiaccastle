//
//  ggjActor.m
//  Cardiac Castle
//
//  Created by Michael Robinson on 26/01/2013.
//  Copyright (c) 2013 GGJ13. All rights reserved.
//

#import "ggjActor.h"

@implementation ggjActor

- (id)init
{
    self = [super init];
    if (self) {
        self.position = CGPointMake(0, 0);
        self.velocity = CGPointMake(0, 0);
        self.size = CGSizeMake(0, 0);
        self.image = nil;
        self.actorImageView = nil;
    }
    return self;
}

- (id)initWithImage:(UIImage *)initImage{
    
    if (self = [super init]) {
        self.position = CGPointMake(0, 0);
        self.velocity = CGPointMake(0, 0);
        self.size = CGSizeMake(0, 0);
        self.image = initImage;
        self.actorImageView = [[UIImageView alloc] initWithImage:initImage];
    }
    return self;
}


@end
