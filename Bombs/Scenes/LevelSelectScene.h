//
//  LevelSelectScene.h
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCScrollLayer.h"


@interface LevelSelectScene : CCScene{
    CCNode *parentNode;
    bool isOnLevelSelect;
    int currentWorldNumber;
    int numPlayers;
    CCMenu *backButtonMenu;
    ccColor4B worldColors[5];
}
-(id)initWithNumPlayers:(int)_numPlayers;
-(void)worldSetup;
-(void)levelSetup:(int)worldNumber;
-(void)launchWorld:(CCMenuItem *)sender;
-(void)launchLevel:(CCMenuItem *)sender;
-(void)addBackButton;
-(void)back;

@end
