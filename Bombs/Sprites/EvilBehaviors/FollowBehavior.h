//
//  FollowBehavior.h
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EvilBehavior.h"


@interface FollowBehavior : EvilBehavior {
    GameObject *followMe;
    CGPoint previousFollowNodePoint;
}
-(id)initWithBadGuy:(GameObject *)badGuy follow:(GameObject *)_followMe;
//-(GameDirection)followDirection;
//-(GameDirection)safeFollowDirectionGivenListOfBlocks:(NSArray *)blockList breakableBlocks:(NSArray *)breakableBlocks;

@end
