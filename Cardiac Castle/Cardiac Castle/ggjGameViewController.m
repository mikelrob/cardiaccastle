//
//  ggjGameViewController.m
//  Cardiac Castle
//
//  Created by Michael Robinson on 26/01/2013.
//  Copyright (c) 2013 GGJ13. All rights reserved.
//

#import "ggjGameViewController.h"
#import "ggjMonsterActor.h"
#import "ggjObstacleActor.h"

@interface ggjGameViewController ()

@end

@implementation ggjGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    NSLog(@"stuff");
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    isStillCounting = NO;
    isPlaying = NO;
    redIsHigh = NO;
    redWasHigh = NO;
    isFirstFlipFound = NO;
    highValue = 0.0;
    lowValue = 1.0;
    midValue = 0.0;
    valuesArray = [NSMutableArray new];
    redsArray = [NSMutableArray new];
    ratesArray = [NSMutableArray new];
    
    measureQueue = dispatch_queue_create("cameraQueue", NULL);
    
    backgroundImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"brick" ofType:@"png"]];
    
    motionManager = [[CMMotionManager alloc] init];
    
    [self measureHeartRate];
    
    NSLog(@"Hello");
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setupBackgroundImage
{
 
    [[self BGImage] setImage:backgroundImage];
    
}

- (void) measureHeartRate
{
    
    isMeasuring = YES;
    [self setupCaptureSession];
    [self startMeasurementLoop];
    
}


- (void) spawnPlayer
{
    [self setPlayer: [[ggjPlayerActor alloc]init]];
    [[self player] setPosition: CGPointMake( [[self view] frame].origin.x + (0.5 * [[self view] frame].size.width) , [[self view] frame].origin.y + (0.5 * [[self view] frame].size.height))];
    
    [[self player] setVelocity:CGPointMake(0.01, 0)];
    self.playerSprite = [[UIImageView alloc] initWithImage:self.player.image];
    CGRect playerSpriteRect = CGRectMake(self.player.position.x, self.player.position.y,
                                         self.player.size.width, self.player.size.height);
    self.playerSprite.frame = playerSpriteRect;
    
    [self.view addSubview:self.playerSprite];
}

- (void) spawnMonsters
{
    [[self monsterFactory] setHeartRate:heartRate];
    if ( [self.monsterFactory shouldSpawnThisWave] )
    {
        ggjMonsterActor *newMonster = [self.monsterFactory spawnActor];
        CGPoint startPosition = self.player.position;
        startPosition.y = self.view.frame.size.height - newMonster.size.height;
        newMonster.position = startPosition;
        
        CGRect startFrame = CGRectMake(newMonster.position.x, newMonster.position.y,
                                       newMonster.size.width, newMonster.size.height);
        newMonster.actorImageView.frame = startFrame;

        dispatch_async(dispatch_get_main_queue(),^{
            [self.view addSubview:newMonster.actorImageView];
        });
        
        [self.monsters addObject:newMonster];
        
        NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"spawn" ofType:@"mp3"];
        NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
        
        if (![[self audioPlayer] isPlaying])
        {
            _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
            _audioPlayer.numberOfLoops = 0;
            [[self audioPlayer] setVolume:0.5];
            [_audioPlayer play];
        }
        
    }
}

- (void) spawnObstacles
{
    [[self obstacleFactory] setHeartRate:heartRate];
    if ( [self.obstacleFactory shouldSpawnThisWave] )
    {
        ggjObstacleActor *newObstacle = [self.obstacleFactory spawnActor];
        CGFloat oneFifthWidth = self.view.frame.size.width / 5;
        CGFloat randomNumber = rand() %5;
        CGPoint startPosition = CGPointMake(randomNumber * oneFifthWidth, 0);
        newObstacle.position = startPosition;
        
        CGRect startFrame = CGRectMake(newObstacle.position.x, newObstacle.position.y,
                                       newObstacle.size.width, newObstacle.size.height);
        newObstacle.actorImageView.frame = startFrame;
        
        dispatch_async(dispatch_get_main_queue(),^{
            [self.view addSubview:newObstacle.actorImageView];
        });
        
        [self.obstacles addObject:newObstacle];
    }
}

