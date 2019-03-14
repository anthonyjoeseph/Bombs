//
//  GameOverScene.m
//  Detonate
//
//  Created by Anthony Gabriele on 1/12/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "GameOverScene.h"
#import "SimpleAudioEngine.h"
#import "GamePreferences.h"
#import "PlayerData.h"
#import "LevelSelectScene.h"
#import "MainMenuScene.h"
#import "GameplayScene.h"

@implementation GameOverScene

-(id)initWithNumPlayers:(int)_numPlayers world:(int)_currentWorldNumber level:(int)_currentLevelNumber{
    if((self = [super init])){
        [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
        
        CCSprite *background;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            background = [CCSprite spriteWithFile:@"GameOver-iPad.png"];
        }else{
            background = [CCSprite spriteWithFile:@"GameOver-iPhone.png"];
        }
        double winWidth = [CCDirector sharedDirector].winSize.width;
        double winHeight = [CCDirector sharedDirector].winSize.height;
        background.anchorPoint = ccp(0.5, 0.5);
        background.position = ccp(winWidth/2,winHeight/2);
        [self addChild:background];
        
        numPlayers = _numPlayers;
        wasClicked = NO;
        currentWorldNumber = _currentWorldNumber;
        currentLevelNumber = _currentLevelNumber;
        
        CCMenuItemFont *replay = [[CCMenuItemFont alloc] initFromString:NSLocalizedString(@"RETRY THE LEVEL", nil) target:self selector:@selector(replay)];
        CCMenuItemFont *levelSelect = [[CCMenuItemFont alloc] initFromString:NSLocalizedString(@"SELECT ANOTHER LEVEL", nil) target:self selector:@selector(levelSelect)];
        CCMenuItemFont *mainMenu = [[CCMenuItemFont alloc] initFromString:NSLocalizedString(@"GO TO MAIN MENU", nil) target:self selector:@selector(mainMenu)];
        replay.color = ccBLACK;
        levelSelect.color = ccBLACK;
        mainMenu.color = ccBLACK;
        CCMenu *theMenu;
        theMenu = [CCMenu menuWithItems:replay, levelSelect, mainMenu, nil];
        [theMenu alignItemsVerticallyWithPadding:0.5];
        [self addChild:theMenu];
        [replay release];
        [levelSelect release];
        [mainMenu release];
    }
    return self;
}
-(void)replay{
    if(!wasClicked){
        wasClicked = YES;
        [[SimpleAudioEngine sharedEngine] playEffect:@"MenuSoundEffect.m4v"];
        [[CCDirector sharedDirector] replaceScene:[[[GameplayScene alloc] initWithNumberOfPlayers:numPlayers worldNumber:currentWorldNumber levelNumber:currentLevelNumber] autorelease]];
    }
}
-(void)levelSelect{
    if(!wasClicked){
        wasClicked = YES;
        [[SimpleAudioEngine sharedEngine] playEffect:@"MenuSoundEffect.m4v"];
        [[CCDirector sharedDirector] replaceScene:[[[LevelSelectScene alloc] initWithNumPlayers:1] autorelease]];
    }
}
-(void)mainMenu{
    if(!wasClicked){
        wasClicked = YES;
        [[SimpleAudioEngine sharedEngine] playEffect:@"MenuSoundEffect.m4v"];
        [[CCDirector sharedDirector] replaceScene:[[[MainMenuScene alloc] init] autorelease]];
    }
}
@end
