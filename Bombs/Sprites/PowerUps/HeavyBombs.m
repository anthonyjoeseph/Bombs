//
//  HeavyBombs.m
//  Detonate
//
//  Created by AnthonyGabriele on 1/21/13.
//
//

#import "HeavyBombs.h"

@implementation HeavyBombs
-(void)engage{
    [self.affectedPlayer.bombPool heavyBombs];
}
-(void)disengage{
    [self.affectedPlayer.bombPool restoreDefaults];
}
-(NSString *)toString{
    return @"HeavyBombs";
}

@end