- (void) moveMonsters: (NSTimeInterval) timeElapsed
{
    int i = [[self monsters] count] - 1;
    for (; i >= 0; --i)
    {
        ggjMonsterActor *monster = [self.monsters objectAtIndex:i];
        CGPoint newPosition = monster.position;
        newPosition.x += timeElapsed * 0.1 * (self.player.position.x - monster.position.x);
        newPosition.y += timeElapsed * 0.1 * (self.player.position.y - monster.position.y);;
        monster.position = newPosition;
        dispatch_async(dispatch_get_main_queue(), ^{
             [UIView animateWithDuration:timeElapsed animations:^{
                 CGRect newRect = monster.actorImageView.frame;
                 newRect.origin.x = monster.position.x;
                 newRect.origin.y = monster.position.y;
                 monster.actorImageView.frame = newRect;
            }];
         });
        
        for (ggjObstacleActor *obstacle in self.obstacles)
        {
            CGFloat xDist = (obstacle.position.x - monster.position.x);
            CGFloat yDist = (obstacle.position.y - monster.position.y);
            CGFloat distance = sqrt((xDist * xDist) + (yDist * yDist));
            if (distance <= 10)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[monster actorImageView] removeFromSuperview];
                });
                [self.monsters removeObject:monster];
                [self.monsterFactory setNumActorsAlive: self.monsterFactory.numActorsAlive - 1];
                
                NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"monster death" ofType:@"wav"];
                NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
                
                if ([[self audioPlayer] isPlaying])
                {
                    [[self audioPlayer] stop];
                }
                
                _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
                _audioPlayer.numberOfLoops = 0;
                
                [[self audioPlayer] setVolume:0.5];
                
                [_audioPlayer play];
            }
        }
    }

}

- (void) moveObstacles: (NSTimeInterval) timeElapsed
{
    int i = [[self obstacles] count] - 1;
    for (; i >= 0; --i)
    {
        ggjObstacleActor *obstacle = [self.obstacles objectAtIndex:i];
        CGPoint newPostion = obstacle.position;
        newPostion.y -= timeElapsed * 30 * obstacle.velocity.y;
        obstacle.position = newPostion;
        
        if (newPostion.y > self.view.frame.size.height + obstacle.size.height)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[obstacle actorImageView] removeFromSuperview];
            });
            [self.obstacles removeObject:obstacle];
//            NSLog(@"removed obstacle, count: %i, subviews: %i", [[self obstacles] count], self.view.subviews.count);
            [self.obstacleFactory setNumActorsAlive: self.obstacleFactory.numActorsAlive - 1];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [UIView animateWithDuration:timeElapsed animations:^{
                    CGRect newFrame = obstacle.actorImageView.frame;
                    newFrame.origin.y = obstacle.position.y;
                    obstacle.actorImageView.frame = newFrame;
                }];

            });
        }
    }
}

- (void) moveBackground: (NSTimeInterval) timeElapsed
{
    //scroll background and cumulatively total the points moved
//    self.victoryChecker.playerDistanceTravelled += timeElapsed;
    
}

- (void) movePlayer: (NSTimeInterval) timeElapsed
{

    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:timeElapsed animations:^{
            CGRect newFrame = self.playerSprite.frame;
            CGFloat newOriginX = newFrame.origin.x + ([[motionManager gyroData] rotationRate].y * 6);
            CGFloat newOriginY = newFrame.origin.y + ( [[motionManager gyroData] rotationRate].x * 6);
            if (newOriginX + newFrame.size.width > [[self view] frame].size.width)
            {
                newOriginX = self.view.frame.size.width - newFrame.size.width;
            }
            else if (newOriginX  < 0)
            {
                newOriginX = 0;
            }
            
            if (newOriginY + newFrame.size.height > 0.75 * [[self view] frame].size.height)
            {
                newOriginY = 0.75 * [[self view] frame].size.height - newFrame.size.height;
            }
            else if (newOriginY + newFrame.size.height < 0.25 * [[self view] frame].size.height)
            {
                newOriginY = 0.25 * [[self view] frame].size.height - newFrame.size.height;
            }
            
            newFrame.origin.x = newOriginX;
            newFrame.origin.y = newOriginY;
            self.player.position = newFrame.origin;
            self.playerSprite.frame = newFrame;
        }];

    });
    
    for (ggjObstacleActor *obstacle in self.obstacles)
    {
        CGFloat xDist = (obstacle.position.x - self.player.position.x);
        CGFloat yDist = (obstacle.position.y - self.player.position.y);
        CGFloat distance = sqrt((xDist * xDist) + (yDist * yDist));
        if (distance <= 10)
        {
            [self stopGameLoop];
            
            NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"player death by obstacle" ofType:@"mp3"];
            NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
            
            if ([[self audioPlayer] isPlaying])
            {
                [[self audioPlayer] stop];
            }
            
            _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
            _audioPlayer.numberOfLoops = 0;
            [[self audioPlayer] setVolume:0.5];
            [_audioPlayer play];
        }
    }
    
    for (ggjMonsterActor *monster in self.monsters)
    {
        CGFloat xDist = (monster.position.x - self.player.position.x);
        CGFloat yDist = (monster.position.y - self.player.position.y);
        CGFloat distance = sqrt((xDist * xDist) + (yDist * yDist));
        if (distance <= 10)
        {
            [self stopGameLoop];
            
            NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"player death by monster" ofType:@"mp3"];
            NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
            
            if ([[self audioPlayer] isPlaying])
            {
                [[self audioPlayer] stop];
            }
            
            _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
            _audioPlayer.numberOfLoops = 0;
            [[self audioPlayer] setVolume:0.5];
            [_audioPlayer play];
        }
    }
    
}

