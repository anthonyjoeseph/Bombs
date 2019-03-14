//
//  PowerUp.h
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameObject.h"
#import "Collidable.h"
#import "Player.h"
#import "ExtraPower.h"

@interface PowerUp : GameObject <Collidable> {
    float timeSinceStart;
    bool hasFadeBegun;
    bool isEngaged;
    NSString *whichPowerUp;
}
-(void)collisionWithSprite:(GameObject *)otherObject;
-(void)fade;

@end
