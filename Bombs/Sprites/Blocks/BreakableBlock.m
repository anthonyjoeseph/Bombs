//
//  BreakableBlock.m
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BreakableBlock.h"
#import "CreationPool.h"
#import "SimpleAudioEngine.h"


@implementation BreakableBlock
-(id)initWithBatchNode:(CCSpriteBatchNode *)batchNode{
    if((self = [super initWithBatchNode:batchNode])){
        self.currentAnimation = [self loadAnimation:@"BreakableBlock" frameCount:3 frameDuration:.33];
        self.currentIdleFrameName = @"BreakableBlock1.png";
        [self idle];
    }
    return self;
}
-(void)die{
    [[SimpleAudioEngine sharedEngine] playEffect:@"BreakableBlock.m4v"];
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
-(void)removeSelf{
    [super removeSelf];
}
-(void)dealloc{
    //[powerUps release];
    [super dealloc];
}
-(int)drawOrder{
    return 10;
}
@end
