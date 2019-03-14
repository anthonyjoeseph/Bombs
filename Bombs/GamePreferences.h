//
//  GamePreferences.h
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InterfaceLayer.h"
#import "PowerUp.h"
#import "PlayerData.h"

@interface GamePreferences : NSObject {
    bool _pauseScreenUp;
    
    PlayerData *_onePlayerData;
    PlayerData *_twoPlayerPlayerOneData;
    PlayerData *_twoPlayerPlayerTwoData;
}
-(void)savePlayerProgress;

+(GamePreferences *)sharedInstance;

@property (nonatomic, assign) bool pauseScreenUp;
@property (nonatomic, retain) PlayerData *onePlayerData;
@property (nonatomic, retain) PlayerData *twoPlayerPlayerOneData;
@property (nonatomic, retain) PlayerData *twoPlayerPlayerTwoData;
@property (assign) InterfaceType *playerOneInterfaceType;
@property (assign) InterfaceType *playerTwoInterfaceType;

@end
