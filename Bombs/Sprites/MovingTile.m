//
//  MovingTile.m
//  Detonate
//
//  Created by Anthony Gabriele on 8/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovingTile.h"

@implementation MovingTile
-(id)initWithBatchNode:(CCSpriteBatchNode *)batchNode{
    if((self = [super initWithBatchNode:batchNode])){
        collidingGameObjects = [[NSMutableArray alloc] init];
        self.currentAnimation = [self loadAnimation:@"MovingTile" frameCount:2 frameDuration:.7];
        [self animate];
    }
    return self;
}
-(void)addProperties:(NSDictionary *)properties{
    NSString *directionString = [properties valueForKey:@"Direction"];
    if([directionString isEqualToString:@"kRight"]){
        self.direction = kRight;
    }
    if([directionString isEqualToString:@"kDown"]){
        self.direction = kDown;
    }
    if([directionString isEqualToString:@"kLeft"]){
        self.direction = kLeft;
    }
    if([directionString isEqualToString:@"kUp"]){
        self.direction = kUp;
    }
}
-(void)collisionWithSprite:(GameObject *)otherObject{
    if([otherObject isKindOfClass:[MovingObject class]]){
        MovingObject *movingOtherObject = (MovingObject *)otherObject;
        [movingOtherObject suggestDirection: self.direction];
        switch (self.direction) {
            case kRight:
                if(movingOtherObject.direction == kLeft){
                    movingOtherObject.direction = kRight;
                }
                break;
            case kDown:
                if(movingOtherObject.direction == kUp){
                    movingOtherObject.direction = kDown;
                }
                break;
            case kLeft:
                if(movingOtherObject.direction == kRight){
                    movingOtherObject.direction = kLeft;
                }
                break;
            case kUp:
                if(movingOtherObject.direction == kDown){
                    movingOtherObject.direction = kUp;
                }
                break;
        }
    }
}
-(int)drawOrder{
    return -10;
}
-(void)dealloc{
    [collidingGameObjects release];
    [super dealloc];
}
@end
