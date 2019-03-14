//
//  InterfaceLayer.h
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ControllablePlayer.h"
typedef enum{
    kDPadInterface = 0,
    kLargeDPadInterface = 1,
    kTouchInterface = 2
} InterfaceType;

@interface InterfaceLayer : CCLayer {
    id<ControllablePlayer> _controlPlayer;
    CCNode *_contextNode;
}

@property (nonatomic, assign) id<ControllablePlayer> controlPlayer;
@property (nonatomic, assign) CCNode *contextNode;
@end