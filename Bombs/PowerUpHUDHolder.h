//
//  PowerUpHUDHolder.h
//  Detonate
//
//  Created by AnthonyGabriele on 1/20/13.
//
//

#import <Foundation/Foundation.h>

@protocol PowerUpHUDHolder <NSObject>
-(void)placePowerUpOnHUD:(NSString *)powerUp playerNumber:(int)playerNum;
-(void)removePowerUpFromHUD;
@end
