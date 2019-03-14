//
//  StopForPlayerBehavior.m
//  Detonate
//
//  Created by Anthony Gabriele on 11/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StopForPlayerBehavior.h"

@implementation StopForPlayerBehavior

-(void)update:(ccTime)dt listOfBlocks:(NSArray *)blockList{
    [super update:dt listOfBlocks:blockList];
    MovingObject *movingBadGuy = (MovingObject *)self.badGuy;
    if([movingBadGuy isMoving]){
        if([self canSeePlayer]){
            [movingBadGuy stopMovingNow];
        }
    }else{
        if(![self canSeePlayer]){
            [movingBadGuy startMovingPossiblyMidTile];
        }
    }
}

-(bool)canSeePlayer{
    CGPoint badGuyPosition = self.badGuy.position;
    GameDirection badGuyDirection = self.badGuy.direction;
    CGPoint playerPosition = playerOne.position;
    bool canSee = NO;
    if((badGuyPosition.x == playerPosition.x || badGuyPosition.y == playerPosition.y)){
        if(badGuyPosition.y < playerPosition.y && badGuyDirection == kUp){
            canSee = YES;
        }else if(badGuyPosition.y > playerPosition.y && badGuyDirection == kDown){
            canSee = YES;
        }else if(badGuyPosition.x < playerPosition.x && badGuyDirection == kRight){
            canSee = YES;
        }else if(badGuyPosition.x > playerPosition.x && badGuyDirection == kLeft){
            canSee = YES;
        }
    }
    playerPosition = playerTwo.position;
    if((badGuyPosition.x == playerPosition.x || badGuyPosition.y == playerPosition.y)){
        if(badGuyPosition.y < playerPosition.y && badGuyDirection == kUp){
            canSee = YES;
        }else if(badGuyPosition.y > playerPosition.y && badGuyDirection == kDown){
            canSee = YES;
        }else if(badGuyPosition.x < playerPosition.x && badGuyDirection == kRight){
            canSee = YES;
        }else if(badGuyPosition.x > playerPosition.x && badGuyDirection == kLeft){
            canSee = YES;
        }
    }
    return canSee;
}

@end
