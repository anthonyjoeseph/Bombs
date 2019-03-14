//
//  PlayerData.m
//  Detonate
//
//  Created by Anthony Gabriele on 9/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlayerData.h"

@implementation PlayerData
-(id)init{
    if((self = [super init])){
        for(int i = 0; i < kNumWorlds; i++){
            for (int e = 0; e < kNumLevels; e++) {
                completedLevelsByWorld[i][e] = NO;
            }
        }
        for(int i = 0; i < kNumWorlds; i++){
            for (int e = 0; e < kNumLevels; e++) {
                damagesByWorld[i][e] = 0.0;
            }
        }
        //it's important to note that these are saved as worlds 0-4 and levels 0-9 instead of 1-5 and 1-10
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)coder{
    if((self = [super init])){
        for(int i = 0; i < kNumWorlds; i++){
            for (int e = 0; e < kNumLevels; e++) {
                completedLevelsByWorld[i][e] = [coder decodeBoolForKey:[NSString stringWithFormat:@"CompletedLevelsByWorld%i%i", i, e]];
            }
        }
        for(int i = 0; i < kNumWorlds; i++){
            for (int e = 0; e < kNumLevels; e++) {
                damagesByWorld[i][e] = [coder decodeDoubleForKey:[NSString stringWithFormat:@"DamagesByWorld%i%i", i, e]];
            }
        }
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)coder{
    for(int i = 0; i < kNumWorlds; i++){
        for (int e = 0; e < kNumLevels; e++) {
            [coder encodeBool:completedLevelsByWorld[i][e] forKey:[NSString stringWithFormat:@"CompletedLevelsByWorld%i%i", i, e]];
        }
    }
    for(int i = 0; i < kNumWorlds; i++){
        for (int e = 0; e < kNumLevels; e++) {
            [coder encodeDouble:damagesByWorld[i][e] forKey:[NSString stringWithFormat:@"DamagesByWorld%i%i", i, e]];
        }
    }
}
-(void)damageTaken:(double)damage atWorld:(int)worldNumber level:(int)levelNumber{
    if(completedLevelsByWorld[worldNumber - 1][levelNumber - 1] == NO){
        completedLevelsByWorld[worldNumber - 1][levelNumber - 1] = YES;
        damagesByWorld[worldNumber - 1][levelNumber - 1] = damage;
    }else if(damage < damagesByWorld[worldNumber - 1][levelNumber - 1]){
        damagesByWorld[worldNumber - 1][levelNumber - 1] = damage;
    }
}
-(double)loadDamageTakenWorld:(int)worldNumber level:(int)levelNumber{
    return damagesByWorld[worldNumber - 1][levelNumber - 1];
}
-(int)loadLivesWorld:(int)worldNumber level:(int)levelNumber{
    double cumulativeDamage = 0;
    for(int i = 0; i < levelNumber - 1; i++){
        cumulativeDamage += damagesByWorld[worldNumber - 1][i];
    }
    return 3 - floor(cumulativeDamage / 100);
}
-(double)loadHealthWorld:(int)worldNumber level:(int)levelNumber{
    double cumulativeDamage = 0;
    for(int i = 0; i < levelNumber - 1; i++){
        cumulativeDamage += damagesByWorld[worldNumber - 1][i];
    }
    double damageInLivesTaken = cumulativeDamage / 100;
    double numberLostLives = floor(cumulativeDamage / 100);
    return 100 - ((damageInLivesTaken - numberLostLives) * 100);
}
-(int)firstUncompletedWorld{
    int indexOfFirstUncompletedWorld = 0;
    while(completedLevelsByWorld[indexOfFirstUncompletedWorld][kNumLevels - 1]){
        indexOfFirstUncompletedWorld++;
    }
    return indexOfFirstUncompletedWorld + 1;
}
-(int)firstUncompletedLevelFromWorld:(int)worldNumber{
    int indexOfFirstUncompletedLevel = 0;
    while(completedLevelsByWorld[worldNumber - 1][indexOfFirstUncompletedLevel]){
        indexOfFirstUncompletedLevel++;
    }
    return indexOfFirstUncompletedLevel + 1;
}

@end
