//
//  BetweenLevelScene.m
//  Detonate
//
//  Created by Anthony Gabriele on 1/8/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "BetweenLevelScene.h"
#import "CCMenuItem.h"
#import "CCLabelTTF.h"
#import "CCMenu.h"
#import "CCDirector.h"
#import "PlayerData.h"
#import "SimpleAudioEngine.h"
#import "GameplayScene.h"
#import "GamePreferences.h"
#import "LevelSelectScene.h"
#import "MainMenuScene.h"

@implementation BetweenLevelScene

-(id)initWithNumPlayers:(int)_numPlayers world:(int)_currentWorldNumber level:(int)_currentLevelNumber{
    if((self = [super init])){
        [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
        
        CCSprite *background;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            background = [CCSprite spriteWithFile:@"Win-iPad.png"];
        }else{
            background = [CCSprite spriteWithFile:@"Win-iPhone.png"];
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
        
        CCMenuItemFont *nextLevel = [[CCMenuItemFont alloc] initFromString:NSLocalizedString(@"NEXT LEVEL", nil) target:self selector:@selector(nextLevel)];
        CCMenuItemFont *replay = [[CCMenuItemFont alloc] initFromString:NSLocalizedString(@"RETRY THE LEVEL", nil) target:self selector:@selector(replay)];
        CCMenuItemFont *levelSelect = [[CCMenuItemFont alloc] initFromString:NSLocalizedString(@"SELECT ANOTHER LEVEL", nil) target:self selector:@selector(levelSelect)];
        CCMenuItemFont *mainMenu = [[CCMenuItemFont alloc] initFromString:NSLocalizedString(@"GO TO MAIN MENU", nil) target:self selector:@selector(mainMenu)];
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            nextLevel.position = ccp(winWidth/2, winHeight/2-90);
            replay.position = ccp(winWidth/2, winHeight/2 - 130);
            levelSelect.position = ccp(winWidth/2, winHeight/2 - 170);
            mainMenu.position = ccp(winWidth/2, winHeight/2 - 210);
        }else{
            nextLevel.position = ccp(winWidth/2-50, winHeight/2-30);
            replay.position = ccp(winWidth/2-70, winHeight/2 - 70);
            levelSelect.position = ccp(winWidth/2-50, winHeight/2 - 110);
            mainMenu.position = ccp(winWidth/2+90, winHeight/2 - 70);
        }
        /*nextLevel.color = ccRED;
        replay.color = ccRED;
        levelSelect.color = ccRED;
        mainMenu.color = ccRED;*/
        
        CCMenu *theMenu;
        theMenu = [CCMenu menuWithItems:nextLevel, replay, levelSelect, mainMenu, nil];
        //[theMenu alignItemsVerticallyWithPadding:0.5];
        theMenu.position = ccp(0,0);
        [self addChild:theMenu];
        [nextLevel release];
        [replay release];
        [levelSelect release];
        [mainMenu release];
    }
    return self;
}
-(void)nextLevel{
    if(!wasClicked){
        wasClicked = YES;
        [[SimpleAudioEngine sharedEngine] playEffect:@"MenuSoundEffect.m4v"];
        int nextWorldNumber = currentWorldNumber;
        int nextLevelNumber = currentLevelNumber + 1;
        if(nextLevelNumber > 10){
            nextWorldNumber = currentWorldNumber + 1;
            nextLevelNumber = 1;
        }
        if(nextWorldNumber > kNumWorlds){
            [[CCDirector sharedDirector] replaceScene: [MainMenuScene node]];
        }
        [[CCDirector sharedDirector] replaceScene:[[[GameplayScene alloc] initWithNumberOfPlayers:numPlayers worldNumber:nextWorldNumber levelNumber:nextLevelNumber] autorelease]];
    }
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
