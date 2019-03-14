//
//  TapBombs.m
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TapBombs.h"


@implementation TapBombs
-(void)engage{
    self.affectedPlayer.bombPool = [[[BombPool alloc] initWithGameObjectType:@"TapBomb" poolRegistrar:self.affectedPlayer.poolRegistrar capacity:15] autorelease];
}
-(void)disengage{
    self.affectedPlayer.bombPool = [[[BombPool alloc] initWithGameObjectType:@"TimeBomb" poolRegistrar:self.affectedPlayer.poolRegistrar capacity:15] autorelease];
}
-(NSString *)toString{
    return @"TapBombs";
}

@end
