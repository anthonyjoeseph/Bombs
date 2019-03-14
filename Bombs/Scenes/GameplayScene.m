//
//  GameplayScene.m
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameplayScene.h"
#import "GamePreferences.h"
#import "DpadInterface.h"
#import "TouchInterface.h"
#import "SimpleAudioEngine.h"
#import "PauseButton.h"
#import "BetweenLevelScene.h"
#import "GameOverScene.h"
#import "CCDirector.h"
#import "CreditsScene.h"
@class MainMenuScene;


@implementation GameplayScene

-(id)initWithNumberOfPlayers:(int)numberPlayers worldNumber:(int)worldNum levelNumber:(int)levelNum{
	if((self=[super init])) {
        [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
        
        numPlayers = 1;
        if(numberPlayers > 1){
            numPlayers = 2;
        }
        worldNumber = worldNum;
        levelNumber = levelNum;
        
        [self loadLevel];
        
        frontPanel = [[CCLayer alloc] init];
        
        //HUD
        
        double winHeight = [[CCDirector sharedDirector] winSize].height;
        
        middleOfColumn = theLevel.position.x / 2;
        
        CCSprite *background = [CCSprite spriteWithFile:@"Background.png"];
        background.anchorPoint = ccp(0, 0);
        background.position = ccp(0, 0);
        double backgroundWidth = theLevel.position.x;
        double backgroundHeight = winHeight;
        background.scaleX = backgroundWidth / background.contentSize.width;
        background.scaleY = backgroundHeight / background.contentSize.height;
        [frontPanel addChild:background z:1];
        
        PlayerData *playerOneData;
        PlayerData *playerTwoData = nil;
        if(numPlayers == 1){
            playerOneData = [GamePreferences sharedInstance].onePlayerData;
        }else{
            playerOneData = [GamePreferences sharedInstance].twoPlayerPlayerOneData;
            playerTwoData = [GamePreferences sharedInstance].twoPlayerPlayerTwoData;
        }
        
        //add the interface
        if([GamePreferences sharedInstance].playerOneInterfaceType == kDPadInterface){
            playerOneInterface = [[DpadInterface alloc] initIsUpsideDown:NO isLarge:NO];
        }else if([GamePreferences sharedInstance].playerOneInterfaceType == kLargeDPadInterface){
            playerOneInterface = [[DpadInterface alloc] initIsUpsideDown:NO isLarge:YES];
        }else{
            playerOneInterface = [[TouchInterface alloc] init];
        }
        [frontPanel addChild:playerOneInterface z:3];
        barOne = [[HealthBar alloc] initWithGameEnder:self lives:[playerOneData loadLivesWorld:worldNumber level:levelNumber] health:[playerOneData loadHealthWorld:worldNumber level:levelNumber]];
        barOne.position = ccp(middleOfColumn, 2 * (winHeight/3));
        if(UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad){
            barOne.scale = .5;
        }
        [frontPanel addChild:barOne z:3];
        
        if(numPlayers == 2){
            if([GamePreferences sharedInstance].playerTwoInterfaceType == kDPadInterface){
                playerTwoInterface = [[DpadInterface alloc] initIsUpsideDown:YES isLarge:NO];
            }else if([GamePreferences sharedInstance].playerTwoInterfaceType == kLargeDPadInterface){
                playerTwoInterface = [[DpadInterface alloc] initIsUpsideDown:YES isLarge:YES];
            }else{
                playerTwoInterface = [[TouchInterface alloc] init];
            }
            [frontPanel addChild:playerTwoInterface z:3];
            barTwo = [[HealthBar alloc] initWithGameEnder:self lives:[playerTwoData loadLivesWorld:worldNumber level:levelNumber] health:[playerTwoData loadHealthWorld:worldNumber level:levelNumber]];
            barTwo.position = ccp(([[CCDirector sharedDirector] winSize].width - middleOfColumn), (winHeight/3));
            barTwo.rotation = 180;
            [frontPanel addChild:barTwo z: 3];
        }
        
        CCMenuItem *pauseButton = [[PauseButton alloc] initWithContext:self world:worldNum level:levelNum numPlayers:numPlayers];
        pauseButton.position = ccp(0,0);
        CCMenu *pauseMenu = [CCMenu menuWithItems:[pauseButton autorelease], nil];
        pauseMenu.anchorPoint = ccp(0.5, 0.5);
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            pauseMenu.position = ccp(middleOfColumn, (winHeight/4));
        }else{
            pauseMenu.position = ccp(middleOfColumn, winHeight - (pauseButton.contentSize.height / 2));
        }
        [frontPanel addChild:pauseMenu z: 2];
        
        [self linkLevelAndInterface];
        
        [self addChild: frontPanel z: 2];
        [frontPanel release];
        
        [[CCTouchDispatcher sharedDispatcher] addStandardDelegate:self priority:0];
        
        NSString *musicName = [NSString stringWithFormat:@"World%i.m4a", worldNum];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:musicName loop:YES];
        
	}
	return self;
}