-(UIImage*) drawSprite:(UIImage*) fgImage
              inImage:(UIImage*) bgImage
              atPoint:(CGPoint)  point
{
    UIGraphicsBeginImageContextWithOptions(bgImage.size, FALSE, 0.0);
    [bgImage drawInRect:CGRectMake( 0, 0, bgImage.size.width, bgImage.size.height)];
    [fgImage drawInRect:CGRectMake( point.x, point.y, fgImage.size.width, fgImage.size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void) startGameLoop
{
    //prevent device from sleeping due to lack of touch input
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    [motionManager startGyroUpdates];
    
    [self setMonsterFactory: [[ggjMonsterFactory alloc] init]];
    [[self monsterFactory] setMonsterImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"mon2_walk" ofType:@"png"]]];
//    [[self monsterFactory] setActorToSpawn: [[ggjMonsterActor alloc] init]];
    [[self monsterFactory] setDistTravelled:0.0];
    [[self monsterFactory] setBaseSpawnProb:0.003];
    [[self monsterFactory] setHeartRate:heartRate];
    [[self monsterFactory] setNumActorsAlive:0];
    self.monsters = [NSMutableArray new];
    
    
    [self setObstacleFactory: [[ggjObstacleFactory alloc] init]];
    [[self obstacleFactory] setObstacleImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"spikes" ofType:@"png"]]];
//    [[self obstacleFactory] setActorToSpawn: [[ggjObstacleActor alloc] init]];
    [[self obstacleFactory] setDistTravelled:0.0];
    [[self obstacleFactory] setBaseSpawnProb:0.03];
    [[self obstacleFactory] setHeartRate:heartRate];
    [[self obstacleFactory] setNumActorsAlive:0];
    self.obstacles = [NSMutableArray new];
    
    
    [self setVictoryChecker: [[ggjVictoryChecker alloc] init]];
//    [[self victoryChecker] setMonsterFactory:[self monsterFactory]];
    [[self victoryChecker] setPlayerDistanceTravelled:0.0];
    [[self victoryChecker] setPlayerPosition: [[self player] position]];
//    [[self victoryChecker] setMonsterPositions: [@[] mutableCopy]];
//    [[self victoryChecker] setObstaclePositions: [@[] mutableCopy]];
    
    [self setupBackgroundImage];
    [self spawnPlayer];
    distanceTravelled = 0;
    
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"heart beat" ofType:@"mp3"];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    
    [self setBGAudioPlayer: [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil]];
    [[self BGAudioPlayer] setEnableRate:YES];
    [[self BGAudioPlayer] setRate:1.0];
    [[self BGAudioPlayer] setVolume:0.7];
    [[self BGAudioPlayer] setNumberOfLoops:-1];
    [[self BGAudioPlayer] prepareToPlay];
    [[self BGAudioPlayer] play];
    
    gameLoopQueue = dispatch_queue_create("cardiacCastleGameLoopQueue", NULL);
    
    __block NSDate *lastLoopDate = [NSDate date];
    dispatch_async(gameLoopQueue, ^{
       
        while (isPlaying)
        {
            NSDate *currentTime = [NSDate date];
            
            timeElapsedThisLoop = [currentTime timeIntervalSinceDate: lastLoopDate];
            
            if (timeElapsedThisLoop >= 0.03)
            {
                lastLoopDate = currentTime;
                
                distanceTravelled += timeElapsedThisLoop * 5;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[self HRLabel] setText:[ NSString stringWithFormat:@"%im", (int) distanceTravelled ]];
                    [[self HRLabel] setNeedsDisplay];
                });
                
                if (heartRate > 75)
                {
                    [[self BGAudioPlayer] setRate:2.0];
                    [[self BGAudioPlayer] setVolume:1.0];
                }
                else
                {
                    [[self BGAudioPlayer] setRate:1.0];
                    [[self BGAudioPlayer] setVolume:0.7];
                }
                
                [self moveBackground: timeElapsedThisLoop];
                [self moveObstacles: timeElapsedThisLoop];
                [self movePlayer:timeElapsedThisLoop];
                [self moveMonsters: timeElapsedThisLoop];
                
                if(NO == [[self victoryChecker] endGame])
                {
                    [self spawnMonsters];
                    [self spawnObstacles];
                }
            }
        }
    });
}

