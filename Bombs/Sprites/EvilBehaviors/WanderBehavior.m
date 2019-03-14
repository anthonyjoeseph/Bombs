//
//  WanderBehavior.m
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WanderBehavior.h"
#import "BadGuy.h"
#import "Block.h"
#import "Breakable.h"

@implementation WanderBehavior
@synthesize movingBadGuy = _movingBadGuy;

-(id)initWithBadGuy:(GameObject *)badGuy{
    if((self = [super initWithBadGuy:badGuy])){
        firstTime = YES;
        goesThroughBreakableBlocks = NO;
    }
    return self;
}
-(id)initGoesThroughBreakableBlocksWithBadGuy:(GameObject *)badGuy{
    if((self = [super initWithBadGuy:badGuy])){
        firstTime = YES;
        goesThroughBreakableBlocks = YES;
    }
    return self;
}
-(void)update:(ccTime)dt listOfBlocks:(NSArray *)blockList{
    if(firstTime){
        self.movingBadGuy = (MovingObject *)self.badGuy;
        firstTime = NO;
        self.badGuy.direction = [self safeRandomDirectionGivenListOfBlocks:blockList];
        [self.movingBadGuy startMoving];
    }
}
-(void)collisionWithSprite:(GameObject *)collider{
    /*if([collider isKindOfClass:[BadGuy class]]){
        switch (self.badGuy.direction) {
            case kLeft:
                self.badGuy.direction = kRight;
                break;
            case kRight:
                self.badGuy.direction = kLeft;
                break;
            case kUp:
                self.badGuy.direction = kDown;
                break;
            case kDown:
                self.badGuy.direction = kUp;
                break;
        }
    }
    if([collider isKindOfClass:[Block class]]){
        //it's being forced into a wall by another bad guy
        [self.badGuy stopMovingNow];
        //wait untill it's gone, then move
    }*/
}
-(void)die{
    [self.movingBadGuy stopMovingNow];
}
-(void)hasReachedTileAndIsMovingTo:(CGPoint)wantedTilePoint listOfBlocks:(NSArray *)listOfBlocks{
    GameDirection newDirection = [self safeRandomDirectionGivenListOfBlocks:listOfBlocks];
    self.badGuy.direction = newDirection;
}
-(GameDirection)randomDirection{
	int random = rand() % 4;
    //enumerated types are really just integer values under the hood, so no conversion is necessary
	return random;
}
-(GameDirection)safeRandomDirectionGivenListOfBlocks:(NSArray *)blockList{
    CGPoint rightPosition = [self.movingBadGuy offsetPositionFromDirection: kRight];
    CGPoint downPosition = [self.movingBadGuy offsetPositionFromDirection: kDown];
    CGPoint leftPosition = [self.movingBadGuy offsetPositionFromDirection: kLeft];
    CGPoint upPosition = [self.movingBadGuy offsetPositionFromDirection: kUp];
    bool canGoRight = YES;
    bool canGoDown = YES;
    bool canGoLeft = YES;
    bool canGoUp = YES;
    int possibleDirections = 4;
    for(GameObject *block in blockList){
        if(!goesThroughBreakableBlocks || ![block conformsToProtocol:@protocol(Breakable)]){
            if(canGoRight && CGPointEqualToPoint(block.position, rightPosition)){
                canGoRight = NO;
                possibleDirections--;
            }
            if(canGoDown && CGPointEqualToPoint(block.position, downPosition)){
                canGoDown = NO;
                possibleDirections--;
            }
            if(canGoLeft && CGPointEqualToPoint(block.position, leftPosition)){
                canGoLeft = NO;
                possibleDirections--;
            }
            if(canGoUp && CGPointEqualToPoint(block.position, upPosition)){
                canGoUp = NO;
                possibleDirections--;
            }
        }
    }
    if(possibleDirections == 0){
        [self.movingBadGuy stopMoving];
    }
    GameDirection returnDirection;
    bool isUnSafe = YES;
    while(isUnSafe){
        returnDirection = rand() % 4;
        switch (returnDirection) {
            case kRight:
                if(canGoRight){
                    isUnSafe = NO;
                }
                break;
            case kDown:
                if(canGoDown){
                    isUnSafe = NO;
                }
                break;
            case kLeft:
                if(canGoLeft){
                    isUnSafe = NO;
                }
                break;
            case kUp:
                if(canGoUp){
                    isUnSafe = NO;
                }
                break;
        }
    }
    return returnDirection;
}

-(void)dealloc{
    [super dealloc];
}

@end
