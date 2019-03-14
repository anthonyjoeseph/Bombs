//
//  FinalBoss.m
//  Detonate
//
//  Created by Anthony Gabriele on 1/10/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "FinalBoss.h"
#import "CreationPool.h"
#import "FloatingFireBall.h"
#import "SimpleAudioEngine.h"

@implementation FinalBoss

-(id)initWithBatchNode:(CCSpriteBatchNode *)batchNode{
    if((self = [super initWithBatchNode:batchNode])){
        projectilePool = [[[CreationPool alloc] initWithGameObjectType:@"FloatingFireBall" poolRegistrar:self.poolRegistrar] autorelease];
        radius = 100.0f;
        degreesPerSecond = M_PI/5;
        currentDegree = 0.0f;
        reloadTime = kDefaultProjectileReloadTime;
        timeSinceShot = reloadTime;
        isHurt = NO;
        timeHurt = 2.0f;
        damage = 5;
        isDying = NO;
        timeDying = 10.0;
        
        firstTime = YES;
    }
    return self;
}
-(void)update:(ccTime)dt listOfBlocks:(NSArray *)blockList{
    if(firstTime){
        firstTime = NO;
        self.currentAnimation = [self loadAnimation:@"FinalBossWalking" frameCount:5 frameDuration:.4];
        [self animate];
    }
    if(isHurt){
        timeHurt -= dt;
        if(timeHurt < 0){
            self.currentAnimation = [self loadAnimation:@"FinalBossWalking" frameCount:5 frameDuration:.4];
            [self animate];
            isHurt = NO;
        }
    }else if(isDying){
        timeDying -= dt;
        if(timeDying < 0){
            [self removeSelfFromCollisionList];
            [self removeSelf];
            isDying = NO;
        }
    }else{
        //move in a circle
        double winWidth = kTileSize * kBoardWidthInTiles;
        double winHeight = kTileSize * kBoardHeightInTiles;
        float x = radius * cos(currentDegree);
        float y = radius * sin(currentDegree);
        self.position = ccp(winWidth/2 + x, winHeight/2 + y);
        currentDegree += dt * degreesPerSecond;
        
        //shoot toward both players
        timeSinceShot -= dt;
        if(timeSinceShot <= 0){
            CGPoint currentPosition = self.position;
            CGPoint playerPosition = playerOne.position;
            float pixelsPerSecond = kTileSize/kDefaultProjectileSpeed;
            float radiansFromTarget = atan2(playerPosition.y - currentPosition.y, playerPosition.x - currentPosition.y);
            float xSpeed = pixelsPerSecond * cos(radiansFromTarget);
            float ySpeed = pixelsPerSecond * sin(radiansFromTarget);
            FloatingFireBall *projectile = (FloatingFireBall *)[projectilePool placeObject:currentPosition];
            projectile.xSpeed = xSpeed;
            projectile.ySpeed = ySpeed;
            if(playerTwo){
                playerPosition = playerTwo.position;
                pixelsPerSecond = kTileSize/kDefaultProjectileSpeed;
                radiansFromTarget = atan2(playerPosition.y - currentPosition.y, playerPosition.x - currentPosition.y);
                xSpeed = pixelsPerSecond * cos(radiansFromTarget);
                ySpeed = pixelsPerSecond * sin(radiansFromTarget);
                projectile = (FloatingFireBall *)[projectilePool placeObject:currentPosition];
                projectile.xSpeed = xSpeed;
                projectile.ySpeed = ySpeed;
            }
            timeSinceShot = reloadTime;
        }
    }
}
-(void)collisionWithSprite:(GameObject *)otherObject{
    if([otherObject isKindOfClass:[Player class]]){
        Player *collisionPlayer = (Player *)otherObject;
        [collisionPlayer damage:kOneHit*2];
    }
}
-(void)die{
    if(!isHurt && !isDying){
        damage--;
        if(damage == 0){
            [[SimpleAudioEngine sharedEngine] playEffect:@"Maniacal.mp3"];
            self.currentAnimation = [self loadAnimation:@"FinalBossDying" frameCount:5 frameDuration:.3];
            [self animate];
            isDying = YES;
            timeDying = 7.0f;
        }else{
            radius += 50;
            reloadTime *= .75;
            self.currentAnimation = [self loadAnimation:@"FinalBossHurt" frameCount:2 frameDuration:.4];
            [self animate];
            isHurt = YES;
            timeHurt = 2.0f;
        }
    }
}
-(void)registerPlayerOne:(Player *)_playerOne playerTwo:(Player *)_playerTwo{
    playerOne = _playerOne;
    playerTwo = _playerTwo;
}


@end