-(void)loadLevel{
    if(theLevel){
        [self removeChild:theLevel cleanup:YES];
        [theLevel release];
    }
    NSString *nextLevelName = [NSString stringWithFormat:@"World%iLevel%i.tmx", worldNumber, levelNumber];
    theLevel = [[Level alloc] initWithTMXFile:nextLevelName withDelegate:self numPlayers:numPlayers];
    
    double winWidth = [[CCDirector sharedDirector] winSize].width;
    double winHeight = [[CCDirector sharedDirector] winSize].height;
    double nodeWidth = [theLevel mapWidth];
    double nodeHeight = [theLevel mapHeight];
    float scale = (winHeight/nodeHeight);
    
    theLevel.scale = 1.0;
    theLevel.anchorPoint = ccp(0, 0);
    double emptySpaceX = winWidth - (nodeWidth * scale);
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        theLevel.position = ccp((emptySpaceX / 2), 0);
    }else{
        theLevel.position = ccp(emptySpaceX, winHeight - (nodeHeight * theLevel.scale));
    }
    
    [self addChild: theLevel z:1];
    
    CCLayer *bgLayer = [[CCLayerColor alloc] initWithColor:[theLevel backgroundColor] width:nodeWidth height:nodeHeight];
    bgLayer.anchorPoint = ccp(0, 0);
    bgLayer.position = ccp(0, 0);
    [theLevel addChild:bgLayer z:-1];
    [bgLayer release];
    
    if(barOne){
        if(numPlayers == 1){
            [barOne setLives:[[GamePreferences sharedInstance].onePlayerData loadLivesWorld:worldNumber level:levelNumber] health:[[GamePreferences sharedInstance].onePlayerData loadHealthWorld:worldNumber level:levelNumber]];
        }else{
            [barOne setLives:[[GamePreferences sharedInstance].twoPlayerPlayerOneData loadLivesWorld:worldNumber level:levelNumber] health:[[GamePreferences sharedInstance].twoPlayerPlayerOneData loadHealthWorld:worldNumber level:levelNumber]];
            [barTwo setLives:[[GamePreferences sharedInstance].twoPlayerPlayerTwoData loadLivesWorld:worldNumber level:levelNumber] health:[[GamePreferences sharedInstance].twoPlayerPlayerTwoData loadHealthWorld:worldNumber level:levelNumber]];
        }
    }
    [[theLevel getPlayer:1] addPowerUpHUDHolder:self];
    if(numPlayers == 2){
        [[theLevel getPlayer:2] addPowerUpHUDHolder:self];
    }
}
-(void)linkLevelAndInterface{
    playerOneInterface.controlPlayer = [theLevel getPlayer:1];
    playerOneInterface.contextNode = theLevel;
    [theLevel getPlayer:1].healthBar = barOne;
    if(numPlayers == 2){
        playerTwoInterface.controlPlayer = [theLevel getPlayer:2];
        playerTwoInterface.contextNode = theLevel;
        [theLevel getPlayer:2].healthBar = barTwo;
    }
    //if it's a phone
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        [theLevel getPlayer:1].cameraDelegate = self;
    }
}
-(void)placePowerUpOnHUD:(NSString *)powerUp playerNumber:(int)playerNum{
    if(powerUpHUD){
        [frontPanel removeChild:powerUpHUD cleanup:YES];
    }
    NSString *fileName = [NSString stringWithFormat:@"%@.png", powerUp];
    powerUpHUD = [[CCSprite alloc] initWithFile:fileName];
    
    double winWidth = [[CCDirector sharedDirector] winSize].width;
    double winHeight = [[CCDirector sharedDirector] winSize].height;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        if(playerNum == 1){
            powerUpHUD.position = ccp(middleOfColumn, (winHeight/3)-20);
        }else{
            powerUpHUD.flipY = YES;
            powerUpHUD.position = ccp(winWidth - middleOfColumn, winHeight - ((winHeight/3)-20));
        }
    }else{
        powerUpHUD.position = ccp(middleOfColumn + 15, (winHeight/2)+15);
    }
    [frontPanel addChild:powerUpHUD z:5];
    [powerUpHUD release];
}
-(void)removePowerUpFromHUD{
    if(powerUpHUD){
        [frontPanel removeChild:powerUpHUD cleanup:YES];
    }
}

