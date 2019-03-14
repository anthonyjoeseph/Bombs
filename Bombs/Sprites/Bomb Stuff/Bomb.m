//
//  Bomb.m
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Bomb.h"
#import "Block.h"
#import "Breakable.h"
#import "Constants.h"
#import "Explosion.h"
#import "SimpleAudioEngine.h"
#import "BufferPool.h"


@implementation Bomb
-(id)initWithBatchNode:(CCSpriteBatchNode *)batchNode{
    if((self = [super initWithBatchNode:batchNode])){
        explosionPool = [self.poolRegistrar poolWithKey:@"Explosion"];
        if(!explosionPool){
            explosionPool = [[BufferPool alloc] initWithGameObjectType:@"Explosion" poolRegistrar:self.poolRegistrar capacity:40];
        }
    }
    return self;
}
-(void)registerBombObserver:(id<BombObserver>)theObserver{
    bombObserver = theObserver;
    bombLength = [theObserver bombLength];
}
-(void)die{
    isDeadOnNextUpdateCycle = YES;
    //actually dies on the next update cycle
    //this method is only triggered by an explosion of another bomb
}
-(void)dieWithListOfBlocks:(NSArray *)blockList{
    [self removeSelfFromCollisionList];
    
    CGPoint selfPosition = self.position;
    int i;
    bool explodesBlock;
    CGPoint upward = ccp(selfPosition.x, selfPosition.y + kTileSize);
    CGPoint downward = ccp(selfPosition.x, selfPosition.y - kTileSize);
    CGPoint rightward = ccp(selfPosition.x + kTileSize, selfPosition.y);
    CGPoint leftward = ccp(selfPosition.x - kTileSize, selfPosition.y);
    
    i = 0;
    explodesBlock = YES;
    while(i < bombLength && [self placeExplosion:upward explodesBlock:explodesBlock listOfBlocks:blockList]){
        upward = ccp(upward.x, upward.y + kTileSize);
        explodesBlock = NO;
        i++;
    }
    i = 0;
    explodesBlock = YES;
    while(i < bombLength && [self placeExplosion:downward explodesBlock:explodesBlock listOfBlocks:blockList]){
        downward = ccp(downward.x, downward.y - kTileSize);
        explodesBlock = NO;
        i++;
    }
    i = 0;
    explodesBlock = YES;
    while(i < bombLength && [self placeExplosion:rightward explodesBlock:explodesBlock listOfBlocks:blockList]){
        rightward = ccp(rightward.x + kTileSize, rightward.y);
        explodesBlock = NO;
        i++;
    }
    i = 0;
    explodesBlock = YES;
    while(i < bombLength && [self placeExplosion:leftward explodesBlock:explodesBlock listOfBlocks:blockList]){
        explodesBlock = NO;
        leftward = ccp(leftward.x - kTileSize, leftward.y);
        i++;
    }
    [self placeExplosion:self.position explodesBlock:YES listOfBlocks:blockList];
    [self removeSelf];
}
//return YES if the bomb blast should continue in this direction
-(bool)placeExplosion:(CGPoint)position explodesBlock:(bool)doesExplodeBlock listOfBlocks:(NSArray *)blockList{
    Block<Breakable> *deadBlock;
    for(GameObject *currentObject in blockList){
        if(CGPointEqualToPoint(currentObject.position, position)){
            if([currentObject conformsToProtocol:@protocol(Breakable)] && doesExplodeBlock){
                deadBlock = (Block<Breakable> *)currentObject;
                [deadBlock die];
            }
            return NO;
        }
    }
    Explosion *explosion = (Explosion *)[explosionPool placeObject:position];
    [explosion startTimer];
    return YES;
}

@end
