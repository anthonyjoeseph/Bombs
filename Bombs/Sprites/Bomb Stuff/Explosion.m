//
//  Explosion.m
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Explosion.h"
#import "BadGuy.h"
#import "Killable.h"
#import "Player.h"
#import "Constants.h"


@implementation Explosion
-(id)initWithBatchNode:(CCSpriteBatchNode *)batchNode{
    if((self = [super initWithBatchNode:batchNode])){
        timeSinceStart = 0;
        timerGoing = NO;
        self.currentAnimation = [self loadAnimation:@"Explosion" frameCount:2 frameDuration:0.1];
        self.currentIdleFrameName = @"Explosion1.png";
        [self animate];
    }
    return self;
}
-(void)startTimer{
    timerGoing = YES;
}
-(void)update:(ccTime)dt listOfBlocks:(NSArray *)blockList{
    [super update:dt listOfBlocks:blockList];
    if(timerGoing){
        [super update:dt listOfBlocks:blockList];
        timeSinceStart += dt;
        if(timeSinceStart > kDefaultExplosionTime){
            timerGoing = NO;
            timeSinceStart = 0;
            [self removeSelfFromCollisionList];
            [self removeSelf];
        }
    }
}
-(void)collisionWithSprite:(GameObject *)otherObject{
    if([otherObject conformsToProtocol:@protocol(Killable)]){
        if([otherObject isKindOfClass:[Player class]]){
            [(Player *)otherObject damage:100 - kOneHit];
        }else{
            id<Killable> deadObject = (id<Killable>)otherObject;
            [deadObject die];
        }
    }
}
@end
