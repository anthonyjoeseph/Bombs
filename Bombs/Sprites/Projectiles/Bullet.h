//
//  Bullet.h
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MovingObject.h"
#import "Collidable.h"


@interface Bullet : MovingObject <Collidable> {
    bool firstTime;
}
-(void)collisionWithSprite:(GameObject *)otherObject;

@end
