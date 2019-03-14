//
//  MainMenuScene.h
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameplayScene.h"
#import "RootViewController.h"


@interface MainMenuScene : CCScene{
    bool wasClicked;
    double winWidth;
    double winHeight;
    CCSprite *movingBadGuy;
    bool badGuyMovingUp;
    CCMenu *openingMenu;
    CCMenu *preferencesMenu;
}

@end
