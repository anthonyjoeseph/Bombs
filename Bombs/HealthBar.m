//
//  HealthBar.m
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HealthBar.h"


@implementation HealthBar
-(id)initWithGameEnder:(id<GameEnder>)_gameEnder lives:(int)_lives health:(double)_health{
    if((self = [super init])){
        health = _health;
        lives = _lives;
        gameEnder = _gameEnder;
        CCSprite *background = [CCSprite spriteWithFile:@"HealthBackground.png"];
        redBar = [CCProgressTimer progressWithFile:@"HealthBar.png"];
        redBar.type = kCCProgressTimerTypeVerticalBarTB;
        redBar.percentage = health;
        life1 = [CCSprite spriteWithFile:@"PlayerLife.png"];
        life2 = [CCSprite spriteWithFile:@"PlayerLife.png"];
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            background.position = ccp(0,0);
            redBar.position = ccp(0,0);
            double redBarBottom = redBar.contentSize.height/-2;
            life1.position = ccp(0, redBarBottom - life1.contentSize.height);
            life2.position = ccp(0, redBarBottom - life2.contentSize.height - 50);
            
        }else{
            background.position = ccp(-50,0);
            redBar.position = ccp(-50,0);
            life1.position = ccp(20, 50);
            life2.position = ccp(20, 0);
        }
        
        [self addChild:background z:1];
        [self addChild:redBar z:2];
        [self addChild:life1 z:3];
        [self addChild:life2 z:3];
        life1.visible = NO;
        life2.visible = NO;
        if(lives > 1){
            life1.visible = YES;
            if(lives > 2){
                life2.visible = YES;
            }
        }
    }
    return self;
}
-(id)initForShowWithLives:(int)_lives health:(double)_health{
    if((self = [super init])){
        health = _health;
        lives = _lives;
        CCSprite *background = [CCSprite spriteWithFile:@"HealthBackground.png"];
        redBar = [CCProgressTimer progressWithFile:@"HealthBar.png"];
        redBar.type = kCCProgressTimerTypeVerticalBarTB;
        redBar.percentage = health;
        life1 = [CCSprite spriteWithFile:@"PlayerLife.png"];
        life2 = [CCSprite spriteWithFile:@"PlayerLife.png"];
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            background.position = ccp(0,0);
            redBar.position = ccp(0,0);
            double redBarBottom = redBar.contentSize.height/-2;
            life1.position = ccp(0, redBarBottom - life1.contentSize.height);
            life2.position = ccp(0, redBarBottom - life2.contentSize.height - 50);
            
        }else{
            background.position = ccp(-50,0);
            redBar.position = ccp(-50,0);
            life1.position = ccp(20, 50);
            life2.position = ccp(20, 0);
        }
        
        [self addChild:background z:1];
        [self addChild:redBar z:2];
        if(lives > 1){
            [self addChild:life1 z:3];
            if(lives > 2){
                [self addChild:life2 z:3];
            }
        }
    }
    return self;
}
-(void)setLives:(int)_lives health:(double)_health{
    lives = _lives;
    life1.visible = NO;
    life2.visible = NO;
    if(lives > 1){
        life1.visible = YES;
        if(lives > 2){
            life2.visible = YES;
        }
    }
    health = _health;
    redBar.percentage = health;
}
-(double)health{
    return health;
}
-(int)lives{
    return lives;
}
-(void)damage:(double)damage{
    health = health - damage;
    if(health < 0){
        health = 0.0;
    }
    redBar.percentage = health;
}
-(bool)isDead{
    return health == 0.0;
}
-(bool)isGameOver{
    return health == 0.0 && lives == 0;
}
-(void)heal:(double)hearts{
    health += hearts;
    if(health > 100){
        health = 100;
    }
    redBar.percentage = health;
}
-(void)loseLife{
    lives--;
    if(lives == 2){
        life2.visible = NO;
    }else if(lives == 1){
        life1.visible = NO;
    }else{
        [gameEnder gameOver];
    }
}
-(void)reset{
    health = 100;
    redBar.percentage = health;
}
@end
