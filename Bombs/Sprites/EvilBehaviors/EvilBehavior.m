//
//  EvilBehavior.m
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EvilBehavior.h"

@implementation EvilBehavior
@synthesize badGuy = _badGuy;

-(id)initWithBadGuy:(GameObject *)badGuy{
    if((self = [super init])){
        self.badGuy = badGuy;
    }
    return self;
}
-(void)update:(ccTime)dt listOfBlocks:(NSArray *)blockList{}
-(void)hasReachedTileAndIsMovingTo:(CGPoint)wantedTilePoint listOfBlocks:(NSArray *)listOfBlocks{}
-(void)collisionWithSprite:(GameObject *)collider{}
-(void)die{}
-(void)registerPlayerOne:(Player *)_playerOne playerTwo:(Player *)_playerTwo{
    playerOne = _playerOne;
    playerTwo = _playerTwo;
}
@end
