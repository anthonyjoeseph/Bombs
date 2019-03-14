//
//  PathFollower.m
//  Detonate
//
//  Created by Anthony Gabriele on 1/12/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "PathFollower.h"
#import "SimpleAudioEngine.h"

@implementation PathFollower
-(id)initWithBatchNode:(CCSpriteBatchNode *)batchNode{
    if((self = [super initWithBatchNode:batchNode])){
        damage = 0;
        currentPath = firstPath;
        isLookingForStart = NO;
        self.tileMovementTime = kDefaultPlayerMovementSpeed * .75;
        self.currentAnimation = [self loadAnimation:@"PathFollowerWalking" frameCount:3 frameDuration:.3];
        GameObjectPool *projectilePool = [self.poolRegistrar poolWithKey:@"FireBall"];
        if(!projectilePool){
            projectilePool = [[[BufferPool alloc] initWithGameObjectType:@"FireBall" poolRegistrar:self.poolRegistrar capacity:35] autorelease];
        }
        self.shootBehavior = [[[ShootingBehavior alloc] initWithBadGuy:self projectilePool:projectilePool reloadTime:kDefaultProjectileReloadTime] autorelease];
        [self animate];
        firstTime = YES;
        
        firstPath = [[Path alloc] initWithStartPointInTiles:ccp(15, 7) startDirection:kUp];
        [firstPath addTurnPointInTiles:ccp(15, 3) direction:kLeft];
        [firstPath addTurnPointInTiles:ccp(13, 3) direction:kUp];
        [firstPath addTurnPointInTiles:ccp(13, 1) direction:kLeft];
        [firstPath addTurnPointInTiles:ccp(3, 1) direction:kDown];
        [firstPath addTurnPointInTiles:ccp(3, 3) direction:kLeft];
        [firstPath addTurnPointInTiles:ccp(1, 3) direction:kDown];
        [firstPath addTurnPointInTiles:ccp(1, 11) direction:kRight];
        [firstPath addTurnPointInTiles:ccp(3, 11) direction:kDown];
        [firstPath addTurnPointInTiles:ccp(3, 13) direction:kRight];
        [firstPath addTurnPointInTiles:ccp(13, 13) direction:kUp];
        [firstPath addTurnPointInTiles:ccp(13, 11) direction:kRight];
        [firstPath addTurnPointInTiles:ccp(15, 11) direction:kUp];
        secondPath = [[Path alloc] initWithStartPointInTiles:ccp(15, 1) startDirection:kLeft];
        [secondPath addTurnPointInTiles:ccp(13,1) direction:kDown];
        [secondPath addTurnPointInTiles:ccp(13,13) direction:kLeft];
        [secondPath addTurnPointInTiles:ccp(11,13) direction:kUp];
        [secondPath addTurnPointInTiles:ccp(11,1) direction:kLeft];
        [secondPath addTurnPointInTiles:ccp(9,1) direction:kDown];
        [secondPath addTurnPointInTiles:ccp(9,13) direction:kLeft];
        [secondPath addTurnPointInTiles:ccp(7,13) direction:kUp];
        [secondPath addTurnPointInTiles:ccp(7,1) direction:kLeft];
        [secondPath addTurnPointInTiles:ccp(5,1) direction:kDown];
        [secondPath addTurnPointInTiles:ccp(5,13) direction:kLeft];
        [secondPath addTurnPointInTiles:ccp(3,13) direction:kUp];
        [secondPath addTurnPointInTiles:ccp(3,1) direction:kLeft];
        [secondPath addTurnPointInTiles:ccp(1,1) direction:kDown];
        [secondPath addTurnPointInTiles:ccp(1,13) direction:kRight];
        [secondPath addTurnPointInTiles:ccp(3,13) direction:kUp];
        [secondPath addTurnPointInTiles:ccp(3,1) direction:kRight];
        [secondPath addTurnPointInTiles:ccp(5,1) direction:kDown];
        [secondPath addTurnPointInTiles:ccp(5,13) direction:kRight];
        [secondPath addTurnPointInTiles:ccp(7,13) direction:kUp];
        [secondPath addTurnPointInTiles:ccp(7,1) direction:kRight];
        [secondPath addTurnPointInTiles:ccp(9,1) direction:kDown];
        [secondPath addTurnPointInTiles:ccp(9,13) direction:kRight];
        [secondPath addTurnPointInTiles:ccp(11,13) direction:kUp];
        [secondPath addTurnPointInTiles:ccp(11,1) direction:kRight];
        [secondPath addTurnPointInTiles:ccp(13,1) direction:kDown];
        [secondPath addTurnPointInTiles:ccp(13,13) direction:kRight];
        [secondPath addTurnPointInTiles:ccp(15,13) direction:kUp];
        [secondPath addTurnPointInTiles:ccp(15,1) direction:kLeft];
        thirdPath = [[Path alloc] initWithStartPointInTiles:ccp(1, 13) startDirection:kRight];
        [thirdPath addTurnPointInTiles:ccp(7, 13) direction:kUp];
        [thirdPath addTurnPointInTiles:ccp(7, 1) direction:kLeft];
        [thirdPath addTurnPointInTiles:ccp(1, 1) direction:kDown];
        [thirdPath addTurnPointInTiles:ccp(1, 7) direction:kRight];
        [thirdPath addTurnPointInTiles:ccp(15, 7) direction:kUp];
        [thirdPath addTurnPointInTiles:ccp(15, 1) direction:kLeft];
        [thirdPath addTurnPointInTiles:ccp(9, 1) direction:kDown];
        [thirdPath addTurnPointInTiles:ccp(9, 13) direction:kRight];
        [thirdPath addTurnPointInTiles:ccp(15, 13) direction:kUp];
        [thirdPath addTurnPointInTiles:ccp(15, 7) direction:kLeft];
        [thirdPath addTurnPointInTiles:ccp(1, 7) direction:kDown];
        [thirdPath addTurnPointInTiles:ccp(1, 13) direction:kRight];
        
        currentPath = firstPath;
    }
    return self;
}
-(void)update:(ccTime)dt listOfBlocks:(NSArray *)blockList{
    if(firstTime == YES){
        firstTime = NO;
        [self startMoving];
    }
    [super update:dt listOfBlocks:blockList];
}
-(void)hasReachedTileAndIsMovingTo:(CGPoint)newPosition listOfBlocks:(NSArray *)listOfBlocks{
    if(isLookingForStart){
        if(CGPointEqualToPoint(self.position, [currentPath startPoint])){
            self.direction = [currentPath startDirection];
            isLookingForStart = NO;
            self.currentAnimation = [self loadAnimation:@"PathFollowerWalking" frameCount:3 frameDuration:.3];
            [self animate];
        }else{
            GameDirection possibleDirections[4];
            [self directionPreferenceOrderFromStart:[MovingObject rawPosition:self.position] goal:[MovingObject rawPosition:[currentPath startPoint]] array:possibleDirections];
            int i = 0;
            bool stillChecking = YES;
            GameDirection possibleDirection;
            while(i < 4 && stillChecking){
                possibleDirection = possibleDirections[i];
                i++;
                stillChecking = NO;
                for(GameObject *block in listOfBlocks){
                    if(CGPointEqualToPoint(block.position, [self offsetPositionFromDirection:possibleDirection])){
                        stillChecking = YES;
                    }
                }
            }
            self.direction = possibleDirection;
        }
    }else{
        if(CGPointEqualToPoint(self.position, [currentPath nextPoint])){
            self.direction = [currentPath nextDirection];
            [currentPath advanceIndex];
        }
    }
}
-(void)die{
    if(!isLookingForStart){
        [[SimpleAudioEngine sharedEngine] playEffect:@"PathFollower.mp3"];
        damage++;
        switch (damage) {
            case 1:
                isLookingForStart = YES;
                self.currentAnimation = [self loadAnimation:@"PathFollowerHurt" frameCount:2 frameDuration:.4];
                [self animate];
                currentPath = secondPath;
                break;
                
            case 2:
                isLookingForStart = YES;
                self.currentAnimation = [self loadAnimation:@"PathFollowerHurt" frameCount:2 frameDuration:.4];
                [self animate];
                currentPath = thirdPath;
                break;
            case 3:
                [self removeSelfFromCollisionList];
                [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:2], [CCCallFunc actionWithTarget:self selector:@selector(removeSelf)], nil]];
                self.currentAnimation = [self loadAnimation:@"PathFollowerDying" frameCount:4 frameDuration:.7];
                [self animate];
                break;
        }
    }
}
-(void)collisionWithSprite:(GameObject *)otherObject{
    if([otherObject isKindOfClass:[Player class]]){
        [(Player *)otherObject damage:kOneHit];
    }
    [super collisionWithSprite:otherObject];
}
-(void)directionPreferenceOrderFromStart:(CGPoint)startTilePoint goal:(CGPoint)goalTilePoint array:(GameDirection[4])returnArray{
    float xOffset = goalTilePoint.x - startTilePoint.x;
    float yOffset = goalTilePoint.y - startTilePoint.y;
    //if the distance is greater from the x position
    if(abs(xOffset) > abs(yOffset)){
        //and it's on the right
        if(xOffset > 0){
            //the first preference should be right and the last preference should be left
            returnArray[0] = kRight;
            returnArray[3] = kLeft;
            if(yOffset > 0){
                returnArray[1] = kDown;
                returnArray[2] = kUp;
            }else{
                returnArray[1] = kUp;
                returnArray[2] = kDown;
            }
        }else{
            returnArray[0] = kLeft;
            returnArray[3] = kRight;
            if(yOffset > 0){
                returnArray[1] = kDown;
                returnArray[2] = kUp;
            }else{
                returnArray[1] = kUp;
                returnArray[2] = kDown;
            }
        }
    }else{
        if(yOffset > 0){
            returnArray[0] = kDown;
            returnArray[3] = kUp;
            if(xOffset > 0){
                returnArray[1] = kRight;
                returnArray[2] = kLeft;
            }else{
                returnArray[1] = kLeft;
                returnArray[2] = kRight;
            }
        }else{
            returnArray[0] = kUp;
            returnArray[3] = kDown;
            if(xOffset > 0){
                returnArray[1] = kRight;
                returnArray[2] = kLeft;
            }else{
                returnArray[1] = kLeft;
                returnArray[2] = kRight;
            }
        }
    }
}
-(void)makeUpsideDown{
    //doesn't actually switch it upside down because it's direction matters
    isUpsideDown = YES;
}
-(void)dealloc{
    [firstPath release];
    [secondPath release];
    [thirdPath release];
    [super dealloc];
}

@end
