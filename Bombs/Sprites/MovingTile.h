//
//  MovingTile.h
//  Detonate
//
//  Created by Anthony Gabriele on 8/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BadGuy.h"
#import "HasProperties.h"
#import "Collidable.h"

@interface MovingTile : GameObject <HasProperties, Collidable> {
    NSMutableArray *collidingGameObjects;
}
-(void)addProperties:(NSDictionary *)properties;
-(void)collisionWithSprite:(GameObject *)otherObject;

@end
