//
//  GameObjectPool.h
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameObject.h"
#import "Remover.h"
#import "PoolRegistrar.h"


@interface GameObjectPool : NSObject <Remover> {
    CCNode *contextNode;
    id<PoolRegistrar> poolRegistrar;
    NSString *gameObjectType;
    CCSpriteBatchNode *batchNode;
    NSMutableArray *_collisionObjects;
    NSMutableArray *deadCollisionObjects;
    NSMutableArray *_collidableObjects;
    NSMutableArray *deadCollidableObjects;
    NSMutableArray *_touchableObjects;
    NSMutableArray *deadTouchableObjects;
    bool isUpsideDown;
}
-(id)initWithGameObjectType:(NSString *)_gameObjectType poolRegistrar:(id <PoolRegistrar>)poolRegistrar;
-(GameObject *)placeObject:(CGPoint)position;
-(GameObject *)createObject;
-(void)removeObjectFromCollisionList:(GameObject *)deadObject;
-(void)removeObject:(GameObject *)deadObject;
-(void)removeObjectsMarkedForRemoval;
-(void)makeUpsideDown;
-(bool)isUpsideDown;

@property (nonatomic, retain) NSMutableArray *collisionObjects;
@property (nonatomic, retain) NSMutableArray *collidableObjects;
@property (nonatomic, retain) NSMutableArray *touchableObjects;
@end
