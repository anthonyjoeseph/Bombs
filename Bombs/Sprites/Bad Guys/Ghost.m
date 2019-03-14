//
//  Ghost.m
//  Detonate
//
//  Created by Anthony Gabriele on 1/8/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "Ghost.h"
#import "WanderBehavior.h"
#import "SimpleAudioEngine.h"

@implementation Ghost
-(id)initWithBatchNode:(CCSpriteBatchNode *)batchNode{
    if((self = [super initWithBatchNode:batchNode])){
        self.tileMovementTime = kDefaultBadGuyMovementSpeed * 1.25;
        self.currentAnimation = [self loadAnimation:@"GhostWalking" frameCount:3 frameDuration:.5];
        self.moveBehavior = [[[WanderBehavior alloc] initGoesThroughBreakableBlocksWithBadGuy:self] autorelease];
        [self animate];
    }
    return self;
}
-(void)collisionWithSprite:(GameObject *)otherObject{
    if([otherObject isKindOfClass:[Player class]]){
        [(Player *)otherObject damage:kOneHit];
    }
    [super collisionWithSprite:otherObject];
}
-(void)die{
    [self removeSelfFromCollisionList];
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.99], [CCCallFunc actionWithTarget:self selector:@selector(removeSelf)], nil]];
    self.currentAnimation = [self loadAnimation:@"GhostDying" frameCount:3 frameDuration:.33];
    [self animate];
    [[SimpleAudioEngine sharedEngine] playEffect:@"Ghost.mp3"];
    [super die];
}
-(int)drawOrder{
    return 11;
}

@end
