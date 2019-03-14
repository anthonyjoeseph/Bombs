//
//  TapBomb.h
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bomb.h"
#import "RecievesTouches.h"


@interface TapBomb : Bomb <RecievesTouches>{
    
}
-(void)touch:(CGPoint)location;

@end
