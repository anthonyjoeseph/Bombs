//
//  MovingObject.m
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovingObject.h"


@implementation MovingObject
@synthesize tileMovementTime = _tileMovementTime;

-(id)initWithBatchNode:(CCSpriteBatchNode *)batchNode{
    if((self = [super initWithBatchNode:batchNode])){
        self.tileMovementTime = kDefaultPlayerMovementSpeed;
        isMoving = NO;
        signaledToStop = NO;
        suggestable = YES;
        suggestedDirection = -1;
    }
    return self;
}
-(void)setDirection:(GameDirection)newDirection{
    GameDirection oldDirection = _direction;
    switch (newDirection) {
		case kRight:
            //if(suggestedDirection != kLeft){
                if(oldDirection == kLeft){
                    wantedTilePoint = previousTilePoint;
                }
                [super setDirection:newDirection];
            //}
			break;
		case kDown:
            //if(suggestedDirection != kUp){
                if(oldDirection == kUp){
                    wantedTilePoint = previousTilePoint;
                }
                [super setDirection:newDirection];
            //}
			break;
		case kLeft:
            //if(suggestedDirection != kRight){
                if(oldDirection == kRight){
                    wantedTilePoint = previousTilePoint;
                }
                [super setDirection:newDirection];
            //}
			break;
		case kUp:
            //if(suggestedDirection != kDown){
                if(oldDirection == kDown){
                    wantedTilePoint = previousTilePoint;
                }
                [super setDirection:newDirection];
            //}
			break;
	}
}
-(CGPoint)offsetPositionFromDirection:(GameDirection)direction{
    CGPoint offsetPosition = self.position;
    switch (direction) {
        case kUp:
            offsetPosition.y += kTileSize;
            break;
        case kDown:
            offsetPosition.y -= kTileSize;
            break;
        case kLeft:
            offsetPosition.x -= kTileSize;
            break;
        case kRight:
            offsetPosition.x += kTileSize;
            break;
    }
    return offsetPosition;
}
-(void)startMoving{
    if(!isMoving){
        isMoving = YES;
        signaledToStop = NO;
        //forces the update loop to check with hasReachedTilePoint before it actually starts moving
        wantedTilePoint = self.position;
    }
}
-(void)startMovingPossiblyMidTile{
    if(!isMoving){
        if(CGPointEqualToPoint(self.position, [self tileCenterNearestSelf])){//if it's starting right on a tile
            isMoving = YES;
            signaledToStop = NO;
            //forces the update loop to check with hasReachedTilePoint before it actually starts moving
            wantedTilePoint = self.position;
        }else{//if it's starting mid-tile
            isMoving = YES;
            signaledToStop = NO;
        }
    }
}
-(void)stopMoving{
    if(suggestedDirection == -1){
        signaledToStop = YES;
    }
}
-(void)stopMovingNow{
    if(isMoving){
        isMoving = NO;
        signaledToStop = YES;
    }
}
-(bool)isMoving{
    return isMoving;
}
+(CGPoint)tilePosition:(CGPoint)rawPosition{
    //CGPoint centerPosition = ccp(rawPosition.x - (self.contentSize.width / 2), rawPosition.y - (self.contentSize.height / 2));
    int x = floor(rawPosition.x / kTileSize);
	int yFromLowerLeft = floor(rawPosition.y / kTileSize);
	int topMostRow = kBoardHeightInTiles - 1;//- 1 to account for the fact that it starts with 0
	int yFromUpperLeft = topMostRow - yFromLowerLeft;
	return ccp(x, yFromUpperLeft);
}
+(CGPoint)rawPosition:(CGPoint)tilePosition{
    int x = tilePosition.x * kTileSize;
	int yFromUpperLeft = tilePosition.y * kTileSize;
	int numHeightPixels = ((kBoardHeightInTiles - 1) * kTileSize);//- 1 because it starts at 0
	int yFromLowerLeft = numHeightPixels - yFromUpperLeft;
	CGPoint rootPosition = ccp(x, yFromLowerLeft);
    
    CGPoint centerPosition = ccp(rootPosition.x + (kTileSize / 2), rootPosition.y + (kTileSize / 2));
    return centerPosition;
}
-(void)updateWantedPosition{
    if(isMoving){
        CGPoint currentTilePosition = [MovingObject tilePosition:self.position];
        int currentTileX = currentTilePosition.x;
        int currentTileY = currentTilePosition.y;
        switch(self.direction){
            case kRight:
                wantedTilePoint = [MovingObject rawPosition:ccp(currentTileX + 1, currentTileY)];
                break;
            case kDown:
                wantedTilePoint = [MovingObject rawPosition:ccp(currentTileX, currentTileY + 1)];
                break;
            case kLeft:
                wantedTilePoint = [MovingObject rawPosition:ccp(currentTileX - 1, currentTileY)];
                break;
            case kUp:
                wantedTilePoint = [MovingObject rawPosition:ccp(currentTileX, currentTileY - 1)];
                break;
        }
    }else{
        wantedTilePoint = self.position;
    }
}
-(void)update:(ccTime)dt listOfBlocks:(NSArray *)blockList{
    if(isMoving){
        if(CGPointEqualToPoint(wantedTilePoint, self.position)){
            previousTilePoint = self.position;
            [self updateWantedPosition];
            [self hasReachedTileAndIsMovingTo:wantedTilePoint listOfBlocks:blockList];
            [self updateWantedPosition];
            if(signaledToStop){
                [self stopMovingNow];
                signaledToStop = NO;
                return;
            }
        }
        float x = self.position.x;
        float y = self.position.y;
        if(wantedTilePoint.x > x){//right
            x += (dt/self.tileMovementTime) * kTileSize;
            //did we overshoot it?
            if(wantedTilePoint.x < x){
                x = wantedTilePoint.x;
            }
        }
        if(wantedTilePoint.y < y){//down
            y += -1 * ((dt/self.tileMovementTime) * kTileSize);
            if(y < wantedTilePoint.y){
                y = wantedTilePoint.y;
            }
        }
        if(wantedTilePoint.x < x){//left
            x += -1 * ((dt/self.tileMovementTime) * kTileSize);
            if(x < wantedTilePoint.x){
                x = wantedTilePoint.x;
            }
        }
        if(wantedTilePoint.y > y){//up
            y += (dt/self.tileMovementTime) * kTileSize;
            if(wantedTilePoint.y < y){
                y = wantedTilePoint.y;
            }
        }
        self.position = ccp(x, y);
    }else{
        previousTilePoint = self.position;
    }
}
-(void)hasReachedTileAndIsMovingTo:(CGPoint)newPosition listOfBlocks:(NSArray *)listOfBlocks{
    //override me
    suggestedDirection = -1;
}
-(void)setSuggestable:(bool)isSuggestable{
    suggestable = isSuggestable;
}
-(void)suggestDirection:(GameDirection)theSuggestedDirection{
    if(suggestable && suggestedDirection == -1){
        suggestedDirection = theSuggestedDirection;
        self.direction = theSuggestedDirection;
        [self startMoving];
    }
}
-(int)drawOrder{
    return 5;
}
-(void)dealloc{
    [super dealloc];
}
@end