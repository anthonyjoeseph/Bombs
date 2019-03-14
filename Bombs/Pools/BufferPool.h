//
//  BufferFactory.h
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameObjectPool.h"


@interface BufferPool : GameObjectPool {
    NSMutableArray *bufferedObjects;
    int currentObjectIndex;
}
-(id)initWithGameObjectType:(NSString *)_gameObjectType poolRegistrar:(id <PoolRegistrar>)poolRegistrar capacity:(int)numSprites;

@end
