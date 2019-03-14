//
//  FollowBehavior.m
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FollowBehavior.h"


@implementation FollowBehavior
-(id)initWithBadGuy:(GameObject *)badGuy follow:(GameObject *)_followMe{
    if((self = [super initWithBadGuy:badGuy])){
        followMe = _followMe;
        previousFollowNodePoint = ccp(-100, -100);//signifies the uninitialized point
    }
    return self;
}
-(void)hasReachedTileAndIsMovingTo:(CGPoint)wantedTilePoint listOfBlocks:(NSArray *)blockList{
    float xOffset = followMe.position.x - self.badGuy.position.x;
    float yOffset = followMe.position.y - self.badGuy.position.y;
    if(xOffset > 0 && abs(xOffset) > abs(yOffset)){
        self.badGuy.direction = kRight;
        return;
    }else if(xOffset < 0 && abs(xOffset) > abs(yOffset)){
        self.badGuy.direction = kLeft;
        return;
    }else if(yOffset > 0 && abs(yOffset) > abs(xOffset)){
        self.badGuy.direction = kUp;
        return;
    }else if(yOffset < 0 && abs(yOffset) > abs(xOffset)){
        self.badGuy.direction = kDown;
        return;
    }
}
@end