-(void)saveData{
    PlayerData *playerOneData;
    PlayerData *playerTwoData = nil;
    if(numPlayers == 1){
        playerOneData = [GamePreferences sharedInstance].onePlayerData;
    }else{
        playerOneData = [GamePreferences sharedInstance].twoPlayerPlayerOneData;
        playerTwoData = [GamePreferences sharedInstance].twoPlayerPlayerTwoData;
    }
    if(numPlayers == 1){
        int numLivesAtStart = 3;
        double healthAtStart = 100.0;
        if(levelNumber > 1){
            numLivesAtStart = [playerOneData loadLivesWorld:worldNumber level:levelNumber];
            healthAtStart = [playerOneData loadHealthWorld:worldNumber level:levelNumber];
        }
        int numLivesAtEnd = [barOne lives];
        double healthAtEnd = [barOne health];
        double totalDamage;
        totalDamage = (numLivesAtStart - numLivesAtEnd) * 100;
        totalDamage += (healthAtStart - healthAtEnd);
        [playerOneData damageTaken:totalDamage atWorld:worldNumber level:levelNumber];
    }else{
        int playerOneNumLivesAtStart = 3;
        double playerOneHealthAtStart = 100.0;
        int playerTwoNumLivesAtStart = 3;
        double playerTwoHealthAtStart = 100.0;
        if(levelNumber > 1){
            playerOneNumLivesAtStart = [playerOneData loadLivesWorld:worldNumber level:levelNumber];
            playerOneHealthAtStart = [playerOneData loadHealthWorld:worldNumber level:levelNumber];
            playerTwoNumLivesAtStart = [playerOneData loadLivesWorld:worldNumber level:levelNumber];
            playerTwoHealthAtStart = [playerOneData loadHealthWorld:worldNumber level:levelNumber];
        }
        int playerOneNumLivesAtEnd = [barOne lives];
        double playerOneHealthAtEnd = [barOne health];
        double playerOneTotalDamage;
        playerOneTotalDamage = (playerOneNumLivesAtStart - playerOneNumLivesAtEnd) * 100;
        playerOneTotalDamage += (playerOneHealthAtStart - playerOneHealthAtEnd);
        
        int playerTwoNumLivesAtEnd = [barTwo lives];
        double playerTwoHealthAtEnd = [barTwo health];
        double playerTwoTotalDamage;
        playerTwoTotalDamage = (playerTwoNumLivesAtStart - playerTwoNumLivesAtEnd) * 100;
        playerTwoTotalDamage += (playerTwoHealthAtStart - playerTwoHealthAtEnd);
        
        [playerOneData damageTaken:playerOneTotalDamage atWorld:worldNumber level:levelNumber];
        [playerTwoData damageTaken:playerTwoTotalDamage atWorld:worldNumber level:levelNumber];
    }
    [[GamePreferences sharedInstance] savePlayerProgress];
}
-(void)levelIsOver{
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    [[SimpleAudioEngine sharedEngine] playEffect:@"Win.mp3"];
    [self saveData];
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:kTimeLevelLastsAfterOver], [CCCallFunc actionWithTarget:self selector:@selector(levelReallyIsOver)], nil]];
}
-(void)levelReallyIsOver{
    [self saveData];
    if(!(worldNumber == 5 && levelNumber == 10)){
        [[CCDirector sharedDirector] replaceScene:[[[BetweenLevelScene alloc] initWithNumPlayers:numPlayers world:worldNumber level:levelNumber] autorelease]];
    }else{
        [[CCDirector sharedDirector] replaceScene:[[[CreditsScene alloc] init] autorelease]];
    }
}
-(void)gameOver{
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    [[SimpleAudioEngine sharedEngine] playEffect:@"GameOver.mp3"];
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:kTimeLevelLastsAfterOver], [CCCallFunc actionWithTarget:self selector:@selector(gameReallyIsOver)], nil]];
}
-(void)gameReallyIsOver{
    [self removeChild:theLevel cleanup:YES];
    [[CCDirector sharedDirector] replaceScene: [[[GameOverScene alloc] initWithNumPlayers:numPlayers world:worldNumber level:levelNumber] autorelease]];
}
//focalPoint is already converted into node space
-(void)shiftWorldtoFocalPoint:(CGPoint)focalPoint{
    double winWidth = [[CCDirector sharedDirector] winSize].width;
    double winHeight = [[CCDirector sharedDirector] winSize].height;
    double nodeWidth = ([theLevel mapWidth] * theLevel.scale);
    double nodeHeight = ([theLevel mapHeight] * theLevel.scale);
    double scale = (winHeight / nodeHeight);
    
    //double distanceFromMiddleX = [theLevel convertToWorldSpace: focalPoint].x - (winWidth - ((nodeWidth * scale) / 2));
    double distanceFromMiddleX = [theLevel convertToWorldSpace: focalPoint].x - (winWidth / 2);
    double distanceFromMiddleY = [theLevel convertToWorldSpace: focalPoint].y - (winHeight / 2);
    
    double newX = theLevel.position.x - distanceFromMiddleX;
    double newY = theLevel.position.y - distanceFromMiddleY;
    double leftEdge = newX;
    double rightEdge = newX + nodeWidth;
    if(rightEdge < winWidth){
        rightEdge = winWidth;
        newX = rightEdge - nodeWidth;
    }else if(leftEdge > (winWidth - (nodeWidth * scale))){
        leftEdge = (winWidth - (nodeWidth * scale));
        newX = leftEdge;
    }
    double bottomEdge = newY;
    double topEdge = newY + nodeHeight;
    if(topEdge < winHeight){
        topEdge = winHeight;
        newY = topEdge - nodeHeight;
    }else if(bottomEdge > 0){
        bottomEdge = 0;
        newY = bottomEdge;
    }
    theLevel.position = ccp(newX, newY);
}
- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{}
- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    BOOL multitouch = [touches count] > 1;
	if (multitouch){
		// Get the two first touches
        UITouch *touch1 = [[touches allObjects] objectAtIndex: 0];
		UITouch *touch2 = [[touches allObjects] objectAtIndex: 1];
        
		// Get current and previous positions of the touches
		CGPoint curPosTouch1 = [[CCDirector sharedDirector] convertToGL: [touch1 locationInView: [touch1 view]]];
		CGPoint curPosTouch2 = [[CCDirector sharedDirector] convertToGL: [touch2 locationInView: [touch2 view]]];
		CGPoint prevPosTouch1 = [[CCDirector sharedDirector] convertToGL: [touch1 previousLocationInView: [touch1 view]]];
		CGPoint prevPosTouch2 = [[CCDirector sharedDirector] convertToGL: [touch2 previousLocationInView: [touch2 view]]];
        
		// Calculate new scale
        double winHeight = [[CCDirector sharedDirector] winSize].height;
        double nodeHeight = [theLevel mapHeight];
        double scale = (winHeight / nodeHeight);
        
        CGFloat newScale = theLevel.scale * ccpDistance(curPosTouch1, curPosTouch2) / ccpDistance(prevPosTouch1, prevPosTouch2);
        if(scale <= newScale && newScale <= 1.0){
            theLevel.scale = theLevel.scale * ccpDistance(curPosTouch1, curPosTouch2) / ccpDistance(prevPosTouch1, prevPosTouch2);
            [self shiftWorldtoFocalPoint:[theLevel getPlayer:1].position];
        }
    }
}
-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{}
-(void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{}

- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (theLevel)
    [theLevel release];
    [playerOneInterface release];
    [barOne release];
    if(numPlayers == 2){
        [playerTwoInterface release];
        [barTwo release];
    }
	[super dealloc];
}
@end
