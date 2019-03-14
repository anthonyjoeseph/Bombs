//
//  Path.h
//  Detonate
//
//  Created by Anthony Gabriele on 1/12/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

#define maxNumTurns 100

@interface Path : NSObject{
    CGPoint startPoint;
    GameDirection startDirection;
    GameDirection turns[maxNumTurns];
    CGPoint pointsForTurns[maxNumTurns];
    int addIndex;
    int getIndex;
}
-(id)initWithStartPointInTiles:(CGPoint)startPoint startDirection:(GameDirection)startDirection;
-(void)addTurnPointInTiles:(CGPoint)turnPoint direction:(GameDirection)newDirection;
-(CGPoint)startPoint;
-(GameDirection)startDirection;
-(void)advanceIndex;
-(CGPoint)nextPoint;
-(GameDirection)nextDirection;

@end
