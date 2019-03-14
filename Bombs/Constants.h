//
//  Constants.h
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CCDirector.h"
#define kTileSize 50
#define kBoardWidthInTiles 17
#define kBoardHeightInTiles 15
#define kNumWorlds 5
#define kNumLevels 10
#define kDefaultPlayerMovementSpeed 0.3
#define kDefaultBadGuyMovementSpeed 0.5
#define kDefaultProjectileSpeed 0.2
#define kDefaultProjectileReloadTime 4.0
#define kDefaultMaxNumBombs 5
#define kDefaultBombLength 2
#define kDefaultBombTime 5
#define kDefaultExplosionTime 0.4
#define kDefaultPlayerHurtTime 1.5
#define kPowerUpLifeTime 10
#define kOneHit 12.5
#define kTimeLevelLastsAfterOver 3.0

typedef enum{
    kUp,
    kDown,
    kLeft,
    kRight
} GameDirection;