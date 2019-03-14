//
//  StorBot.m
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StorBot.h"
#import "WanderBehavior.h"
#import "ShootingBehavior.h"
#import "SimpleAudioEngine.h"


@implementation StorBot
-(id)initWithBatchNode:(CCSpriteBatchNode *)batchNode{
    if((self = [super initWithBatchNode:batchNode])){
        self.tileMovementTime = kDefaultBadGuyMovementSpeed;
        self.currentAnimation = [self loadAnimation:@"StorBotWalking" frameCount:2 frameDuration:.7];
        self.moveBehavior = [[[WanderBehavior alloc] initWithBadGuy:self] autorelease];
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
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1], [CCCallFunc actionWithTarget:self selector:@selector(removeSelf)], nil]];
    self.currentAnimation = [self loadAnimation:@"StorBotDying" frameCount:2 frameDuration:.4];
    [self animate];
    [[SimpleAudioEngine sharedEngine] playEffect:@"Stornello.mp3"];
    [super die];
}
@end
