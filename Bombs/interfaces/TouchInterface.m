//
//  TouchInterface.m
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TouchInterface.h"
#import "Player.h"


@implementation TouchInterface

-(id)init{
	if((self = [super init])){
		self.isTouchEnabled = YES;
	}
	return self;
}
-(void)setControlPlayer:(Player *)controlPlayer{
    _controlPlayer = controlPlayer;
}
-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self ccTouchesMoved:touches withEvent:event];
}
-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint touchPosition = [touch locationInView: [touch view]];		
    touchPosition = [[CCDirector sharedDirector] convertToGL: touchPosition];
    touchPosition = [self.contextNode convertToNodeSpace:touchPosition];
    double deltaX = touchPosition.x - self.controlPlayer.position.x;
    double deltaY = touchPosition.y - self.controlPlayer.position.y;
    double absDeltaX = abs(deltaX);
    double absDeltaY = abs(deltaY);
    if(absDeltaX < 50 && absDeltaY < 50){
        [self.controlPlayer spawnBomb];
    }else{
		if(deltaX > 0 && absDeltaX > absDeltaY){
			joyDirection = kRight;
		}else if(deltaX < 0 && absDeltaX > absDeltaY){
			joyDirection = kLeft;
		}else if(deltaY > 0 && absDeltaY > absDeltaX){
			joyDirection = kUp;
		}else if(deltaY < 0 && absDeltaY > absDeltaX){
			joyDirection = kDown;
		}
        self.controlPlayer.direction = joyDirection;
		[self.controlPlayer startMoving];
    }
}
-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.controlPlayer stopMoving];
}
@end
