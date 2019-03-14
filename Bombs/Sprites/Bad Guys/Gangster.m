//
//  Gangster.m
//  Detonate
//
//  Created by Anthony Gabriele on 9/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Gangster.h"
#import "WanderBehavior.h"
#import "ShootingBehavior.h"
#import "SimpleAudioEngine.h"

@implementation Gangster
-(id)initWithBatchNode:(CCSpriteBatchNode *)batchNode{
    if((self = [super initWithBatchNode:batchNode])){
        self.tileMovementTime = kDefaultBadGuyMovementSpeed;
        self.currentAnimation = [self loadAnimation:@"GangsterWalking" frameCount:3 frameDuration:.5];
        self.moveBehavior = [[[WanderBehavior alloc] initWithBadGuy:self] autorelease];
        GameObjectPool *projectilePool = [self.poolRegistrar poolWithKey:@"Bullet"];
        if(!projectilePool){
            projectilePool = [[[BufferPool alloc] initWithGameObjectType:@"Bullet" poolRegistrar:self.poolRegistrar capacity:35] autorelease];
        }
        self.shootBehavior = [[[ShootingBehavior alloc] initWithBadGuy:self projectilePool:projectilePool reloadTime:kDefaultProjectileReloadTime] autorelease];
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
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.5], [CCCallFunc actionWithTarget:self selector:@selector(removeSelf)], nil]];
    self.currentAnimation = [self loadAnimation:@"GangsterDeath" frameCount:3 frameDuration:.5];
    [self animate];
    [[SimpleAudioEngine sharedEngine] playEffect:@"Gangster.mp3"];
    [super die];
}

@end
