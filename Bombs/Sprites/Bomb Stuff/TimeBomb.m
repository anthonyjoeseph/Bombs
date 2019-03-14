//
//  TimeBomb.m
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TimeBomb.h"
#import "SimpleAudioEngine.h"


@implementation TimeBomb
-(id)initWithBatchNode:(CCSpriteBatchNode *)batchNode{
    if((self = [super initWithBatchNode:batchNode])){
        timeSinceStart = -1;
        hasForeShadowed = NO;
        self.currentAnimation = [self loadAnimation:@"BombFuse" frameCount:4 frameDuration:kDefaultBombLength / 4];
        [self setCurrentIdleFrameName: @"BombFuse1.png"];
        [self idle];
    }
    return self;
}
//this method is called when the bomb is put down
-(void)registerBombObserver:(id<BombObserver>)theObserver{
    [super registerBombObserver: theObserver];
    self.currentAnimation = [self loadAnimation:@"BombFuse" frameCount:4 frameDuration:[bombObserver bombDuration] / 4];
    [self animate];
    [[SimpleAudioEngine sharedEngine] playEffect:@"Bomb.m4v"];
    timeSinceStart = 0;
}
-(void)foreshadow{
    self.currentAnimation = [self loadAnimation:@"BombExploding" frameCount:2 frameDuration:0.05];
    [self animate];
}
-(void)update:(ccTime)dt listOfBlocks:(NSArray *)blockList{
    [super update:dt listOfBlocks:blockList];
    if(timeSinceStart >= 0){
        timeSinceStart += dt;
        if(timeSinceStart > ([bombObserver bombDuration] * 0.75) && !hasForeShadowed){
            [self foreshadow];
            hasForeShadowed = YES;
        }
        if(timeSinceStart > [bombObserver bombDuration] || isDeadOnNextUpdateCycle){
            if(!isDeadOnNextUpdateCycle){//only have the trigger bomb play the effect
                [[SimpleAudioEngine sharedEngine] playEffect:@"Explosion.m4v"];
            }
            [self dieWithListOfBlocks:blockList];
            //this is here because bomb sprites are re-used
            timeSinceStart = -1;
            hasForeShadowed = NO;
            isDeadOnNextUpdateCycle = NO;
            [self idle];
        }
    }
}

@end
