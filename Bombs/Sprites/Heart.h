//
//  Heart.h
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameObject.h"
#import "Collidable.h"


@interface Heart : GameObject <Collidable> {
    
}
-(void)collisionWithSprite:(GameObject *)otherObject;

@end
