//
//  InversePlayer.h
//  Detonate
//
//  Created by Anthony Gabriele on 1/12/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "BadGuy.h"
#import "ControllablePlayer.h"

@interface InversePlayer : BadGuy <ControllablePlayer>{
    GameObjectPool *_bombPool;
    bool isHurt;
    float timeHurt;
    bool isHurtCantMove;
    float timeHurtCantMove;
    int damage;
}
-(void)spawnBomb;

@property (nonatomic, retain) GameObjectPool *bombPool;
@end
