//
//  CreationPool.m
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CreationPool.h"


@implementation CreationPool

-(GameObject *)createObject{
    Class gameObjectClass = NSClassFromString(gameObjectType);
    GameObject *newSprite = [gameObjectClass alloc];
    newSprite.poolRegistrar = poolRegistrar;
    newSprite.remover = self;
    newSprite = [newSprite initWithBatchNode:batchNode];
    [batchNode addChild:newSprite];
    [newSprite release];
    return newSprite;
}
-(void)removeObject:(GameObject *)deadObject{
    [deadObject removeFromParentAndCleanup: YES];
}
@end
