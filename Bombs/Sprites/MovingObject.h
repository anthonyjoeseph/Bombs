//
//  MovingObject.h
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameObject.h"

@interface MovingObject : GameObject {
    float _tileMovementTime;
    bool isMoving;
    bool signaledToStop;
    CGPoint wantedTilePoint;
    CGPoint previousTilePoint;
    bool suggestable;
    GameDirection suggestedDirection;
}
-(CGPoint)offsetPositionFromDirection:(GameDirection)direction;
-(void)hasReachedTileAndIsMovingTo:(CGPoint)newPosition listOfBlocks:(NSArray *)listOfBlocks;
-(void)startMoving;
-(void)startMovingPossiblyMidTile;
-(void)stopMoving;
-(void)stopMovingNow;
-(bool)isMoving;
-(void)updateWantedPosition;
+(CGPoint)tilePosition:(CGPoint)rawPosition;
+(CGPoint)rawPosition:(CGPoint)tilePosition;
//used by the MovingTile
-(void)setSuggestable:(bool)isSuggestable;
-(void)suggestDirection:(GameDirection)theSuggestedDirection;

@property (nonatomic, assign) float tileMovementTime;
@end
