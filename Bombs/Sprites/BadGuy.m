//
//  BadGuy.m
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BadGuy.h"
#import "Player.h"

@implementation BadGuy
@synthesize moveBehavior = _moveBehavior;
@synthesize shootBehavior = _shootBehavior;

-(void)update:(ccTime)dt listOfBlocks:(NSArray *)blockList{
    [self.shootBehavior update:dt listOfBlocks:blockList];
    [self.moveBehavior update:dt listOfBlocks:blockList];
    [super update:dt listOfBlocks:blockList];
}
-(void)hasReachedTileAndIsMovingTo:(CGPoint)newTilePoint listOfBlocks:(NSArray *)listOfBlocks{
    [super hasReachedTileAndIsMovingTo:newTilePoint listOfBlocks:listOfBlocks];
    [self.moveBehavior hasReachedTileAndIsMovingTo:newTilePoint listOfBlocks:(NSArray *)listOfBlocks];
}
-(void)collisionWithSprite:(GameObject *)otherObject{
    [self.shootBehavior collisionWithSprite:otherObject];
    [self.moveBehavior collisionWithSprite:otherObject];
}
-(void)die{
    [self.moveBehavior die];
}
-(void)registerPlayerOne:(Player *)playerOne playerTwo:(Player *)playerTwo{
    [self.moveBehavior registerPlayerOne:playerOne playerTwo:playerTwo];
    [self.shootBehavior registerPlayerOne:playerOne playerTwo:playerTwo];
}
-(void)dealloc{
    [super dealloc];
}
@end