- (void) stopGameLoop
{
    isPlaying = NO;
    
    //allow device to sleep as game has stopped
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    
    [motionManager stopGyroUpdates];
    
    dispatch_async(dispatch_get_main_queue(), ^{
//        [[self HRLabel] setText:@"DEAD!"];
//        [[self HRLabel] setNeedsDisplay];
        
        UIImage *gameOverImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"game over" ofType:@"png"]];
        UIImageView *gameOverView = [[UIImageView alloc] initWithImage: gameOverImage];
        
        [gameOverView setFrame: CGRectMake((self.view.frame.size.width - gameOverImage.size.width) / 2, (self.view.frame.size.height - gameOverImage.size.height) / 2, gameOverImage.size.width, gameOverImage.size.height)];
        
        [[self view] addSubview:gameOverView];
        [[self BGAudioPlayer] stop];
    });
}

- (void) startMeasurementLoop
{
    isStillCounting = YES;
    measuringTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(finishMeasuring) userInfo:nil repeats:NO];
}

- (void) finishMeasuring
{
    isStillCounting = NO;
    CGFloat totalValue = 0.0;
    for (NSNumber *number in valuesArray)
    {
        totalValue += [number floatValue];
    }
    
    valuesCount = [valuesArray count];
    midValue = totalValue / valuesCount;
    lastFlipTime = [[NSDate date] timeIntervalSinceReferenceDate];
    isPlaying = YES;
    [self startGameLoop];
}

struct pixel {
    unsigned char r, g, b, a;
};

- (UIColor*) getDominantColor:(UIImage*)image
{
    NSUInteger red = 0;
    NSUInteger green = 0;
    NSUInteger blue = 0;
    
    
    // Allocate a buffer big enough to hold all the pixels
    
    struct pixel* pixels = (struct pixel*) calloc(1, image.size.width * image.size.height * sizeof(struct pixel));
    if (pixels != nil)
    {
        
        CGContextRef context = CGBitmapContextCreate(
                                                     (void*) pixels,
                                                     image.size.width,
                                                     image.size.height,
                                                     8,
                                                     image.size.width * 4,
                                                     CGImageGetColorSpace(image.CGImage),
                                                     kCGImageAlphaPremultipliedLast
                                                     );
        
        if (context != NULL)
        {
            // Draw the image in the bitmap
            
            CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, image.size.width, image.size.height), image.CGImage);
            
            // Now that we have the image drawn in our own buffer, we can loop over the pixels to
            // process it. This simple case simply counts all pixels that have a pure red component.
            
            // There are probably more efficient and interesting ways to do this. But the important
            // part is that the pixels buffer can be read directly.
            
            NSUInteger numberOfPixels = image.size.width * image.size.height;
            for (int i=0; i<numberOfPixels; i++) {
                red += pixels[i].r;
                green += pixels[i].g;
                blue += pixels[i].b;
            }
            
            
            red /= numberOfPixels;
            green /= numberOfPixels;
            blue/= numberOfPixels;
            
            
            CGContextRelease(context);
        }
        
        free(pixels);
    }
    return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1.0f];
}

// Create and configure a capture session and start it running
- (void)setupCaptureSession
{
    NSError *error = nil;
    
    // Create the session
    session = [[AVCaptureSession alloc] init];
    
    // Configure the session to produce lower resolution video frames, if your
    // processing algorithm can cope. We'll specify medium quality for the
    // chosen device.
    session.sessionPreset = AVCaptureSessionPresetMedium;
    
    // Find a suitable AVCaptureDevice
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device == nil)
    {
        isStillCounting = NO;
        isPlaying = YES;
        heartRate = 60;
        return;
    }
    if ([device hasTorch])
    {
        
        [device lockForConfiguration:nil];
        [device setTorchMode:AVCaptureTorchModeOn];
        //        [device setFlashMode:AVCaptureFlashModeOn];
        [device unlockForConfiguration];
    }
    
    if ([device isFocusModeSupported:AVCaptureFocusModeLocked])
    {
        [device lockForConfiguration:nil];
        [device setFocusMode:AVCaptureFocusModeLocked];
        [device unlockForConfiguration];
    }
    
    // Create a device input with the device and add it to the session.
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device
                                                                        error:&error];
    if (!input) {
        // Handling the error appropriately.
    }
    [session addInput:input];
    
    // Create a VideoDataOutput and add it to the session
    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
    [session addOutput:output];
    
    // Configure your output.
    myQueue = dispatch_queue_create("myQueue", NULL);
    [output setSampleBufferDelegate:self queue:myQueue];
    
    // Specify the pixel format
    output.videoSettings =
    [NSDictionary dictionaryWithObject:
     [NSNumber numberWithInt:kCVPixelFormatType_32BGRA]
                                forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    
    
    // If you wish to cap the frame rate to a known value, such as 15 fps, set
    // minFrameDuration.
    //    output.minFrameDuration = CMTimeMake(1, 15);
    
    // Start the session running to start the flow of data
    [session startRunning];
}

