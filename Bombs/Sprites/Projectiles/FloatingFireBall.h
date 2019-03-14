//
//  FloatingFireBall.h
//  Detonate
//
//  Created by Anthony Gabriele on 1/10/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "BadGuy.h"

@interface FloatingFireBall : GameObject <Collidable> {
    bool firstTime;
    float _xSpeed;
    float _ySpeed;
}
-(void)collisionWithSprite:(GameObject *)otherObject;

@property (nonatomic, assign) float xSpeed;
@property (nonatomic, assign) float ySpeed;
@end
