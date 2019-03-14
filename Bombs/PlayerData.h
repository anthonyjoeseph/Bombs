//
//  PlayerData.h
//  Detonate
//
//  Created by Anthony Gabriele on 9/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface PlayerData : NSObject <NSCoding>{
    bool completedLevelsByWorld[kNumWorlds][kNumLevels];
    double damagesByWorld[kNumWorlds][kNumLevels];
}

-(void)damageTaken:(double)_damage atWorld:(int)worldNumber level:(int)levelNumber;
-(double)loadDamageTakenWorld:(int)worldNumber level:(int)levelNumber;
-(int)loadLivesWorld:(int)worldNumber level:(int)levelNumber;
-(double)loadHealthWorld:(int)worldNumber level:(int)levelNumber;
-(int)firstUncompletedWorld;
-(int)firstUncompletedLevelFromWorld:(int)worldNumber;
-(id)initWithCoder:(NSCoder *)coder;
-(void)encodeWithCoder:(NSCoder *)coder;
@end
