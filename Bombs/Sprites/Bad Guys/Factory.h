//
//  Factory.h
//  Detonate
//
//  Created by Anthony Gabriele on 1/10/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "BadGuy.h"
#import "CreationPool.h"

@interface Factory : BadGuy {
    int damage;
    float timeSinceLastRobot;
    GameObjectPool *storBotPool;
    GameObjectPool *sharkPool;
    GameObjectPool *fireBallPool;
    bool firstTime;
    bool isHurt;
    float timeSinceHurt;
    bool isDying;
    float timeSinceShark;
}

@end
