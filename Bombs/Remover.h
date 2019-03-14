//
//  Remover.h
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GameObject;

@protocol Remover <NSObject>
-(void)removeObjectFromCollisionList:(GameObject *)deadObject;
-(void)removeObject:(GameObject *)deadObject;
@end
