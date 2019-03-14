//
//  BombObservable.h
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BombObserver.h"

@protocol BombObservable <NSObject>
-(void)registerBombObserver:(id<BombObserver>)theObserver;
@end
