//
//  BombObserver.h
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameObjectPool.h"

@protocol BombObserver <NSObject>
-(void)bombDied;
-(int)bombLength;
-(float)bombDuration;
-(void)heavyBombs;
-(void)lightBombs;
-(void)restoreDefaults;
@end
