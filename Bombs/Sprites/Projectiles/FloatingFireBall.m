//
//  FloatingFireBall.m
//  Detonate
//
//  Created by Anthony Gabriele on 1/10/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "FloatingFireBall.h"

@implementation FloatingFireBall
@synthesize xSpeed = _xSpeed;
@synthesize ySpeed = _ySpeed;

-(id)initWithBatchNode:(CCSpriteBatchNode *)batchNode{
    if((self = [super initWithBatchNode:batchNode])){
        self.currentAnimation = [self loadAnimation:@"FloatingFireBall" frameCount:2 frameDuration:.2];
        [self animate];
        firstTime = YES;
    }
    return self;
}
-(void)update:(ccTime)dt listOfBlocks:(NSArray *)blockList{
    double winWidth = kTileSize * kBoardWidthInTiles;
    double winHeight = kTileSize * kBoardHeightInTiles;
    CGPoint currentPosition = self.position;
    if(currentPosition.x < 0 || currentPosition.y < 0 || currentPosition.x > winWidth || currentPosition.y > winHeight){
        [self removeSelfFromCollisionList];
        [self removeSelf];
    }
    self.position = ccp(currentPosition.x + (dt*self.xSpeed), currentPosition.y + (dt*self.ySpeed));
    [super update:dt listOfBlocks:blockList];
}
-(void)collisionWithSprite:(GameObject *)collider{
    if([collider isKindOfClass:[Player class]]){
        [(Player *)collider damage:kOneHit*2];
        [self removeSelfFromCollisionList];
        [self removeSelf];
    }
}

@end
