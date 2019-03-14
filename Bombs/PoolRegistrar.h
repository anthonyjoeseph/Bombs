//
//  PoolRegistrar.h
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCNode.h"
@class GameObjectPool;


@protocol PoolRegistrar <NSObject>
-(CCNode *)contextNode;
-(GameObjectPool *)poolWithKey:(NSString *)gameObjectType;
-(void)registerSelf:(id)pool forKey:(NSString *)gameObjectType;
@end
