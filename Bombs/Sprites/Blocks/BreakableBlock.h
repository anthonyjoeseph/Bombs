//
//  BreakableBlock.h
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Block.h"
#import "Breakable.h"

@interface BreakableBlock : Block <Breakable>{
    NSMutableDictionary *powerUps;
}
-(void)die;

@end
