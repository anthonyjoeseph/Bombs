//
//  PowerUp.m
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PowerUp.h"
#import "Player.h"
#import "Constants.h"
#import "GamePreferences.h"
#import "SimpleAudioEngine.h"


@implementation PowerUp
-(id)initWithBatchNode:(CCSpriteBatchNode *)batchNode{
    if((self = [super initWithBatchNode:batchNode])){
        timeSinceStart = kPowerUpLifeTime;
        hasFadeBegun = NO;
        isEngaged = NO;
        whichPowerUp = [self randomPowerUp];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"PowerUp.plist"];
        self.currentIdleFrameName = [NSString stringWithFormat:@"%@.png", whichPowerUp];
        [self idle];
    }
    return self;
}
-(NSString *)randomPowerUp{
    int randomNum = rand() % 5;
    switch (randomNum) {
        case 0:
            return @"Faster";
        case 1:
            return @"HeavyBombs";
        case 2:
            return @"LightBombs";
        case 3:
            return @"Shield";
        case 4:
            return @"TapBombs";
    }
    return @"Oh no mr bill";
}
-(void)collisionWithSprite:(GameObject *)collider{
    if([collider isKindOfClass:[Player class]]){
        [[SimpleAudioEngine sharedEngine] playEffect:@"PowerUp.m4v"];
        isEngaged = YES;
        Player *thePlayer = (Player *)collider;
        Class gameObjectClass = NSClassFromString(whichPowerUp);
        ExtraPower *power = [[gameObjectClass alloc] init];
        power.affectedPlayer = thePlayer;
        [thePlayer registerNewPowerUp:power];
        [power release];
        [self removeSelfFromCollisionList];
        [self removeSelf];
    }
}
-(void)update:(ccTime)dt listOfBlocks:(NSArray *)blockList{
    [super update:dt listOfBlocks:blockList];
    if(!isEngaged){
        timeSinceStart -= dt;
        if(timeSinceStart < (kPowerUpLifeTime * 0.25) && !hasFadeBegun){
            [self fade];
            hasFadeBegun = YES;
        }
        if(timeSinceStart <= 0){
            [self removeSelfFromCollisionList];
            [self removeSelf];
        }
    }
}
-(void)fade{
    [self runAction:[CCFadeTo actionWithDuration: (kPowerUpLifeTime * 0.25) opacity:0]];
}
-(void)dealloc{
    [super dealloc];
}

@end
