//
//  BufferPool.m
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BufferPool.h"
#import "GameObject.h"


@implementation BufferPool
-(id)initWithGameObjectType:(NSString *)_gameObjectType poolRegistrar:(id <PoolRegistrar>)_poolRegistrar capacity:(int)numSprites{
    if((self = [super initWithGameObjectType:_gameObjectType poolRegistrar:_poolRegistrar])){
        bufferedObjects = [[NSMutableArray alloc] init];
        Class gameObjectClass = NSClassFromString(gameObjectType);
        GameObject *newSprite;
        for(int i = 0; i < numSprites; i++){
            newSprite = [gameObjectClass alloc];
            newSprite.remover = self;
            newSprite.poolRegistrar = poolRegistrar;
            [newSprite initWithBatchNode:batchNode];
            [batchNode addChild:newSprite];
            newSprite.position = ccp(-100, -100);
            [bufferedObjects addObject: newSprite];
            [newSprite release];
        }
        currentObjectIndex = 0;
    }
    return self;
}
-(GameObject *)placeObject:(CGPoint)position{
    bool isSpaceAvailable = YES;
    for(GameObject *currentObject in self.collisionObjects){
        if(CGPointEqualToPoint(currentObject.position, position)){
            isSpaceAvailable = NO;
        }
    }
    if(isSpaceAvailable){
        return [super placeObject:position];
    }
    return nil;
}
-(GameObject *)createObject{
    currentObjectIndex++;
    if(currentObjectIndex >= [bufferedObjects count]){
        currentObjectIndex = 0;
    }
    GameObject *bufferedObject = [bufferedObjects objectAtIndex:currentObjectIndex];
    return bufferedObject;
}
-(void)removeObject:(GameObject *)deadObject{
    deadObject.position = ccp(-100, -100);
}
-(void)dealloc{
    [bufferedObjects release];
    [super dealloc];
}
@end
