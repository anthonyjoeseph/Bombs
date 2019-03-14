//
//  LightBombs.m
//  Detonate
//
//  Created by AnthonyGabriele on 1/21/13.
//
//

#import "LightBombs.h"

@implementation LightBombs
-(void)engage{
    [self.affectedPlayer.bombPool lightBombs];
}
-(void)disengage{
    [self.affectedPlayer.bombPool restoreDefaults];
}
-(NSString *)toString{
    return @"LightBombs";
}

@end
