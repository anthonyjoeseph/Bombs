//
//  Path.m
//  Detonate
//
//  Created by Anthony Gabriele on 1/12/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "Path.h"
#import "MovingObject.h"

@implementation Path
-(id)initWithStartPointInTiles:(CGPoint)_startPoint startDirection:(GameDirection)_startDirection{
    if((self = [super init])){
        startPoint = [MovingObject rawPosition: _startPoint];
        startDirection = _startDirection;
        addIndex = 0;
        getIndex = 0;
    }
    return self;
}
-(void)addTurnPointInTiles:(CGPoint)turnPoint direction:(GameDirection)newDirection{
    if(addIndex < maxNumTurns){
        pointsForTurns[addIndex] = [MovingObject rawPosition: turnPoint];
        turns[addIndex] = newDirection;
        addIndex++;
    }
}
-(CGPoint)startPoint{
    return startPoint;
}
-(GameDirection)startDirection{
    return startDirection;
}
-(void)advanceIndex{
    getIndex++;
    if(getIndex >= addIndex){
        getIndex = 0;
    }
}
-(CGPoint)nextPoint{
    return pointsForTurns[getIndex];
}
-(GameDirection)nextDirection{
    return turns[getIndex];
}
-(void)dealloc{
    [super dealloc];
}
@end
