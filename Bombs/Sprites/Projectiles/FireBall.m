//
//  FireBall.m
//  Detonate
//
//  Created by Anthony Gabriele on 8/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FireBall.h"
#import "Player.h"
#import "Block.h"
#import "SimpleAudioEngine.h"

@implementation FireBall
-(id)initWithBatchNode:(CCSpriteBatchNode *)batchNode{
    if((self = [super initWithBatchNode:batchNode])){
        self.tileMovementTime = kDefaultProjectileSpeed * 1.33;
        self.currentAnimation = [self loadAnimation:@"FireBall" frameCount:2 frameDuration:.2];
        self.currentIdleFrameName = @"FireBall1.png";
        [self animate];
        firstTime = YES;
    }
    return self;
}
-(void)update:(ccTime)dt listOfBlocks:(NSArray *)blockList{
    if(firstTime){
        [[SimpleAudioEngine sharedEngine] playEffect:@"Fireball.m4a"];
        [self startMoving];
        firstTime = NO;
    }
    [super update:dt listOfBlocks:blockList];
}
-(void)collisionWithSprite:(GameObject *)collider{
    if([collider isKindOfClass:[Player class]]){
        [(Player *)collider damage:kOneHit*2];
        [self removeSelfFromCollisionList];
        [self removeSelf];
    }else if([collider isKindOfClass:[Block class]]){
        [self removeSelfFromCollisionList];
        [[SimpleAudioEngine sharedEngine] playEffect:@"Thunk.m4v"];
        [self removeSelf];
    }
}
-(void)removeSelf{
    [self idle];
    [self stopMovingNow];
    firstTime = YES;
    [super removeSelf];
}

@end
