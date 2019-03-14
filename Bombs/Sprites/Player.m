//
//  Player.m
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Player.h"
#import "SimpleAudioEngine.h"

@implementation Player
/*@synthesize moveBehavior = _moveBehavior;
 @synthesize damageBehavior = _damageBehavior;
 @synthesize bombBehavior = _bombBehavior;*/
@synthesize isPlayerOne = _isPlayerOne;
@synthesize healthBar = _healthBar;
@synthesize bombPool = _bombPool;
@synthesize cameraDelegate = cameraDelegate;

@synthesize inversePlayer = _inversePlayer;

-(id)initWithBatchNode:(CCSpriteBatchNode *)batchNode{
    if((self = [super initWithBatchNode:batchNode])){
        firstTime = YES;
        walkingAnimation = [[self loadAnimation:@"PlayerWalking" frameCount:4 frameDuration:.1] retain];
        invincibleAnimation = [[self loadAnimation:@"InvinciblePlayerWalking" frameCount:4 frameDuration:.1] retain];
        hurtAnimation = [[self loadAnimation:@"PlayerHurt" frameCount:2 frameDuration:.5] retain];
        deathAnimation = [[self loadAnimation:@"PlayerDying" frameCount:7 frameDuration:.2] retain];
        self.currentAnimation = walkingAnimation;
        self.currentIdleFrameName = @"PlayerWalking1.png";
        [self idle];
        
        self.bombPool = [[[BombPool alloc] initWithGameObjectType:@"TimeBomb" poolRegistrar:self.poolRegistrar capacity:15] autorelease];
        self.tileMovementTime = kDefaultPlayerMovementSpeed;
        isDead = NO;
        timeDead = 0;
        hasShield = NO;
        isHurt = NO;
        timeHurt = 0;
        isHurtCantMove = NO;
        timeHurtCantMove = 0;
        
        self.inversePlayer = nil;
    }
    return self;
}
-(void)startMoving{
    if(!isDead && !isHurtCantMove){
        if(![self isMoving]){
            [self animate];
        }
        [self.inversePlayer startMoving];
        [super startMoving];
    }
}
-(void)stopMoving{
    [self.inversePlayer stopMoving];
    [super stopMoving];
}
-(void)stopMovingNow{
    if(!isHurt){
        [self idle];
    }
    [super stopMovingNow];
}
-(void)setDirection:(GameDirection)direction{
    [super setDirection:direction];
    [self.inversePlayer setDirection:direction];
}
-(void)setPosition:(CGPoint)position{
    [super setPosition:position];
    [cameraDelegate shiftWorldtoFocalPoint:position];
}
-(void)hasReachedTileAndIsMovingTo:(CGPoint)newTilePoint listOfBlocks:(NSArray *)listOfBlocks{
    [super hasReachedTileAndIsMovingTo:newTilePoint listOfBlocks:listOfBlocks];
    if(!isDead){
        if(!(CGPointEqualToPoint(newTilePoint, self.position))){
            for (GameObject *currentBlock in listOfBlocks) {
                if(CGPointEqualToPoint(currentBlock.position, newTilePoint)){
                    [self stopMovingNow];
                    [self idle];
                }
            }
        }else{
            [self idle];
        }
    }
}
-(void)spawnBomb{
    if(!isDead){
        [self.inversePlayer spawnBomb];
        [self.bombPool placeObject:[self tileCenterNearestSelf]];
    }
}
-(void)shield{
    hasShield = YES;
    self.currentAnimation = invincibleAnimation;
    self.currentIdleFrameName = @"InvinciblePlayerWalking1.png";
    [self updateView];
}
-(void)takeAwayShield{
    hasShield = NO;
    self.currentAnimation = walkingAnimation;
    self.currentIdleFrameName = @"PlayerWalking1.png";
    [self updateView];
}
-(void)damage:(double)percentage{
    if(!isDead && !isHurt){
        if(hasShield){
            [self.healthBar damage:percentage/2];
        }else{
            [self.healthBar damage:percentage];
        }
        if([self.healthBar isDead]){
            [self die];
        }else{
            [[SimpleAudioEngine sharedEngine] playEffect:@"Ouch.mp3"];
            isHurt = YES;
            timeHurt = kDefaultPlayerHurtTime;
            isHurtCantMove = YES;
            timeHurtCantMove = timeHurt/6;
            [self stopMovingNow];
            self.currentAnimation = hurtAnimation;
            [self animate];
        }
    }
}
-(void)heal:(double)percentage{
    [self.healthBar heal:percentage];
}
-(void)addPowerUpHUDHolder:(id<PowerUpHUDHolder>)_holder{
    holder = _holder;
}
-(void)registerNewPowerUp:(id)_powerUp{
    if(powerUp){
        [powerUp disengage];
        [powerUp release];
        powerUp = nil;
    }
    powerUp = [_powerUp retain];
    [powerUp engage];
    if(self.isPlayerOne){
        [holder placePowerUpOnHUD:[powerUp toString] playerNumber:1];
    }else{
        [holder placePowerUpOnHUD:[powerUp toString] playerNumber:2];
    }
}
-(bool)die{
    if(!isDead && !isHurt){
        [[SimpleAudioEngine sharedEngine] playEffect:@"PlayerDeath.m4v"];
        isDead = YES;
        timeDead = 1.4;
        [self stopMovingNow];
        self.currentAnimation = deathAnimation;
        [self animate];
        
        if(powerUp){
            [powerUp disengage];
            [powerUp release];
            powerUp = nil;
            [holder removePowerUpFromHUD];
        }
        
        [self.healthBar loseLife];
        if([self.healthBar isGameOver]){
            timeDead = 5.0;
        }
    }
    return NO;
}
-(void)update:(ccTime)dt listOfBlocks:(NSArray *)blockList{
    if(firstTime){
        firstTime = NO;
        if([self isUpsideDown]){
            [self.bombPool makeUpsideDown];
        }
    }
    if(isHurt && timeHurt > 0){
        timeHurt -= dt;
        if(timeHurt <= 0){
            isHurt = NO;
            timeHurt = 0;
            if(hasShield){
                self.currentAnimation = invincibleAnimation;
                self.currentIdleFrameName = @"InvinciblePlayerWalking1.png";
            }else{
                self.currentAnimation = walkingAnimation;
                self.currentIdleFrameName = @"PlayerWalking1.png";
            }
            if([self isMoving]){
                [self animate];
            }else{
                [self idle];
            }
        }
    }
    if(isHurtCantMove && timeHurtCantMove > 0){
        timeHurtCantMove -= dt;
        if(timeHurtCantMove <= 0){
            isHurtCantMove = NO;
        }
    }
    if(isDead && timeDead > 0){
        timeDead -= dt;
        if(timeDead <= 0){
            isDead = NO;
            timeDead = 0;
            self.position = [self tileCenterNearestSelf];
            self.currentAnimation = walkingAnimation;
            self.currentIdleFrameName = @"PlayerWalking1.png";
            [self idle];
            [self.healthBar reset];
        }
    }
    [super update:dt listOfBlocks:blockList];
}
-(int)drawOrder{
    return 15;
}

-(void)registerInversePlayer:(id<ControllablePlayer>)inversePlayer{
    self.inversePlayer = inversePlayer;
}

-(void)dealloc{
    if(powerUp){
        [powerUp release];
    }
    [walkingAnimation release];
    [invincibleAnimation release];
    [hurtAnimation release];
    [deathAnimation release];
    [super dealloc];
}
@end
