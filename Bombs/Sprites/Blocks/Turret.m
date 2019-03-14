//
//  Turret.m
//  Detonate
//
//  Created by Anthony Gabriele on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Turret.h"
#import "CreationPool.h"
#import "BufferPool.h"
#import "Bullet.h"
#import "SimpleAudioEngine.h"
#import "PowerUp.h"
#import "ShootingBehavior.h"
#import "SurveyBehavior.h"

@implementation Turret
@synthesize shootBehavior = _shootBehavior;
@synthesize rotateBehavior = _rotateBehavior;

-(id)initWithBatchNode:(CCSpriteBatchNode *)batchNode{
    if((self = [super initWithBatchNode:batchNode])){
        self.currentAnimation = [self loadAnimation:@"Turret" frameCount:3 frameDuration:.33];
        self.currentIdleFrameName = @"Turret1.png";
        [self idle];
        GameObjectPool *projectilePool = [self.poolRegistrar poolWithKey:@"Bullet"];
        if(!projectilePool){
            projectilePool = [[[BufferPool alloc] initWithGameObjectType:@"Bullet" poolRegistrar:self.poolRegistrar capacity:35] autorelease];
        }
        self.shootBehavior = [[[ShootingBehavior alloc] initWithBadGuy:self projectilePool:projectilePool reloadTime:kDefaultProjectileReloadTime] autorelease];
    }
    return self;
}
-(void)makeUpsideDown{
    //overrides the behavior so that it doesn't actually switch itself upside down because its direction matters
    isUpsideDown = YES;
}
-(void)addProperties:(NSDictionary *)properties{
    NSString *directionString = [properties valueForKey:@"Direction"];
    if([directionString isEqualToString:@"kRight"]){
        self.direction = kRight;
    }
    if([directionString isEqualToString:@"kDown"]){
        self.direction = kDown;
    }
    if([directionString isEqualToString:@"kLeft"]){
        self.direction = kLeft;
    }
    if([directionString isEqualToString:@"kUp"]){
        self.direction = kUp;
    }
    if([directionString isEqualToString:@"Rotate"]){
        self.direction = kRight;
        self.rotateBehavior = [[[SurveyBehavior alloc] initWithBadGuy:self] autorelease];
    }
}
-(void)registerPlayerOne:(Player *)playerOne playerTwo:(Player *)playerTwo{
    [self.shootBehavior registerPlayerOne:playerOne playerTwo:playerTwo];
}
-(void)update:(ccTime)dt listOfBlocks:(NSArray *)blockList{
    [self.rotateBehavior update:dt listOfBlocks:blockList];
    [self.shootBehavior update:dt listOfBlocks:blockList];
}
-(void)collisionWithSprite:(GameObject *)otherObject{
    [self.shootBehavior collisionWithSprite:otherObject];
}
-(void)die{
    [[SimpleAudioEngine sharedEngine] playEffect:@"BreakableBlock.m4v"];
    [[SimpleAudioEngine sharedEngine] playEffect:@"Turret.m4v"];
    [self animate];
    [self removeSelfFromCollisionList];
    int chance = rand() % 15;
    if(chance == 0){
        GameObjectPool *tempPool = [self.poolRegistrar poolWithKey:@"PowerUp"];
        if(!tempPool){
            tempPool = [[[CreationPool alloc] initWithGameObjectType:@"PowerUp" poolRegistrar:self.poolRegistrar] autorelease];
        }
        [tempPool placeObject:self.position];
    }
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.99], [CCCallFunc actionWithTarget:self selector:@selector(removeSelf)], nil]];
}
@end
