//
//  Shield.m
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Shield.h"
#import "Player.h"


@implementation Shield
-(void)engage{
    [self.affectedPlayer shield];
}
-(void)disengage{
    [self.affectedPlayer takeAwayShield];
}
-(NSString *)toString{
    return @"Shield";
}

@end
