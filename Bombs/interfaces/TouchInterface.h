//
//  TouchInterface.h
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "InterfaceLayer.h"
#import "Constants.h"


@interface TouchInterface : InterfaceLayer {
    GameDirection joyDirection;
    bool isMoving;
}
-(id)init;

@end
