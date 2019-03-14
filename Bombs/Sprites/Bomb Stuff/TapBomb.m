//
//  TapBomb.m
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TapBomb.h"
#import "SimpleAudioEngine.h"


@implementation TapBomb
-(id)initWithBatchNode:(CCSpriteBatchNode *)batchNode{
    if((self = [super initWithBatchNode:batchNode])){
        //self.currentAnimation = [self loadAnimation:@"BombFuse" frameCount:4 frameDuration:kDefaultBombLength / 4];
        //[self setCurrentIdleFrameName: @"BombFuse1.png"];
        //[self idle];
    }
    return self;
}
-(void)registerBombObserver:(id<BombObserver>)theObserver{
    [super registerBombObserver: theObserver];
    //self.currentAnimation = [self loadAnimation:@"BombFuse" frameCount:4 frameDuration:[bombObserver bombDuration] / 4];
    //[self animate];
    [[SimpleAudioEngine sharedEngine] playEffect:@"Bomb.m4v"];
}
-(void)update:(ccTime)dt listOfBlocks:(NSArray *)blockList{
    if(isDeadOnNextUpdateCycle){
        [[SimpleAudioEngine sharedEngine] playEffect:@"Explosion.m4v"];
        [self dieWithListOfBlocks:blockList];
        //this is here because bombs are re-used
        isDeadOnNextUpdateCycle = NO;
    }
}
-(void)touch:(CGPoint)location{
    CGRect boundingBox = self.boundingBox;
    CGRect touchRange = CGRectMake(boundingBox.origin.x, boundingBox.origin.y, boundingBox.size.width*1.5, boundingBox.size.height*1.5);
    if(CGRectContainsPoint(touchRange, location)){
        isDeadOnNextUpdateCycle = YES;
    }
}
@end
