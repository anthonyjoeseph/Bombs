//
//  ControllablePlayer.h
//  Detonate
//
//  Created by Anthony Gabriele on 1/12/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@protocol ControllablePlayer <NSObject>
-(CGPoint)position;
-(GameDirection)direction;
-(void)setDirection:(GameDirection)direction;
-(void)startMoving;
-(void)stopMoving;
-(void)spawnBomb;

@end
