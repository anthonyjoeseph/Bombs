//
//  FireLizard.m
//  Detonate
//
//  Created by Anthony Gabriele on 8/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FireLizard.h"
#import "SimpleAudioEngine.h"
#import "NoBacktrackBehavior.h"

@implementation FireLizard
-(id)initWithBatchNode:(CCSpriteBatchNode *)batchNode{
    if((self = [super initWithBatchNode:batchNode])){
        self.tileMovementTime = kDefaultBadGuyMovementSpeed * 1.25;
        self.currentAnimation = [self loadAnimation:@"FireLizardWalking" frameCount:4 frameDuration:.3];
        self.moveBehavior = [[[NoBacktrackBehavior alloc] initWithBadGuy:self] autorelease];
        GameObjectPool *projectilePool = [self.poolRegistrar poolWithKey:@"FireBall"];
        if(!projectilePool){
            projectilePool = [[[BufferPool alloc] initWithGameObjectType:@"FireBall" poolRegistrar:self.poolRegistrar capacity:35] autorelease];
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
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.999], [CCCallFunc actionWithTarget:self selector:@selector(removeSelf)], nil]];
    self.currentAnimation = [self loadAnimation:@"FireLizardDeath" frameCount:3 frameDuration:.333];
    [self animate];
    [[SimpleAudioEngine sharedEngine] playEffect:@"FireLizard.mp3"];
    [super die];
}
@end
