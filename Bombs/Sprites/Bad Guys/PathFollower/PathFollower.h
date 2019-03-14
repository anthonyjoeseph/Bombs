//
//  PathFollower.h
//  Detonate
//
//  Created by Anthony Gabriele on 1/12/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "BadGuy.h"
#import "Path.h"

@interface PathFollower : BadGuy{
    int damage;
    bool isLookingForStart;
    Path *currentPath;
    Path *firstPath;
    Path *secondPath;
    Path *thirdPath;
    bool firstTime;
}

@end
