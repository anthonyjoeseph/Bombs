//
//  ExtraPower.m
//  Detonate
//
//  Created by AnthonyGabriele on 1/21/13.
//
//

#import "ExtraPower.h"

@implementation ExtraPower
@synthesize affectedPlayer;

-(void)engage{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)] userInfo:nil];
}
-(void)disengage{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)] userInfo:nil];
}
-(NSString *)toString{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)] userInfo:nil];
}
-(void)dealloc{
    [super dealloc];
}
@end
