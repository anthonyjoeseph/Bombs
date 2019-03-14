//
//  Bomb.h
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MovingObject.h"
#import "Killable.h"
#import "BombObservable.h"
#import "BombObserver.h"
//#import "BombBehavior.h"


@interface Bomb : MovingObject <Killable, BombObservable> {
    int bombLength;
    bool isDeadOnNextUpdateCycle;
    id<BombObserver> bombObserver;
    GameObjectPool *explosionPool;
}
-(void)registerBombObserver:(id<BombObserver>)theObserver;
-(void)die;
-(void)dieWithListOfBlocks:(NSArray *)blockList;
-(bool)placeExplosion:(CGPoint)position explodesBlock:(bool)doesExplodeBlock listOfBlocks:(NSArray *)blockList;

@end
