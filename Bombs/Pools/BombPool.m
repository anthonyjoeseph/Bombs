//
//  BombPool.m
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BombPool.h"
#import "Constants.h"
#import "Bomb.h"
#import "SimpleAudioEngine.h"


@implementation BombPool
-(id)initWithGameObjectType:(NSString *)_gameObjectType poolRegistrar:(id <PoolRegistrar>)_poolRegistrar capacity:(int)numSprites{
    if((self = [super initWithGameObjectType:_gameObjectType poolRegistrar:_poolRegistrar capacity:numSprites])){
        numBombs = 0;
        [self restoreDefaults];
        isUpsideDown = NO;
    }
    return self;
}
-(GameObject *)createObject{
    if(numBombs < maxNumBombs){
        numBombs++;
        Bomb *returnBomb = (Bomb *)[super createObject];
        [returnBomb registerBombObserver:self];
        [[SimpleAudioEngine sharedEngine] playEffect:@"Bomb.m4v"];
        return returnBomb;
    }
    return nil;
}
-(GameObject *)placeObject:(CGPoint)position{
    Bomb *placedBomb = (Bomb *)[super placeObject:position];
    [placedBomb registerBombObserver:self];
    return placedBomb;
}
-(void)bombDied{
    numBombs--;
}
-(int)bombLength{
    return bombLength;
}
-(float)bombDuration{
    return bombDuration;
}
-(void)heavyBombs{
    bombLength += 2;
}
-(void)lightBombs{
    maxNumBombs = 15;
}
-(void)restoreDefaults{
    maxNumBombs = kDefaultMaxNumBombs;
    bombLength = kDefaultBombLength;
    bombDuration = kDefaultBombTime;
}
-(void)removeObject:(GameObject *)deadObject{
    numBombs--;
    [super removeObject:deadObject];
}
@end
