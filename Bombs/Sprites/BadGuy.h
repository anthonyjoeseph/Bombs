//
//  BadGuy.h
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MovingObject.h"
#import "ShootingBehavior.h"
#import "MustKill.h"
#import "Collidable.h"
#import "KnowsPlayer.h"
#import "Player.h"


@interface BadGuy : MovingObject <MustKill, Collidable, KnowsPlayer> {
    EvilBehavior *_moveBehavior;
    EvilBehavior *_shootBehavior;
    
}
-(void)die;
-(void)collisionWithSprite:(GameObject *)otherObject;
-(void)registerPlayerOne:(Player *)playerOne playerTwo:(Player *)playerTwo;

@property (nonatomic, retain) EvilBehavior *moveBehavior;
@property (nonatomic, retain) EvilBehavior *shootBehavior;

@end
