//
//  Shark.m
//  Detonate
//
//  Created by Anthony Gabriele on 9/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Shark.h"
#import "SimpleAudioEngine.h"
#import "NoBacktrackBehavior.h"

@implementation Shark
-(id)initWithBatchNode:(CCSpriteBatchNode *)batchNode{
    if((self = [super initWithBatchNode:batchNode])){
        self.tileMovementTime = kDefaultBadGuyMovementSpeed * 0.66;
        self.currentAnimation = [self loadAnimation:@"SharkWalking" frameCount:3 frameDuration:.3];
        self.moveBehavior = [[[NoBacktrackBehavior alloc] initWithBadGuy:self] autorelease];
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
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:2.5], [CCCallFunc actionWithTarget:self selector:@selector(removeSelf)], nil]];
    self.currentAnimation = [self loadAnimation:@"SharkDeath" frameCount:5 frameDuration:.5];
    [self animate];
    [[SimpleAudioEngine sharedEngine] playEffect:@"Shark.mp3"];
    [super die];
}

@end
