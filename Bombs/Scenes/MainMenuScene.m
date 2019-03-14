//
//  MainMenuScene.m
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainMenuScene.h"
#import "GameplayScene.h"
#import "LevelSelectScene.h"
#import "SimpleAudioEngine.h"
#import "GamePreferences.h"
#import "PlayerData.h"


@implementation MainMenuScene

-(id)init{
    if((self = [super init])){
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"Mute"]){
            [SimpleAudioEngine sharedEngine].mute = YES;
        }
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"MainTheme.m4a"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
        
        winWidth = [[CCDirector sharedDirector] winSize].width;
        winHeight = [[CCDirector sharedDirector] winSize].height;
        
        CCSprite *background;
        movingBadGuy = [CCSprite spriteWithFile:@"OpeningBadGuy.png"];
        movingBadGuy.anchorPoint = ccp(0, 0);
        movingBadGuy.position = ccp(winWidth/-8, -50);
        movingBadGuy.scale = (winWidth / movingBadGuy.contentSize.width) / 2;
        badGuyMovingUp = YES;
        
        CCMenuItemFont *preferences = [[CCMenuItemFont alloc] initFromString:NSLocalizedString(@"PREFERENCES", nil) target:self selector:@selector(preferences)];
        CCSprite *backSprite = [CCSprite spriteWithFile:@"BackArrow.png"];
        CCSprite *selectedSprite = [CCSprite spriteWithFile:@"BackArrowSelected.png"];
        CCSprite *disabledSprite = [CCSprite spriteWithFile:@"BackArrowSelected.png"];
        CCMenuItem *backButton = [[CCMenuItemSprite alloc] initFromNormalSprite:backSprite selectedSprite:selectedSprite disabledSprite:disabledSprite target:self selector:@selector(mainMenu)];
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            NSString *onePlayerString = NSLocalizedString(@"GAME START ONE PLAYER", nil);
            NSString *twoPlayerString = NSLocalizedString(@"GAME START TWO PLAYERS", nil);
            CCMenuItemFont *onePlayer = [[CCMenuItemFont alloc] initFromString:onePlayerString target:self selector:@selector(onePlayer)];
            CCMenuItemFont *twoPlayers = [[CCMenuItemFont alloc] initFromString:twoPlayerString target:self selector:@selector(twoPlayers)];
            CCMenuItemFont *howTo = [[CCMenuItemFont alloc] initFromString:NSLocalizedString(@"HOW TO", nil) target:self selector:@selector(howTo)];
            openingMenu = [[CCMenu menuWithItems:onePlayer, twoPlayers, preferences, howTo, nil] retain];
            onePlayer.position = ccp(winWidth*.66 + 90, winHeight/2 + 20);
            twoPlayers.position = ccp(winWidth*.66 + 90, winHeight/2 - 40);
            preferences.position = ccp(winWidth*.66 + 90, winHeight/2 - 100);
            howTo.position = ccp(winWidth*.66 + 90, winHeight/2 - 160);
            onePlayer.color = ccBLACK;
            twoPlayers.color = ccBLACK;
            preferences.color = ccBLACK;
            howTo.color = ccBLACK;
            [onePlayer release];
            [twoPlayers release];
            [howTo release];
            
            CCMenuItemFont *playerOneDpad = [[CCMenuItemFont alloc] initFromString:NSLocalizedString(@"PLAYER ONE INTERFACE IS D-PAD", nil) target:self selector:@selector(playerOneDpad)];
            CCMenuItemFont *playerOneLargeDpad = [[CCMenuItemFont alloc] initFromString:NSLocalizedString(@"PLAYER ONE INTERFACE IS LARGE D-PAD", nil) target:self selector:@selector(playerOneLargeDpad)];
            CCMenuItemFont *playerOneTouch = [[CCMenuItemFont alloc] initFromString:NSLocalizedString(@"PLAYER ONE INTERFACE IS TOUCH", nil) target:self selector:@selector(playerOneTouch)];
            CCMenuItemFont *playerTwoDpad = [[CCMenuItemFont alloc] initFromString:NSLocalizedString(@"PLAYER TWO INTERFACE IS D-PAD", nil) target:self selector:@selector(playerTwoDpad)];
            CCMenuItemFont *playerTwoLargeDpad = [[CCMenuItemFont alloc] initFromString:NSLocalizedString(@"PLAYER TWO INTERFACE IS LARGE D-PAD", nil) target:self selector:@selector(playerTwoLargeDpad)];
            CCMenuItemFont *mute = [[CCMenuItemFont alloc] initFromString:NSLocalizedString(@"MUTE", nil) target:self selector:@selector(mute)];
            playerOneDpad.position = ccp(winWidth*.66 + 90, winHeight/2 + 30);
            playerOneLargeDpad.position = ccp(winWidth*.66 + 90, winHeight/2 - 30);
            playerOneTouch.position = ccp(winWidth*.66 + 90, winHeight/2 - 90);
            playerTwoDpad.position = ccp(winWidth*.66 + 90, winHeight/2 - 150);
            playerTwoLargeDpad.position = ccp(winWidth*.66 + 90, winHeight/2 - 210);
            mute.position = ccp(winWidth*.66 + 90, winHeight/2 - 270);
            playerOneDpad.color = ccBLACK;
            playerOneLargeDpad.color = ccBLACK;
            playerOneTouch.color = ccBLACK;
            playerTwoDpad.color = ccBLACK;
            playerTwoLargeDpad.color = ccBLACK;
            mute.color = ccBLACK;
            backButton.position = ccp(winWidth*.66 + 90, winHeight/2 - 310);
            preferencesMenu = [[CCMenu menuWithItems:playerOneDpad, playerOneLargeDpad, playerOneTouch, playerTwoDpad, playerTwoLargeDpad, mute, backButton, nil] retain];
            [playerOneDpad release];
            [playerOneLargeDpad release];
            [playerOneTouch release];
            [playerTwoDpad release];
            [playerTwoLargeDpad release];
            [mute release];
            
            background = [CCSprite spriteWithFile:@"MainScreen-iPad.png"];
        }else{
            CCMenuItemFont *lonePlayer = [[CCMenuItemFont alloc] initFromString:NSLocalizedString(@"GAME START", nil) target:self selector:@selector(onePlayer)];
            CCMenuItemFont *howTo = [[CCMenuItemFont alloc] initFromString:NSLocalizedString(@"HOW TO", nil) target:self selector:@selector(howTo)];
            openingMenu = [[CCMenu menuWithItems:lonePlayer, preferences, howTo, nil] retain];
            lonePlayer.position = ccp(winWidth*.66+30, winHeight/2 - 20);
            preferences.position = ccp(winWidth*.66+30, winHeight/2 - 80);
            howTo.position = ccp(winWidth*.66+30, winHeight/2 - 140);
            lonePlayer.color = ccBLACK;
            preferences.color = ccBLACK;
            howTo.color = ccBLACK;
            [lonePlayer release];
            [howTo release];
            
            CCMenuItemFont *dPad = [[CCMenuItemFont alloc] initFromString:NSLocalizedString(@"INTERFACE IS D-PAD", nil) target:self selector:@selector(playerOneDpad)];
            CCMenuItemFont *touch = [[CCMenuItemFont alloc] initFromString:NSLocalizedString(@"INTERFACE IS TOUCH", nil) target:self selector:@selector(playerOneTouch)];
            CCMenuItemFont *mute = [[CCMenuItemFont alloc] initFromString:NSLocalizedString(@"MUTE", nil) target:self selector:@selector(mute)];
            dPad.position = ccp(winWidth*.66+30, winHeight/2);
            touch.position = ccp(winWidth*.66+30, winHeight/2 - 40);
            mute.position = ccp(winWidth*.66+30, winHeight/2 - 80);
            backButton.position = ccp(winWidth*.66+30, winHeight/2 - 130);
            dPad.color = ccBLACK;
            touch.color = ccBLACK;
            mute.color = ccBLACK;
            preferencesMenu = [[CCMenu menuWithItems:dPad, touch, mute, backButton, nil] retain];
            [dPad release];
            [touch release];
            [mute release];
            
            background = [CCSprite spriteWithFile:@"MainScreen-iPhone.png"];
            background.scaleX = [[CCDirector sharedDirector] winSize].width/background.contentSize.width;
        }
        [preferences release];
        [backButton release];
        openingMenu.position = ccp(0,0);
        preferencesMenu.position = ccp(0,0);
        background.position = ccp(winWidth/2, winHeight/2);
        [self addChild: background];
        [self addChild: openingMenu];
        [self addChild: movingBadGuy];
        wasClicked = NO;
        [self schedule:@selector(update:)];
    }
    return self;
}
-(void)update:(float)dt{
    CGPoint currentPosition = movingBadGuy.position;
    float x = currentPosition.x;
    float y;
    if(badGuyMovingUp){
        y = currentPosition.y + (dt*150);
        if(y > -20){
            badGuyMovingUp = NO;
        }
    }else{
        y = currentPosition.y - (dt*150);
        if(y < -100){
            badGuyMovingUp = YES;
        }
    }
    movingBadGuy.position = ccp(x, y);
}
-(CCAnimation *)loadAnimation:(NSString *)fileName frameCount:(int)numFrames frameDuration:(float)delay{
	NSString *plistFileName = [fileName stringByAppendingString:@".plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: plistFileName];
    
    NSMutableArray *frames = [[NSMutableArray alloc] init];
    CCSpriteFrame *theFrame;
    NSString *frameName;
    for(int i = 1; i <= numFrames; i++) {
        frameName = [fileName stringByAppendingString:[NSString stringWithFormat: @"%i.png", i]];
        theFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: frameName];
        [frames addObject: theFrame];
    }
    return [CCAnimation animationWithFrames:[frames autorelease] delay:delay];
}
-(void)onePlayer{
    if(!wasClicked){
        wasClicked = YES;
        [[SimpleAudioEngine sharedEngine] playEffect:@"MenuSoundEffect.m4v"];
        [[CCDirector sharedDirector] replaceScene:[[[LevelSelectScene alloc] initWithNumPlayers:1] autorelease]];
    }
}
-(void)twoPlayers{
    if(!wasClicked){
        wasClicked = YES;
        [[SimpleAudioEngine sharedEngine] playEffect:@"MenuSoundEffect.m4v"];
        [[CCDirector sharedDirector] replaceScene:[[[LevelSelectScene alloc] initWithNumPlayers:2] autorelease]];
    }
}
-(void)preferences{
        [[SimpleAudioEngine sharedEngine] playEffect:@"MenuSoundEffect.m4v"];
        [self removeChild:openingMenu cleanup:YES];
        [self addChild:preferencesMenu];
}
-(void)howTo{
    NSString *launchUrl = @"https://sites.google.com/site/bombstheapp/home/how-to-play";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: launchUrl]];
}
-(void)mainMenu{
        [[SimpleAudioEngine sharedEngine] playEffect:@"MenuSoundEffect.m4v"];
        [self removeChild:preferencesMenu cleanup:YES];
        [self addChild:openingMenu];
}
-(void)playerOneDpad{
    [[SimpleAudioEngine sharedEngine] playEffect:@"MenuSoundEffect.m4v"];
    [GamePreferences sharedInstance].playerOneInterfaceType = kDPadInterface;
    [[NSUserDefaults standardUserDefaults] setInteger:kDPadInterface forKey:@"PlayerOneInterfaceType"];
}
-(void)playerOneLargeDpad{
    [[SimpleAudioEngine sharedEngine] playEffect:@"MenuSoundEffect.m4v"];
    [GamePreferences sharedInstance].playerOneInterfaceType = kLargeDPadInterface;
    [[NSUserDefaults standardUserDefaults] setInteger:kLargeDPadInterface forKey:@"PlayerOneInterfaceType"];
}
-(void)playerOneTouch{
    [[SimpleAudioEngine sharedEngine] playEffect:@"MenuSoundEffect.m4v"];
    [GamePreferences sharedInstance].playerOneInterfaceType = kTouchInterface;
    [[NSUserDefaults standardUserDefaults] setInteger:kTouchInterface forKey:@"PlayerOneInterfaceType"];
}
-(void)playerTwoDpad{
    [[SimpleAudioEngine sharedEngine] playEffect:@"MenuSoundEffect.m4v"];
    [GamePreferences sharedInstance].playerTwoInterfaceType = kDPadInterface;
    [[NSUserDefaults standardUserDefaults] setInteger:kDPadInterface forKey:@"PlayerTwoInterfaceType"];
}
-(void)playerTwoLargeDpad{
    [[SimpleAudioEngine sharedEngine] playEffect:@"MenuSoundEffect.m4v"];
    [GamePreferences sharedInstance].playerTwoInterfaceType = kLargeDPadInterface;
    [[NSUserDefaults standardUserDefaults] setInteger:kLargeDPadInterface forKey:@"PlayerTwoInterfaceType"];
}
-(void)mute{
    bool newMuteStatus = ![SimpleAudioEngine sharedEngine].mute;
    [SimpleAudioEngine sharedEngine].mute = newMuteStatus;
    [[NSUserDefaults standardUserDefaults] setBool:newMuteStatus forKey:@"Mute"];
    if(newMuteStatus == NO && ![[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying]){
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"MainTheme.m4a"];
    }
}
-(void)dealloc{
    [openingMenu release];
    [preferencesMenu release];
    [super dealloc];
}

@end
