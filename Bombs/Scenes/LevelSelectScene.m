//
//  LevelSelectScene.m
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LevelSelectScene.h"
#import "CCScrollLayer.h"
#import "CCMenuItemSpriteIndependent.h"
#import "GameplayScene.h"
#import "MainMenuScene.h"
#import "Constants.h"
#import "SimpleAudioEngine.h"
#import "HealthBar.h"
#import "GamePreferences.h"
#import "PlayerData.h"

@implementation LevelSelectScene

-(id)initWithNumPlayers:(int)_numPlayers{
    if((self = [super init])){
        [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
        ccColor4B worldOne = ccc4(225, 125, 100, 100);
        ccColor4B worldTwo = ccc4(25, 225, 100, 100);
        ccColor4B worldThree = ccc4(180, 0, 225, 100);
        ccColor4B worldFour = ccc4(0, 128, 128, 100);
        ccColor4B worldFive = ccc4(225, 0, 0, 100);
        worldColors[0] = worldOne;
        worldColors[1] = worldTwo;
        worldColors[2] = worldThree;
        worldColors[3] = worldFour;
        worldColors[4] = worldFive;
        
        numPlayers = _numPlayers;
        [self worldSetup];
    }
    return self;
}
-(void)worldSetup{
    isOnLevelSelect = NO;
    if(parentNode){
        [self removeChild:parentNode cleanup:YES];
    }
    NSMutableArray* allLayers = [[NSMutableArray alloc] init];
    
    PlayerData *theProgressData;
    if(numPlayers == 1){
        theProgressData = [GamePreferences sharedInstance].onePlayerData;
    }else{
        theProgressData = [GamePreferences sharedInstance].twoPlayerPlayerOneData;
    }
    
    // create a menu item for each character
    double winWidth = [[CCDirector sharedDirector] winSize].width;
    double winHeight = [[CCDirector sharedDirector] winSize].height;
    int worldNumber = 1;
    NSString* normalImage;
    CCSprite* normalSprite;
    CCSprite* selectedSprite;
    while(worldNumber <= kNumWorlds){
        normalImage = [NSString stringWithFormat:@"World%iLevel%i.png", worldNumber, 1];
        normalSprite = [CCSprite spriteWithFile:normalImage];
        selectedSprite = [CCSprite spriteWithFile:normalImage];
        selectedSprite.color = ccc3(200, 200, 220);
        CCLayer *itemLayer = [[CCLayer alloc] init];
        if(worldNumber <= [theProgressData firstUncompletedWorld]){
            CCMenuItem *item = [CCMenuItemSprite itemFromNormalSprite:normalSprite selectedSprite:selectedSprite target:self selector:@selector(launchWorld:)];
            item.tag = worldNumber;
            item.scale = (winHeight / item.contentSize.height) * .7;
            CCMenu *menu = [CCMenu menuWithItems: item, nil];
            [menu alignItemsVertically];
            [itemLayer addChild:menu z:10];
        }else{
            selectedSprite.opacity = 100;
            selectedSprite.scale = (winHeight / selectedSprite.contentSize.height) * .7;
            selectedSprite.position = ccp(winWidth/2, winHeight/2);
            [itemLayer addChild:selectedSprite z:10];
        }
        
        ccColor4B color = worldColors[worldNumber - 1];
        
        CCLayerColor *colorLayer = [[CCLayerColor alloc] initWithColor:color width:winWidth height:winHeight];
        [itemLayer addChild:colorLayer z: 0];
        [colorLayer release];
        
        NSString *worldString = NSLocalizedString(@"WORLD", nil);
        worldString = [NSString stringWithFormat:@"%@ %i", worldString, worldNumber];
        CCLabelTTF *layerLabel = [CCLabelTTF labelWithString:worldString fontName:@"Marker Felt" fontSize:32];
        layerLabel.position =  ccp( winWidth / 2 , winHeight / 2);
        layerLabel.color = ccc3(255, 255, 255);
        [itemLayer addChild:layerLabel z:15];
        
        [allLayers addObject:itemLayer];
        [itemLayer release];
        worldNumber++;
    }
    CCScrollLayer *scrollLayer = [CCScrollLayer nodeWithLayers:allLayers widthOffset:0];
    [scrollLayer moveToPage:[theProgressData firstUncompletedWorld] - 1];
    
    parentNode = scrollLayer;
    [self addChild: scrollLayer];
    
    [allLayers release];
    
    [self addBackButton];
}
-(void)levelSetup:(int)worldNumber{
    isOnLevelSelect = YES;
    if(parentNode){
        [self removeChild:parentNode cleanup:YES];
    }
    NSMutableArray* allLayers = [[NSMutableArray alloc] init];
    
    PlayerData *playerOneData;
    PlayerData *playerTwoData = nil;
    if(numPlayers == 1){
        playerOneData = [GamePreferences sharedInstance].onePlayerData;
    }else{
        playerOneData = [GamePreferences sharedInstance].twoPlayerPlayerOneData;
        playerTwoData = [GamePreferences sharedInstance].twoPlayerPlayerTwoData;
    }
    
    // create a menu item for each character
    double winWidth = [[CCDirector sharedDirector] winSize].width;
    double winHeight = [[CCDirector sharedDirector] winSize].height;
    int levelNumber = 1;
    NSString* normalImage;
    CCSprite* normalSprite;
    CCSprite* selectedSprite;
    while(levelNumber <= kNumLevels){
        normalImage = [NSString stringWithFormat:@"World%iLevel%i.png", worldNumber, levelNumber];
        normalSprite = [CCSprite spriteWithFile:normalImage];
        selectedSprite = [CCSprite spriteWithFile:normalImage];
        selectedSprite.color = ccc3(200, 200, 220);
        CCLayer *itemLayer = [[CCLayer alloc] init];
        if(levelNumber <= [playerOneData firstUncompletedLevelFromWorld:worldNumber]){
            CCMenuItem* item = [CCMenuItemSprite itemFromNormalSprite:normalSprite selectedSprite:selectedSprite target:self selector:@selector(launchLevel:)];
            item.tag = levelNumber;
            item.scale = (winHeight / item.contentSize.height) * .7;
            CCMenu *menu = [CCMenu menuWithItems: item, nil];
            [menu alignItemsVertically];
            [itemLayer addChild:menu];
            
            HealthBar *barOne = [[HealthBar alloc] initForShowWithLives:[playerOneData loadLivesWorld:worldNumber level:levelNumber] health:[playerOneData loadHealthWorld:worldNumber level:levelNumber]];
            barOne.position = ccp(winWidth/8, 2 * (winHeight/3));
            if(UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad){
                barOne.scale = .75;
            }
            [itemLayer addChild:barOne];
            [barOne release];
            if(numPlayers == 2){
                HealthBar *barTwo = [[HealthBar alloc] initForShowWithLives:[playerTwoData loadLivesWorld:worldNumber level:levelNumber] health:[playerTwoData loadHealthWorld:worldNumber level:levelNumber]];
                barTwo.rotation = 180;
                double xPosition = (((double)winWidth)/8);
                xPosition = xPosition * 7;
                double yPosition = (((double)winHeight)/3);
                barTwo.position = ccp(xPosition, yPosition);
                if(UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad){
                    barTwo.scale = .75;
                }
                [itemLayer addChild:barTwo];
                [barTwo release];
            }
        }else{
            selectedSprite.opacity = 100;
            selectedSprite.scale = (winHeight / selectedSprite.contentSize.height) * .7;
            selectedSprite.position = ccp(winWidth/2, winHeight/2);
            [itemLayer addChild:selectedSprite];
        }
        NSString *levelString = NSLocalizedString(@"LEVEL", nil);
        levelString = [NSString stringWithFormat:@"%@ %i", levelString, levelNumber];
        CCLabelTTF *layerLabel = [CCLabelTTF labelWithString:levelString fontName:@"Marker Felt" fontSize:32];
        layerLabel.position =  ccp( winWidth / 2 , winHeight / 2);
        layerLabel.color = ccc3(255, 255, 255);
        [itemLayer addChild:layerLabel z:15];
        
        
        [allLayers addObject:itemLayer];
        [itemLayer release];
        levelNumber++;
    }
    CCScrollLayer *scrollLayer = [CCScrollLayer nodeWithLayers:allLayers widthOffset:0];
    [scrollLayer moveToPage:[playerOneData firstUncompletedLevelFromWorld:worldNumber] - 1];
    
    ccColor4B color = worldColors[worldNumber - 1];
    
    CCLayerColor *colorLayer = [[CCLayerColor alloc] initWithColor:color width:winWidth height:winHeight];
    [colorLayer addChild:scrollLayer];
    
    parentNode = colorLayer;
    [self addChild: colorLayer];
    [colorLayer release];
    
    [allLayers release];
    
    [self addBackButton];
}
-(void)launchWorld:(CCMenuItem *)sender{
    [[SimpleAudioEngine sharedEngine] playEffect:@"MenuSoundEffect.m4v"];
    int worldNumber = sender.tag;
    currentWorldNumber = worldNumber;
    [self levelSetup:worldNumber];
}
-(void)launchLevel:(CCMenuItem *)sender{
    [[SimpleAudioEngine sharedEngine] playEffect:@"MenuSoundEffect.m4v"];
    int levelNumber = sender.tag;
    [[CCDirector sharedDirector] replaceScene:[[[GameplayScene alloc] initWithNumberOfPlayers:numPlayers worldNumber:currentWorldNumber levelNumber:levelNumber] autorelease]];
}
-(void)addBackButton{
    CCSprite *backSprite = [CCSprite spriteWithFile:@"BackArrow.png"];
    CCSprite *selectedSprite = [CCSprite spriteWithFile:@"BackArrowSelected.png"];
    CCSprite *disabledSprite = [CCSprite spriteWithFile:@"BackArrowSelected.png"];
    CCMenuItem *backButton = [[[CCMenuItemSprite alloc] initFromNormalSprite:backSprite selectedSprite:selectedSprite disabledSprite:disabledSprite target:self selector:@selector(back)] autorelease];
    backButton.anchorPoint = ccp(0, 0);
    backButton.position = ccp(0, 0);
    
    if(backButtonMenu){
        [self removeChild:backButtonMenu cleanup:YES];
    }
    backButtonMenu = [CCMenu menuWithItems:backButton, nil];
    backButtonMenu.position = ccp(0, 0);
    [self addChild:backButtonMenu];
    
}
-(void)back{
    if(isOnLevelSelect){
        [self worldSetup];
    }else{
        [[CCDirector sharedDirector] replaceScene:[[[MainMenuScene alloc] init] autorelease]];
    }
}
@end
