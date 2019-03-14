//
//  FireBall.h
//  Detonate
//
//  Created by Anthony Gabriele on 8/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovingObject.h"
#import "Collidable.h"

@interface FireBall : MovingObject <Collidable> {
    bool firstTime;
}
-(void)collisionWithSprite:(GameObject *)otherObject;

@end
