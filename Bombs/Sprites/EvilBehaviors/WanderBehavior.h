//
//  WanderBehavior.h
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EvilBehavior.h"
#import "MovingObject.h"


@interface WanderBehavior : EvilBehavior {
    MovingObject *_movingBadGuy;
    bool firstTime;
    //collision handling
    bool colliding;
    CGPoint previousPosition;
    float timeSincePreviousTile;
    bool goesThroughBreakableBlocks;
}
-(id)initGoesThroughBreakableBlocksWithBadGuy:(GameObject *)badGuy;
-(GameDirection)randomDirection;
-(GameDirection)safeRandomDirectionGivenListOfBlocks:(NSArray *)blockList;

@property (nonatomic, assign) MovingObject *movingBadGuy;
@end
