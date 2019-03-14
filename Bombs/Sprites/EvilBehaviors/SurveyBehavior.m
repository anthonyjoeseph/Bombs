//
//  SurveyBehavior.m
//  Detonate
//
//  Created by Anthony Gabriele on 1/9/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SurveyBehavior.h"

@implementation SurveyBehavior
-(id)initWithBadGuy:(GameObject *)badGuy{
    if((self = [super initWithBadGuy:badGuy])){
        timeUntilTurn = kDefaultProjectileReloadTime;
    }
    return self;
}
-(void)update:(ccTime)dt listOfBlocks:(NSArray *)blockList{
    timeUntilTurn -= dt;
    if(timeUntilTurn <= 0){
        timeUntilTurn = kDefaultProjectileReloadTime;
        switch (self.badGuy.direction) {
            case kRight:
                self.badGuy.direction = kDown;
                break;
            case kDown:
                self.badGuy.direction = kLeft;
                break;
            case kLeft:
                self.badGuy.direction = kUp;
                break;
            case kUp:
                self.badGuy.direction = kRight;
                break;
        }
    }
}
@end
