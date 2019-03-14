//
//  EvilBehavior.h
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MovingObject.h"
#import "Player.h"

@interface EvilBehavior : NSObject {
    GameObject *_badGuy;
    Player *playerOne;
    Player *playerTwo;
}
-(id)initWithBadGuy:(GameObject *)badGuy;
-(void)update:(ccTime)dt listOfBlocks:(NSArray *)blockList;
-(void)hasReachedTileAndIsMovingTo:(CGPoint)wantedTilePoint listOfBlocks:(NSArray *)listOfBlocks;
-(void)collisionWithSprite:(GameObject *)collider;
-(void)die;
-(void)registerPlayerOne:(Player *)playerOne playerTwo:(Player *)playerTwo;

@property (nonatomic, assign) GameObject *badGuy;
@end
