//
//  GameObject.h
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Remover.h"
#import "PoolRegistrar.h"
#import "Constants.h"

@interface GameObject : CCSprite {
    GameDirection _direction;
    id<Remover> _remover;
    id<PoolRegistrar> _poolRegistrar;
    //by setting this variable, you change the animation of this object
    CCAnimation *_currentAnimation;
    CCAction *currentAnimateAction;
    NSString *_currentIdleFrameName;
    CCSpriteFrame *currentIdleFrame;
    bool animating;
    bool isUpsideDown;
}
-(id)initWithBatchNode:(CCSpriteBatchNode *)batchNode;
-(void)animate;
-(void)idle;
-(void)updateView;
-(CCAnimation *)loadAnimation:(NSString *)fileName frameCount:(int)numFrames frameDuration:(float)delay;
-(CGPoint)tileCenterNearestSelf;
-(void)update:(ccTime)dt listOfBlocks:(NSArray *)blockList;
-(void)removeSelfFromCollisionList;
-(void)removeSelf;
-(int)drawOrder;
-(void)makeUpsideDown;
-(bool)isUpsideDown;


@property (nonatomic, assign) GameDirection direction;
@property (nonatomic, assign) id<Remover> remover;
@property (nonatomic, assign) id<PoolRegistrar> poolRegistrar;
@property (nonatomic, retain) NSString *currentIdleFrameName;
@property (nonatomic, retain) CCAnimation *currentAnimation;
@end
