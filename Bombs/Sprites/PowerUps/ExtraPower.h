//
//  ExtraPower.h
//  Detonate
//
//  Created by AnthonyGabriele on 1/21/13.
//
//

#import <Foundation/Foundation.h>
#import "Player.h"

@interface ExtraPower : NSObject{
    
}
-(void)engage;
-(void)disengage;
-(NSString *)toString;

@property (nonatomic, assign) Player *affectedPlayer;
@end
