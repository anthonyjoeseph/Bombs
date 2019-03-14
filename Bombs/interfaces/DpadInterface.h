//
//  DpadInterface.h
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "InterfaceLayer.h"
#import "Constants.h"
#import "SneakyJoystick.h"
#import "SneakyButton.h"

@interface DpadInterface : InterfaceLayer {
    SneakyJoystick *theJoysick;
    SneakyButton *theButton;
    GameDirection joyDirection;
    float timeSinceBomb;
    bool isMoving;
}
-(id)initIsUpsideDown:(bool)upsideDown isLarge:(bool)isLarge;
-(void)update:(ccTime)dt;
@end
