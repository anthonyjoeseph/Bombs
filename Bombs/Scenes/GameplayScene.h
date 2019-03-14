//
//  GameplayScene.h
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "LevelChanger.h"
#import "Level.h"
#import "Player.h"
#import "HealthBar.h"
#import "CameraDelegate.h"
#import "GameEnder.h"
#import "InterfaceLayer.h"
#import "PowerUpHUDHolder.h"

@interface GameplayScene : CCScene <LevelChanger, CameraDelegate, CCStandardTouchDelegate, GameEnder, PowerUpHUDHolder>{
    Level *theLevel;
    CCLayer *frontPanel;
    HealthBar *barOne;
    HealthBar *barTwo;
    InterfaceLayer *playerOneInterface;
    InterfaceLayer *playerTwoInterface;
    //CGRect viewingRectangle;
    CCSprite *powerUpHUD;
    int numPlayers;
    int worldNumber;
    int levelNumber;
    double middleOfColumn;
}
-(id)initWithNumberOfPlayers:(int)numberPlayers worldNumber:(int)worldNum levelNumber:(int)levelNum;
-(void)loadLevel;
-(void)linkLevelAndInterface;
-(void)placePowerUpOnHUD:(NSString *)powerUp playerNumber:(int)playerNum;

-(void)saveData;
-(void)levelIsOver;
-(void)shiftWorldtoFocalPoint:(CGPoint)focalPoint;
-(void)gameOver;
/*- (void) layerPanZoom: (CCLayerPanZoom *) sender clickedAtPoint: (CGPoint) aPoint tapCount: (NSUInteger) tapCount;
- (void) layerPanZoom: (CCLayerPanZoom *) sender touchPositionUpdated: (CGPoint) newPos;
- (void) layerPanZoom: (CCLayerPanZoom *) sender touchMoveBeganAtPosition: (CGPoint) aPoint;*/

@end
