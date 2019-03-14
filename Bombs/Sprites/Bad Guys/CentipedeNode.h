//
//  CentipedeNode.h
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BadGuy.h"
#import "Collidable.h"
#import "CreationPool.h"

@interface CentipedeNode : BadGuy <Collidable> {
    int maxNumberOfNodes;
    bool createCentipede;
    bool primeBackNode;
    CGPoint startingPoint;
    GameDirection previousDirection;
    CentipedeNode *_frontNode;
    CentipedeNode *_backNode;
    CreationPool *nodeCreator;
    float invincibleTime;
}
-(void)collisionWithSprite:(GameObject *)otherObject;
-(void)isFollowNode:(CGPoint)startPoint;
-(GameDirection)previousDirection;
-(int)numFrontNodes;
-(int)numBackNodes;
-(void)setFrontNodeSpeeds:(float)newSpeed;
-(void)setBackNodeSpeeds:(float)newSpeed;
-(void)invincibleFor:(float)seconds;

@property (nonatomic, assign) CentipedeNode *frontNode;
@property (nonatomic, assign) CentipedeNode *backNode;

@end
