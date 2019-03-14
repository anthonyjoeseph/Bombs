//
//  Soldier.m
//  Detonate
//
//  Created by Anthony Gabriele on 9/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Soldier.h"
#import "WanderBehavior.h"
#import "StopForPlayerBehavior.h"
#import "SimpleAudioEngine.h"

@implementation Soldier
-(id)initWithBatchNode:(CCSpriteBatchNode *)batchNode{
    if((self = [super initWithBatchNode:batchNode])){
        self.tileMovementTime = kDefaultBadGuyMovementSpeed;
        self.currentAnimation = [self loadAnimation:@"SoldierWalking" frameCount:2 frameDuration:.7];
        self.moveBehavior = [[[StopForPlayerBehavior alloc] initWithBadGuy:self] autorelease];
        GameObjectPool *projectilePool = [self.poolRegistrar poolWithKey:@"Bullet"];
        if(!projectilePool){
            projectilePool = [[[BufferPool alloc] initWithGameObjectType:@"Bullet" poolRegistrar:self.poolRegistrar capacity:20] autorelease];
        }
        self.shootBehavior = [[[ShootingBehavior alloc] initWithBadGuy:self projectilePool:projectilePool reloadTime:0.3] autorelease];
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
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.6], [CCCallFunc actionWithTarget:self selector:@selector(removeSelf)], nil]];
    self.currentAnimation = [self loadAnimation:@"SoldierDeath" frameCount:4 frameDuration:.4];
    [self animate];
    [[SimpleAudioEngine sharedEngine] playEffect:@"Soldier.mp3"];
    [super die];
}

@end
