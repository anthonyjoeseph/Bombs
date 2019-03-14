//
//  ShootingBehavior.h
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EvilBehavior.h"
#import "GameObjectPool.h"


@interface ShootingBehavior : EvilBehavior {
    bool firstTime;
    bool canSee;
    bool canShoot;
    int numProjectiles;
    float _reloadTime;
    float timeSinceLastReload;
    GameObjectPool *_projectilePool;
}
-(id)initWithBadGuy:(GameObject *)badGuy projectilePool:(GameObjectPool *)projectilePool reloadTime:(float)reloadTime;

@property (nonatomic, retain) GameObjectPool *projectilePool;
@property (readwrite) float reloadTime;
@end
