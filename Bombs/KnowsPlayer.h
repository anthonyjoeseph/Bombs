//
//  KnowsPlayer.h
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Player;

@protocol KnowsPlayer <NSObject>
-(void)registerPlayerOne:(Player *)playerOne playerTwo:(Player *)playerTwo;
@end
