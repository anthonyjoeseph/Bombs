//
//  HealthBar.h
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameEnder.h"

@interface HealthBar : CCNode {
    double health;
    int lives;
    CCProgressTimer *redBar;
    CCSprite *life1;
    CCSprite *life2;
    id<GameEnder> gameEnder;
}
-(id)initWithGameEnder:(id<GameEnder>)_gameEnder lives:(int)_lives health:(double)_health;
-(id)initForShowWithLives:(int)lives health:(double)health;
-(void)setLives:(int)_lives health:(double)_health;
-(double)health;
-(int)lives;
-(void)damage:(double)damage;
-(void)heal:(double)health;
-(bool)isDead;
-(bool)isGameOver;
-(void)loseLife;
-(void)reset;
@end
