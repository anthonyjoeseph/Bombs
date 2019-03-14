//
//  PauseButton.h
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@interface PauseButton : CCMenuItemImage {
    CCScene *context;
    int worldNum;
    int levelNum;
    int numPlayers;
	bool _pauseScreenUp;
	CCLayer *pauseLayer;
	CCSprite *_pauseScreen;
	CCMenu *_pauseScreenMenu;
}
-(id)initWithContext:(CCScene *)context world:(int)worldNum level:(int)levelNum numPlayers:(int)numPlayers;

@end