// Delegate routine that is called when a sample buffer was written
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
        // Create a UIImage from the sample buffer data
        CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        CVPixelBufferLockBaseAddress(imageBuffer, 0);
        
        uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer);
        size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
        size_t width = CVPixelBufferGetWidth(imageBuffer);
        size_t height = CVPixelBufferGetHeight(imageBuffer);
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef newContext = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
        CGImageRef newImage = CGBitmapContextCreateImage(newContext);
        
        CGContextRelease(newContext);
        CGColorSpaceRelease(colorSpace);
        UIImage *image = [UIImage imageWithCGImage:newImage scale:1.0 orientation:UIImageOrientationLeftMirrored];
        
    UIColor *color = [self getDominantColor:image];
        //    NSLog(@"%@", color);
        
        CGColorRef cgColor = [color CGColor];
        
        const CGFloat *components = CGColorGetComponents(cgColor);
        CGFloat red = components[0];
    
        if ([redsArray count] > 0)
        {
            movingRedAve = movingRedAve + red/([redsArray count]+1) - [[redsArray objectAtIndex:0] floatValue]/([redsArray count]+1);
            if ([redsArray count] > 5)
            {
                [redsArray removeObjectAtIndex:0];
            }
            [redsArray addObject: [NSNumber numberWithFloat:red]];
        }
        else
        {
            movingRedAve = red;
        }
        
        
        if (isStillCounting)
        {
            [valuesArray addObject:[NSNumber numberWithFloat:red ]];
            if (movingRedAve > highValue)
            {
                highValue = movingRedAve;
            }
            
            if (movingRedAve < lowValue)
            {
                lowValue = movingRedAve;
            }
        }
        
        if (isPlaying)
        {
            CGFloat poppedValue = [[valuesArray objectAtIndex:0] floatValue];
            midValue = midValue + (movingRedAve/valuesCount) - (poppedValue/valuesCount);
            if (midValue > 1.0)
            {
                NSLog(@"derp!");
            }
            
            redIsHigh = (movingRedAve > midValue) ? YES : NO;
            
            if (redIsHigh && !redWasHigh)
            {
                NSTimeInterval timeNow = [[NSDate date] timeIntervalSinceReferenceDate];
                NSTimeInterval timeSinceLastFlip = timeNow - lastFlipTime;
                lastFlipTime = timeNow;
                
                if (isFirstFlipFound)
                {
                    CGFloat newRate = 60.0/timeSinceLastFlip;
                    [ratesArray addObject: [NSNumber numberWithFloat:newRate]];
                    
                    if ([ratesArray count] > 0)
                    {
                        CGFloat averageRate = 0.0;
                        for (NSNumber *rate in ratesArray)
                        {
                            averageRate += [rate floatValue];
                        }
                        averageRate /= [ratesArray count];
                        
                        heartRate = averageRate;
                        
                    }
                    else
                    {
                        heartRate = newRate;
                    }
                    
                    if ([ratesArray count] > 10)
                    {
                        [ratesArray removeObjectAtIndex:0];
                    }
                    
                }
                else
                {
                    isFirstFlipFound = YES;
                }
                
                NSLog(@"heartRate: %f", heartRate);
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [[self HRLabel] setText: [NSString stringWithFormat:@"%f", heartRate ]];
//                    [[self HRLabel] setNeedsDisplay];
//                });
            }
            
            redWasHigh = redIsHigh;
            
            [valuesArray removeObjectAtIndex:0];
            [valuesArray addObject: [NSNumber numberWithFloat:movingRedAve ]];
            
        }
        
        CGImageRelease(newImage);
        CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
        
}


@end
