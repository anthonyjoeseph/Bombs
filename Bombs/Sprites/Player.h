//
//  Player.h
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MovingObject.h"
#import "HealthBar.h"
#import "Killable.h"
#import "BombObserver.h"
#import "BombPool.h"
#import "CameraDelegate.h"
#import "ControllablePlayer.h"
#import "PowerUpHUDHolder.h"

@interface Player : MovingObject <Killable, ControllablePlayer>{
    bool firstTime;
    bool _isPlayerOne;
    CCAnimation *walkingAnimation;
    CCAnimation *invincibleAnimation;
    CCAnimation *hurtAnimation;
    CCAnimation *deathAnimation;
    bool isDead;
    float timeDead;
    bool hasShield;
    bool isHurt;
    float timeHurt;
    bool isHurtCantMove;
    float timeHurtCantMove;
    BombPool *_bombPool;
    HealthBar *_healthBar;
    id powerUp;
    id<PowerUpHUDHolder>holder;
    
    id<ControllablePlayer> _inversePlayer;
    
    id<CameraDelegate> _cameraDelegate;
}
-(void)startMoving;
-(void)spawnBomb;
-(void)shield;
-(void)takeAwayShield;
-(void)damage:(double)percentage;
-(void)heal:(double)percentage;
-(void)addPowerUpHUDHolder:(id<PowerUpHUDHolder>)holder;
-(void)registerNewPowerUp:(id)powerUp;
-(bool)die;

-(void)registerInversePlayer:(id<ControllablePlayer>) _inversePlayer;

@property (nonatomic, assign) bool isPlayerOne;
@property (nonatomic, assign) id<CameraDelegate> cameraDelegate;
@property (nonatomic, assign) HealthBar *healthBar;
@property (nonatomic, assign) BombPool *bombPool;

@property (nonatomic, retain) id<ControllablePlayer> inversePlayer;

@end
