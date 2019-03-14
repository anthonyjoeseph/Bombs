//
//  Faster.m
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Faster.h"
#import "Player.h"


@implementation Faster
-(void)engage{
    self.affectedPlayer.tileMovementTime = kDefaultPlayerMovementSpeed / 2;
}
-(void)disengage{
    self.affectedPlayer.tileMovementTime = kDefaultPlayerMovementSpeed;
}
-(NSString *)toString{
    return @"Faster";
}
@end
