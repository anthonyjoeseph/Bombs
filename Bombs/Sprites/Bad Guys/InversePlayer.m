//
//  InversePlayer.m
//  Detonate
//
//  Created by Anthony Gabriele on 1/12/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "InversePlayer.h"
#import "SimpleAudioEngine.h"
@class InvertiblePlayer;

@implementation InversePlayer
@synthesize bombPool = _bombPool;

-(id)initWithBatchNode:(CCSpriteBatchNode *)batchNode{
    if((self = [super initWithBatchNode:batchNode])){
        self.currentAnimation = [self loadAnimation:@"InversePlayerWalking" frameCount:3 frameDuration:.1];
        self.currentIdleFrameName = @"InversePlayerWalking1.png";
        [self idle];
        self.bombPool = [[[BombPool alloc] initWithGameObjectType:@"TimeBomb" poolRegistrar:self.poolRegistrar capacity:15] autorelease];
        self.tileMovementTime = kDefaultPlayerMovementSpeed;
        isHurt = NO;
        timeHurt = 0;
        isHurtCantMove = NO;
        timeHurtCantMove = 0;
        damage = 0;
    }
    return self;
}
-(void)startMoving{
    if(!isHurtCantMove){
        if(![self isMoving]){
            [self animate];
        }
        [super startMoving];
    }
}
-(void)stopMoving{
    [self idle];
    [super stopMoving];
}
-(void)setDirection:(GameDirection)direction{
    switch (direction) {
        case kUp:
            [super setDirection:kDown];
            break;
        case kRight:
            [super setDirection:kLeft];
            break;
        case kDown:
            [super setDirection:kUp];
            break;
        case kLeft:
            [super setDirection:kRight];
            break;
    }
}
-(void)spawnBomb{
    [self.bombPool placeObject:[self tileCenterNearestSelf]];
}
-(void)hasReachedTileAndIsMovingTo:(CGPoint)newTilePoint listOfBlocks:(NSArray *)listOfBlocks{
    [super hasReachedTileAndIsMovingTo:newTilePoint listOfBlocks:listOfBlocks];
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
-(void)collisionWithSprite:(GameObject *)otherObject{
    if([otherObject isKindOfClass:[Player class]]){
        [(Player *)otherObject damage:kOneHit];
    }
    [super collisionWithSprite:otherObject];
}
-(void)update:(ccTime)dt listOfBlocks:(NSArray *)blockList{
    if(isHurt && timeHurt > 0){
        timeHurt -= dt;
        if(timeHurt <= 0){
            isHurt = NO;
            timeHurt = 0;
            self.currentAnimation = [self loadAnimation:@"InversePlayerWalking" frameCount:3 frameDuration:.1];
            self.currentIdleFrameName = @"InversePlayerWalking1.png";
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
    [super update:dt listOfBlocks:blockList];
}
-(void)die{
    if(!isHurt){
        damage++;
        if(damage == 3){
            [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:3], [CCCallFunc actionWithTarget:self selector:@selector(removeSelfFromCollisionList)], nil]];
            [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:3], [CCCallFunc actionWithTarget:self selector:@selector(removeSelf)], nil]];
            self.currentAnimation = [self loadAnimation:@"InversePlayerDying" frameCount:4 frameDuration:.75];
            [self animate];
            [[SimpleAudioEngine sharedEngine] playEffect:@"Pain2.m4v"];
        }else{
            [[SimpleAudioEngine sharedEngine] playEffect:@"PlayerHurt.m4v"];
            isHurt = YES;
            timeHurt = kDefaultPlayerHurtTime;
            isHurtCantMove = YES;
            timeHurtCantMove = timeHurt/2;
            [self stopMovingNow];
            self.currentAnimation = [self loadAnimation:@"InversePlayerHurt" frameCount:2 frameDuration:.5];
            [self animate];
        }
    }
}
-(void)registerPlayerOne:(Player *)_playerOne playerTwo:(Player *)_playerTwo{
    id playerOne = _playerOne;
    id playerTwo = _playerTwo;
    [playerOne registerInversePlayer:self];
    [playerTwo registerInversePlayer:self];
}
@end
