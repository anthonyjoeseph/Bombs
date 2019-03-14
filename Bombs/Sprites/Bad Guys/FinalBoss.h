//
//  FinalBoss.h
//  Detonate
//
//  Created by Anthony Gabriele on 1/10/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "BadGuy.h"

@interface FinalBoss : BadGuy{
    GameObjectPool *projectilePool;
    float radius;
    float degreesPerSecond;
    float currentDegree;
    float reloadTime;
    float timeSinceShot;
    bool isHurt;
    float timeHurt;
    int damage;
    bool isDying;
    float timeDying;
    Player *playerOne;
    Player *playerTwo;
    
    bool firstTime;
}

@end
