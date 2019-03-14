//
//  Bullet.m
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Bullet.h"
#import "Player.h"
#import "Block.h"
#import "SimpleAudioEngine.h"

@implementation Bullet
-(id)initWithBatchNode:(CCSpriteBatchNode *)batchNode{
    if((self = [super initWithBatchNode:batchNode])){
        self.tileMovementTime = kDefaultProjectileSpeed;
        self.currentAnimation = [self loadAnimation:@"Bullet" frameCount:3 frameDuration:.1];
        self.currentIdleFrameName = @"Bullet1.png";
        [self idle];
        firstTime = YES;
    }
    return self;
}
-(void)update:(ccTime)dt listOfBlocks:(NSArray *)blockList{
    if(firstTime){
        [[SimpleAudioEngine sharedEngine] playEffect:@"Pop.m4a"];
        [self startMoving];
        firstTime = NO;
    }
    [super update:dt listOfBlocks:blockList];
}
-(void)collisionWithSprite:(GameObject *)collider{
    if([collider isKindOfClass:[Player class]]){
        [(Player *)collider damage:kOneHit];
        [self removeSelfFromCollisionList];
        [self removeSelf];
    }else if([collider isKindOfClass:[Block class]]){
        [self removeSelfFromCollisionList];
        [[SimpleAudioEngine sharedEngine] playEffect:@"Thunk.m4v"];
        [self animate];
        [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.3], [CCCallFunc actionWithTarget:self selector:@selector(removeSelf)], nil]];
    }
}
-(void)removeSelf{
    [self idle];
    [self stopMovingNow];
    firstTime = YES;
    [super removeSelf];
}

@end
