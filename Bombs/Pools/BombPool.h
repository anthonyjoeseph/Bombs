//
//  BombFactory.h
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BufferPool.h"
#import "BombObserver.h"

@interface BombPool : BufferPool <BombObserver>{
    int numBombs;
    int maxNumBombs;
    int bombLength;
    float bombDuration;
}
-(void)bombDied;
-(int)bombLength;
-(float)bombDuration;
-(void)heavyBombs;
-(void)lightBombs;
-(void)restoreDefaults;

@end
