//
//  DpadInterface.m
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DpadInterface.h"
#import "SneakyJoystick.h"
#import "SneakyJoystickSkinnedBase.h"
#import "ColoredCircleSprite.h"
#import "SneakyButton.h"
#import "SneakyButtonSkinnedBase.h"
#import "Player.h"

@implementation DpadInterface

-(id)initIsUpsideDown:(bool)upsideDown isLarge:(bool)isLarge{
    if((self = [super init])){
        double screenWidth = [[CCDirector sharedDirector] winSize].width;
        double screenHeight = [[CCDirector sharedDirector] winSize].height;
        
        SneakyJoystickSkinnedBase *leftJoy = [[SneakyJoystickSkinnedBase alloc] init];
        CCSprite *joySprite = [CCSprite spriteWithFile:@"d-pad.png"];
        if(isLarge){
            if(!upsideDown){
                leftJoy.position = ccp(120, 120);
            }else{
                leftJoy.position = ccp(screenWidth - 120, screenHeight - 120);
            }
            joySprite.scale = 1.5;
        }else{
            if(!upsideDown){
                if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
                    leftJoy.position = ccp(screenWidth/2 - 170, 70);
                }else{
                    leftJoy.position = ccp(70, 70);
                }
            }else{
                leftJoy.position = ccp(screenWidth - 70, screenHeight - 90);
            }
        }
        leftJoy.backgroundSprite = joySprite;
        [leftJoy.backgroundSprite setOpacity:230];
        leftJoy.thumbSprite = [ColoredCircleSprite circleWithColor:ccc4(0, 0, 255, 200) radius:25];
        leftJoy.joystick = [[[SneakyJoystick alloc] initWithRect:CGRectMake(0,0,128,128)] autorelease];
        leftJoy.joystick.isDPad = YES;
        [self addChild:leftJoy];
        theJoysick = leftJoy.joystick;
        [leftJoy release];
        
        SneakyButtonSkinnedBase *rightBut = [[SneakyButtonSkinnedBase alloc] init];
        if(!upsideDown){
            rightBut.position = ccp(screenWidth - 70, 70);
        }else{
            rightBut.position = ccp(70, screenHeight - 70);
        }
        rightBut.defaultSprite = [ColoredCircleSprite circleWithColor:ccc4(255, 255, 255, 128) radius:50];
        rightBut.activatedSprite = [ColoredCircleSprite circleWithColor:ccc4(255, 255, 255, 255) radius:50];
        rightBut.pressSprite = [ColoredCircleSprite circleWithColor:ccc4(255, 0, 0, 255) radius:50];
        rightBut.button = [[[SneakyButton alloc] initWithRect:CGRectMake(0, 0, 100, 100)] autorelease];
        rightBut.button.isToggleable = NO;
        [self addChild:rightBut];
        theButton = rightBut.button;
        [rightBut release];
        
        isMoving = NO;
        timeSinceBomb = 1;
        
        [self schedule:@selector(update:)];
    }
    return self;
}
-(void)update:(ccTime)dt{
    if(theJoysick.velocity.x != 0 || theJoysick.velocity.y != 0){
        if(theJoysick.velocity.x == 1){
            joyDirection = kRight;
        }
        if(theJoysick.velocity.x == -1){
            joyDirection = kLeft;
        }
        if(theJoysick.velocity.y == 1){
            joyDirection = kUp;
        }
        if(theJoysick.velocity.y == -1){
            joyDirection = kDown;
        }
        if(self.controlPlayer.direction != joyDirection){
            self.controlPlayer.direction = joyDirection;
        }
        //if(!isMoving){
        isMoving = YES;
        [self.controlPlayer startMoving];
        //}
    }else if(isMoving){//if the joystick isn't moving, but the player still is
        [self.controlPlayer stopMoving];
        isMoving = NO;
    }
    
    if(theButton.active && timeSinceBomb > .01){
        [self.controlPlayer spawnBomb];
        timeSinceBomb = 0;
    }else{
        timeSinceBomb += dt;
    }
}

@end
