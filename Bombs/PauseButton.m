//
//  PauseButton.m
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PauseButton.h"
#import "GamePreferences.h"
#import "SimpleAudioEngine.h"
#import "MainMenuScene.h"
@class GameplayScene;


@implementation PauseButton

-(id)initWithContext:(CCScene *)newContext world:(int)_worldNum level:(int)_levelNum numPlayers:(int)_numPlayers{
    if((self = [super initFromNormalImage:@"pausebutton.gif" selectedImage:@"pausebutton.gif" disabledImage:@"pauseButton.gif" target:self selector:@selector(pauseButtonTapped:)])){
        context = newContext;
        worldNum = _worldNum;
        levelNum = _levelNum;
        numPlayers = _numPlayers;
    }
    return self;
}
-(void)pauseButtonTapped:(id)sender{
    if([GamePreferences sharedInstance].pauseScreenUp == NO){
        [[SimpleAudioEngine sharedEngine] playEffect:@"Pause.m4v"];
		[GamePreferences sharedInstance].pauseScreenUp = YES;
		[[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
		[[CCDirector sharedDirector] pause];
		CGSize s = [[CCDirector sharedDirector] winSize];
		pauseLayer = [CCLayerColor layerWithColor: ccc4(127, 127, 127, 125) width: s.width height: s.height];
		
		pauseLayer.position = CGPointZero;
		[context addChild: pauseLayer z:8];
		
		_pauseScreen =[[CCSprite spriteWithFile:@"PauseBackground.png"] retain];
        
        double winWidth = [[CCDirector sharedDirector] winSize].width;
        double winHeight = [[CCDirector sharedDirector] winSize].height;
        
		_pauseScreen.position= ccp(winWidth/2, winHeight/2);
		[context addChild:_pauseScreen z:8];
		
		CCMenuItemFont *ResumeMenuItem = [[CCMenuItemFont alloc] initFromString:NSLocalizedString(@"RESUME PAUSED GAME", nil) target:self selector:@selector(resumeButtonTapped:)];
		ResumeMenuItem.position = ccp(0, 70);
        ResumeMenuItem.color = ccYELLOW;
		CCMenuItemFont *ReplayMenuItem = [[CCMenuItemFont alloc] initFromString:NSLocalizedString(@"RETRY THE LEVEL", nil) target:self selector:@selector(replayButtonTapped:)];
		ReplayMenuItem.position = ccp(0, 0);
        ReplayMenuItem.color = ccYELLOW;
		CCMenuItemFont *QuitMenuItem = [[CCMenuItemFont alloc] initFromString:NSLocalizedString(@"GO TO MAIN MENU", nil) target:self selector:@selector(quitButtonTapped:)];
		QuitMenuItem.position = ccp(0, -70);
        QuitMenuItem.color = ccYELLOW;
		_pauseScreenMenu = [CCMenu menuWithItems:ResumeMenuItem, ReplayMenuItem, QuitMenuItem, nil];
        _pauseScreenMenu.position = ccp(0,0);
        [ResumeMenuItem release];
        [QuitMenuItem release];
        
		_pauseScreenMenu.position = ccp(winWidth/2, winHeight/2);
		[context addChild:_pauseScreenMenu z:10];
	}
}
-(void)resumeButtonTapped:(id)sender{
	[context removeChild:_pauseScreen cleanup:YES];
	[context removeChild:_pauseScreenMenu cleanup:YES];
	[context removeChild:pauseLayer cleanup:YES];
    [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
	[[CCDirector sharedDirector] resume];
	[GamePreferences sharedInstance].pauseScreenUp=FALSE;
}
-(void)replayButtonTapped:(id)sender{
	[context removeChild:_pauseScreen cleanup:YES];
	[context removeChild:_pauseScreenMenu cleanup:YES];
	[context removeChild:pauseLayer cleanup:YES];
	[[CCDirector sharedDirector] resume];
	[GamePreferences sharedInstance].pauseScreenUp=FALSE;
    [[CCDirector sharedDirector] replaceScene:[[GameplayScene alloc] initWithNumberOfPlayers:numPlayers worldNumber:worldNum levelNumber:levelNum]];
}
-(void)quitButtonTapped:(id)sender{
	[context removeChild:_pauseScreen cleanup:YES];
	[context removeChild:_pauseScreenMenu cleanup:YES];
	[context removeChild:pauseLayer cleanup:YES];
	[[CCDirector sharedDirector] resume];
	[GamePreferences sharedInstance].pauseScreenUp=FALSE;
	[[CCDirector sharedDirector] replaceScene:[[[MainMenuScene alloc] init] autorelease]];
}
@end
