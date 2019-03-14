//
//  CentipedeNode.m
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CentipedeNode.h"
#import "FollowBehavior.h"
#import "NoBacktrackBehavior.h"
#import "SimpleAudioEngine.h"


@implementation CentipedeNode
@synthesize frontNode = _frontNode;
@synthesize backNode = _backNode;

//this is called for the creation of the first node
-(id)initWithBatchNode:(CCSpriteBatchNode *)batchNode{
    if((self = [super initWithBatchNode:batchNode])){
        maxNumberOfNodes = 7;
        self.frontNode = nil;
        self.backNode = nil;
        self.currentAnimation = [self loadAnimation:@"CentipedeNodeWalking" frameCount:2 frameDuration:.3];
        [self animate];
        self.tileMovementTime = kDefaultBadGuyMovementSpeed;
        createCentipede = YES;
        primeBackNode = YES;
        invincibleTime = 0;
    }
    return self;
}
-(void)isFollowNode:(CGPoint)startPoint{
    startingPoint = startPoint;
    createCentipede = NO;
}
-(GameDirection)previousDirection{
    return previousDirection;
}
-(void)update:(ccTime)dt listOfBlocks:(NSArray *)blockList{
    if(createCentipede){
        createCentipede = NO;
        self.moveBehavior = [[[NoBacktrackBehavior alloc] initWithBadGuy:self] autorelease];
        startingPoint = self.position;
        
        CreationPool *centipedeCreation = [[CreationPool alloc] initWithGameObjectType:@"CentipedeNode" poolRegistrar:self.poolRegistrar];
        CentipedeNode *tempFrontNode = self;
        CentipedeNode *tempBackNode;
        for(int i = 0; i < maxNumberOfNodes; i++){
            tempBackNode = (CentipedeNode *)[centipedeCreation placeObject:self.position];
            [tempBackNode isFollowNode:startingPoint];
            tempBackNode.moveBehavior = [[[FollowBehavior alloc] initWithBadGuy:tempBackNode follow:tempFrontNode] autorelease];
            
            tempBackNode.frontNode = tempFrontNode;
            tempFrontNode.backNode = tempBackNode;
            
            tempFrontNode = tempBackNode;
        }
        [centipedeCreation release];
    }
    if(invincibleTime > 0){
        invincibleTime -= dt;
    }
    [super update:dt listOfBlocks:blockList];
}
-(void)hasReachedTileAndIsMovingTo:(CGPoint)newPosition listOfBlocks:(NSArray *)listOfBlocks{
    if(primeBackNode && !CGPointEqualToPoint(self.position, startingPoint)){
        [self.backNode startMoving];
        primeBackNode = NO;
    }
    //self.backNode.direction = self.direction;
    //previousDirection = self.direction;
    [super hasReachedTileAndIsMovingTo:newPosition listOfBlocks:listOfBlocks];
}
-(void)die{
    if(invincibleTime <= 0){
        [[SimpleAudioEngine sharedEngine] playEffect:@"Centipede.mp3"];
        //a formula I worked out on paper that makes the speed when it has all 7 nodes equal bad guy speed and the speed with only 1 node equal the player speed
        float m = ((kDefaultBadGuyMovementSpeed - kDefaultPlayerMovementSpeed)/(maxNumberOfNodes - 1));
        int x;
        float b = kDefaultPlayerMovementSpeed - m;
        if(self.frontNode){
            x = [self.frontNode numFrontNodes];
            float newFrontSpeed = m*x + b;
            [self.frontNode setFrontNodeSpeeds:newFrontSpeed];
        }
        if(self.backNode){
            x = [self.backNode numBackNodes];
            float newBackSpeed = m*x + b;
            [self.backNode setBackNodeSpeeds:newBackSpeed];
        }
        
        if(self.frontNode){
            [self.frontNode invincibleFor:1];
            self.frontNode.backNode = nil;
        }
        if(self.backNode){
            [self.backNode invincibleFor:1];
            self.backNode.frontNode = nil;
            //make the backNode the new conductor
            self.backNode.moveBehavior = [[[NoBacktrackBehavior alloc] initWithBadGuy:self.backNode] autorelease];
        }
        self.currentAnimation = [self loadAnimation:@"CentipedeNodeDying" frameCount:3 frameDuration:.2];
        [self animate];
        [self removeSelfFromCollisionList];
        [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.6], [CCCallFunc actionWithTarget:self selector:@selector(removeSelf)], nil]];
        [super die];
    }
}
-(void)collisionWithSprite:(GameObject *)otherObject{
    if([otherObject isKindOfClass:[Player class]]){
        [(Player *)otherObject damage:kOneHit];
    }
}
-(int)numFrontNodes{
    if(!self.frontNode){
        return 1;
    }
    return [self.frontNode numFrontNodes] + 1;
}
-(int)numBackNodes{
    if(!self.backNode){
        return 1;
    }
    return [self.backNode numBackNodes] + 1;
}
-(void)setFrontNodeSpeeds:(float)newSpeed{
    self.tileMovementTime = newSpeed;
    if(self.frontNode){
        [self.frontNode setFrontNodeSpeeds:newSpeed]; 
    }
}
-(void)setBackNodeSpeeds:(float)newSpeed{
    self.tileMovementTime = newSpeed;
    if(self.backNode){
        [self.backNode setBackNodeSpeeds:newSpeed]; 
    }
}
-(void)invincibleFor:(float)seconds{
    invincibleTime = seconds;
}
@end
