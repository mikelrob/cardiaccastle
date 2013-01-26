//
//  ggjActor.h
//  Cardiac Castle
//
//  Created by Michael Robinson on 26/01/2013.
//  Copyright (c) 2013 GGJ13. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ggjActor : NSObject
{
}

@property CGPoint position;
@property (strong) UIImage *image;
@property CGPoint velocity;
@property CGSize size;
@property (strong) UIImageView *actorImageView;


@end
