//
//  GameObjectPool.m
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameObjectPool.h"
#import "Collidable.h"
#import "RecievesTouches.h"


@implementation GameObjectPool
@synthesize collisionObjects  = _collisionObjects;
@synthesize collidableObjects = _collidableObjects;
@synthesize touchableObjects = _touchableObjects;

-(id)initWithGameObjectType:(NSString *)_gameObjectType poolRegistrar:(id <PoolRegistrar>)_poolRegistrar{
    if((self = [super init])){
        NSString *textureFile = [_gameObjectType stringByAppendingString:@".png"];
        gameObjectType = _gameObjectType;
        poolRegistrar = _poolRegistrar;
        contextNode = [poolRegistrar contextNode];
        batchNode = [[CCSpriteBatchNode batchNodeWithFile:textureFile] retain];
        
        //get the proper z-order
        Class gameObjectClass = NSClassFromString(gameObjectType);
        GameObject *sampleSprite = [gameObjectClass alloc];
        sampleSprite.poolRegistrar = poolRegistrar;
        sampleSprite.remover = self;
        sampleSprite = [sampleSprite initWithBatchNode:batchNode];
        
        [contextNode addChild:batchNode z:[sampleSprite drawOrder]];
        [sampleSprite release];
        self.collisionObjects = [NSMutableArray array];
        self.collidableObjects = [NSMutableArray array];
        self.touchableObjects = [NSMutableArray array];
        deadCollisionObjects = [[NSMutableArray alloc] init];
        deadCollidableObjects = [[NSMutableArray alloc] init];
        deadTouchableObjects = [[NSMutableArray alloc] init];
        [_poolRegistrar registerSelf:self forKey:_gameObjectType];
    }
    return self;
}
-(GameObject *)placeObject:(CGPoint)position{
    GameObject *newObject = [self createObject];
    if(newObject){
        newObject.poolRegistrar = poolRegistrar;
        newObject.position = position;
        [self.collisionObjects addObject: newObject];
        if([newObject conformsToProtocol: @protocol(Collidable)]){
            [self.collidableObjects addObject:newObject];
        }
        if([newObject conformsToProtocol: @protocol(RecievesTouches)]){
            [self.touchableObjects addObject:newObject];
        }
        if(isUpsideDown){
            [newObject makeUpsideDown];
        }
    }
    return newObject;
}
-(GameObject *)createObject{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)] userInfo:nil];
}
//adds the objects to lists that will remove them later
-(void)removeObjectFromCollisionList:(GameObject *)deadObject{
    [deadCollisionObjects addObject: deadObject];
    if([self.collidableObjects containsObject: deadObject]){
        [deadCollidableObjects addObject: deadObject];
    }
    //I'm assuming that objects that are unable to be collided with are also unable to be interacted with
    if([self.touchableObjects containsObject:deadObject]){
        [deadTouchableObjects addObject: deadObject];
    }
}
-(void)removeObject:(GameObject *)deadObject{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)] userInfo:nil];
}
//The way objects are enumerated in the game loop requires that objects be removed 
//all at once at the end of each cycle, instead of just removing each object as it is requested
-(void)removeObjectsMarkedForRemoval{
    for(GameObject *deadObject in deadCollisionObjects){
        [self.collisionObjects removeObject:deadObject];
    }
    [deadCollisionObjects removeAllObjects];
    for(GameObject *deadObject in deadCollidableObjects){
        [self.collidableObjects removeObject:deadObject];
    }
    [deadCollidableObjects removeAllObjects];
    for(GameObject *deadObject in deadTouchableObjects){
        [self.touchableObjects removeObject:deadObject];
    }
    [deadTouchableObjects removeAllObjects];
}
-(void)makeUpsideDown{
    isUpsideDown = YES;
}
-(bool)isUpsideDown{
    return isUpsideDown;
}
-(void)dealloc{
    [batchNode release];
    [deadCollisionObjects release];
    [deadCollidableObjects release];
    [deadTouchableObjects release];
    [super dealloc];
}

@end
