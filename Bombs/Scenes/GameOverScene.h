//
//  GameOverScene.h
//  Detonate
//
//  Created by Anthony Gabriele on 1/12/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "CCScene.h"

@interface GameOverScene : CCScene{
    int numPlayers;
    int currentWorldNumber;
    int currentLevelNumber;
    bool wasClicked;
}
-(id)initWithNumPlayers:(int)numPlayer world:(int)_worldNumber level:(int)_levelNumber;

@end
