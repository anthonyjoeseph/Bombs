//
//  Sentry.h
//  Detonate
//
//  Created by Anthony Gabriele on 8/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BadGuy.h"
#import "Player.h"
#import "HasProperties.h"

@interface Sentry : BadGuy <HasProperties>{
    Player *playerOne;
    Player *playerTwo;
    bool hasSeen;
}
-(void)addProperties:(NSDictionary *)properties;

@end
