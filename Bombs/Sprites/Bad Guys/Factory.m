//
//  Factory.m
//  Detonate
//
//  Created by Anthony Gabriele on 1/10/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "Factory.h"
#import "Constants.h"
#import "SimpleAudioEngine.h"
#import "FireBall.h"

@implementation Factory
-(id)initWithBatchNode:(CCSpriteBatchNode *)batchNode{
    if((self = [super initWithBatchNode:batchNode])){
        self.tileMovementTime = kDefaultBadGuyMovementSpeed;
        self.currentAnimation = [self loadAnimation:@"FactoryWorking" frameCount:3 frameDuration:.7];
        [self animate];
        self.moveBehavior = nil;
        self.shootBehavior = nil;
        damage = 1;
        timeSinceLastRobot = 12;
        storBotPool = [[CreationPool alloc] initWithGameObjectType:@"StorBot" poolRegistrar:self.poolRegistrar];
        sharkPool = [[CreationPool alloc] initWithGameObjectType:@"Shark" poolRegistrar:self.poolRegistrar];
        fireBallPool = [[CreationPool alloc] initWithGameObjectType:@"FireBall" poolRegistrar:self.poolRegistrar];
        isHurt = NO;
        timeSinceHurt = 0.0;
        isDying = NO;
        timeSinceShark = 0.0;
    }
    return self;
}
-(void)update:(ccTime)dt listOfBlocks:(NSArray *)blockList{
    /*if(firstTime){
     //add all of the points where a robot can be created, which is all of the surrounding tiles, minus the corners
     CGPoint middlePoint = self.position;
     CGPoint upperLeft = ccp(middlePoint.x - kTileSize, middlePoint.y + (2*kTileSize));
     CGPoint upperMiddle = ccp(middlePoint.x, middlePoint.y + (2*kTileSize));
     CGPoint upperRight = ccp(middlePoint.x + kTileSize, middlePoint.y + (2*kTileSize));
     CGPoint rightTop = ccp(middlePoint.x + (2*kTileSize), middlePoint.y + kTileSize);
     CGPoint rightMiddle = ccp(middlePoint.x + (2*kTileSize), middlePoint.y);
     CGPoint rightBottom = ccp(middlePoint.x + (2*kTileSize), middlePoint.y + kTileSize);
     CGPoint lowerLeft = ccp(middlePoint.x - kTileSize, middlePoint.y - (2*kTileSize));
     CGPoint lowerMiddle = ccp(middlePoint.x, middlePoint.y - (2*kTileSize));
     CGPoint lowerRight = ccp(middlePoint.x + kTileSize, middlePoint.y - (2*kTileSize));
     CGPoint leftTop = ccp(middlePoint.x - (2*kTileSize), middlePoint.y + kTileSize);
     CGPoint leftMiddle = ccp(middlePoint.x - (2*kTileSize), middlePoint.y);
     CGPoint leftBottom = ccp(middlePoint.x - (2*kTileSize), middlePoint.y - kTileSize);
     
     firstTime = NO;
     }*/
    if(isDying){
        timeSinceShark += dt;
        if(timeSinceShark >= 1){
            MovingObject *shark;
            shark = (MovingObject *)[sharkPool placeObject:ccp(self.position.x + (2*kTileSize), self.position.y - kTileSize)];
            shark.direction = kRight;
            [[SimpleAudioEngine sharedEngine] playEffect:@"NewRobot.m4v"];
            timeSinceShark = 0;
        }
    }else if(isHurt){
        timeSinceHurt += dt;
        if(timeSinceHurt > 2){
            self.currentAnimation = [self loadAnimation:@"FactoryWorking" frameCount:3 frameDuration:.7];
            [self animate];
            isHurt = NO;
            timeSinceHurt = 0;
        }
    }else{
        timeSinceLastRobot += dt;
        if(timeSinceLastRobot >= (20.5 - (damage * 4))){
            MovingObject *robot;
            //place the object in the lower right corner and have it move right
            robot = (MovingObject *)[storBotPool placeObject:ccp(self.position.x + (2*kTileSize), self.position.y - kTileSize)];
            robot.direction = kRight;
            [[SimpleAudioEngine sharedEngine] playEffect:@"NewRobot.m4v"];
            timeSinceLastRobot = 0;
        }
    }
    [super update:dt listOfBlocks:blockList];
}
-(void)collisionWithSprite:(GameObject *)otherObject{
    if([otherObject isKindOfClass:[Player class]]){
        [(Player *)otherObject damage:kOneHit];
    }
    [super collisionWithSprite:otherObject];
}
-(void)die{
    if(!isHurt && !isDying){
        damage++;
        isHurt = YES;
        if(damage == 5){
            [[SimpleAudioEngine sharedEngine] playEffect:@"FactoryExplosion.mp3"];
            [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1], [CCCallFunc actionWithTarget:self selector:@selector(reallyDie)], nil]];
            self.currentAnimation = [self loadAnimation:@"FactoryStartDying" frameCount:2 frameDuration:.5];
            [self animate];
        }else{
            timeSinceHurt = 0;
            self.currentAnimation = [self loadAnimation:@"FactoryHurt" frameCount:2 frameDuration:.5];
            GameObject *projectile = (FireBall *)[fireBallPool placeObject:self.position];
            projectile.direction = kLeft;
            [self animate];
        }
    }
}
-(void)reallyDie{
    [[SimpleAudioEngine sharedEngine] playEffect:@"FireCrackle.mp3"];
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:10], [CCCallFunc actionWithTarget:self selector:@selector(removeSelfFromCollisionList)], nil]];
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:10], [CCCallFunc actionWithTarget:self selector:@selector(removeSelf)], nil]];
    isHurt = NO;
    isDying = YES;
    timeSinceShark = 0.0;
    self.currentAnimation = [self loadAnimation:@"FactoryDying" frameCount:2 frameDuration:.5];
    [self animate];
}
-(void)dealloc{
    [storBotPool release];
    [sharkPool release];
    [fireBallPool release];
    [super dealloc];
}

@end
