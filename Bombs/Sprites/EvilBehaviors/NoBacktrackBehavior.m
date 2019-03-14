//
//  NoBacktrackBehavior.m
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NoBacktrackBehavior.h"


@implementation NoBacktrackBehavior
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
    if(possibleDirections == 0){
        [self.movingBadGuy stopMoving];
    }
    //if there's only one way to go, it doesn't mater if it's backtracking
    if(possibleDirections == 1){
        if(canGoRight){
            return kRight;
        }
        if(canGoDown){
            return kDown;
        }
        if(canGoLeft){
            return kLeft;
        }
        if(canGoUp){
            return kUp;
        }
    }
    GameDirection returnDirection;
    bool isUnSafe = YES;
    while(isUnSafe){
        returnDirection = rand() % 4;
        switch (returnDirection) {
            case kRight:
                if(canGoRight && self.movingBadGuy.direction != kLeft){
                    isUnSafe = NO;
                }
                break;
            case kDown:
                if(canGoDown && self.movingBadGuy.direction != kUp){
                    isUnSafe = NO;
                }
                break;
            case kLeft:
                if(canGoLeft && self.movingBadGuy.direction != kRight){
                    isUnSafe = NO;
                }
                break;
            case kUp:
                if(canGoUp && self.movingBadGuy.direction != kDown){
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
