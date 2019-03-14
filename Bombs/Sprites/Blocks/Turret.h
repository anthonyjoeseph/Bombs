//
//  Turret.h
//  Detonate
//
//  Created by Anthony Gabriele on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BreakableBlock.h"
#import "MustKill.h"
#import "KnowsPlayer.h"
#import "Player.h"
#import "Constants.h"
#import "HasProperties.h"
#import "ShootingBehavior.h"

@interface Turret : Block <HasProperties, Breakable, MustKill, KnowsPlayer>{
    ShootingBehavior *_shootBehavior;
    EvilBehavior *_rotateBehavior;
}
-(void)addProperties:(NSDictionary *)properties;

@property (nonatomic, retain) ShootingBehavior *shootBehavior;
@property (nonatomic, retain) EvilBehavior *rotateBehavior;
@end
