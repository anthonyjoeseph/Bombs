//
//  Sentry.m
//  Detonate
//
//  Created by Anthony Gabriele on 8/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Sentry.h"
#import "HuntForPlayer.h"
#import "SimpleAudioEngine.h"
#import "SurveyBehavior.h"

@implementation Sentry
-(id)initWithBatchNode:(CCSpriteBatchNode *)batchNode{
    if((self = [super initWithBatchNode:batchNode])){
        self.tileMovementTime = kDefaultBadGuyMovementSpeed/* * .75*/;
        self.currentAnimation = [self loadAnimation:@"SentryWalking" frameCount:8 frameDuration:.2];
        self.currentIdleFrameName = @"SentryWalking1.png";
        [self idle];
        hasSeen = NO;
    }
    return self;
}
-(void)makeUpsideDown{
    //doesn't actually switch it upside down because it's direction matters
    isUpsideDown = YES;
}
-(void)addProperties:(NSDictionary *)properties{
    NSString *directionString = [properties valueForKey:@"Direction"];
    if([directionString isEqualToString:@"kRight"]){
        self.direction = kRight;
    }
    if([directionString isEqualToString:@"kDown"]){
        self.direction = kDown;
    }
    if([directionString isEqualToString:@"kLeft"]){
        self.direction = kLeft;
    }
    if([directionString isEqualToString:@"kUp"]){
        self.direction = kUp;
    }
    if([directionString isEqualToString:@"Rotate"]){
        self.direction = kRight;
        self.moveBehavior = [[[SurveyBehavior alloc] initWithBadGuy:self] autorelease];
    }
}
-(void)update:(ccTime)dt listOfBlocks:(NSArray *)blockList{
    if(!hasSeen){
        bool wasPlayerOne = NO;
        CGPoint badGuyPosition = self.position;
        GameDirection badGuyDirection = self.direction;
        CGPoint playerPosition = playerOne.position;
        if((badGuyPosition.x == playerPosition.x || badGuyPosition.y == playerPosition.y)){
            if(badGuyPosition.y < playerPosition.y && badGuyDirection == kUp){
                hasSeen = YES;
                wasPlayerOne = YES;
                for(GameObject *block in blockList){
                    if(block.position.x == playerPosition.x 
                         && block.position.y < playerPosition.y && block.position.y > badGuyPosition.y){
                        hasSeen = NO;
                        wasPlayerOne = NO;
                        
                    }
                }
            }else if(badGuyPosition.y > playerPosition.y && badGuyDirection == kDown){
                hasSeen = YES;
                wasPlayerOne = YES;
                for(GameObject *block in blockList){
                    if(block.position.x == playerPosition.x 
                         && block.position.y > playerPosition.y && block.position.y < badGuyPosition.y){
                        hasSeen = NO;
                        wasPlayerOne = NO;
                    }
                }
            }else if(badGuyPosition.x < playerPosition.x && badGuyDirection == kRight){
                hasSeen = YES;
                wasPlayerOne = YES;
                for(GameObject *block in blockList){
                    if(block.position.y == playerPosition.y 
                         && block.position.x < playerPosition.x && block.position.x > badGuyPosition.x){
                        hasSeen = NO;
                        wasPlayerOne = NO;
                    }
                }
            }else if(badGuyPosition.x > playerPosition.x && badGuyDirection == kLeft){
                hasSeen = YES;
                wasPlayerOne = YES;
                for(GameObject *block in blockList){
                    if(block.position.y == playerPosition.y 
                         && block.position.x > playerPosition.x && block.position.x < badGuyPosition.x){
                        hasSeen = NO;
                        wasPlayerOne = NO;
                    }
                }
            }
        }
        playerPosition = playerTwo.position;
        if((badGuyPosition.x == playerPosition.x || badGuyPosition.y == playerPosition.y)){
            if(badGuyPosition.y < playerPosition.y && badGuyDirection == kUp){
                hasSeen = YES;
                for(GameObject *block in blockList){
                    if(block.position.x == playerPosition.x 
                         && block.position.y < playerPosition.y && block.position.y > badGuyPosition.y){
                        hasSeen = NO;
                    }
                }
            }else if(badGuyPosition.y > playerPosition.y && badGuyDirection == kDown){
                hasSeen = YES;
                for(GameObject *block in blockList){
                    if(!(block.position.x == playerPosition.x 
                         && block.position.y > playerPosition.y && block.position.y < badGuyPosition.y)){
                        hasSeen = NO;
                    }
                }
            }else if(badGuyPosition.x < playerPosition.x && badGuyDirection == kRight){
                hasSeen = YES;
                for(GameObject *block in blockList){
                    if(!(block.position.y == playerPosition.y 
                         && block.position.x < playerPosition.x && block.position.x > badGuyPosition.x)){
                        hasSeen = NO;
                    }
                }
            }else if(badGuyPosition.x > playerPosition.x && badGuyDirection == kLeft){
                hasSeen = YES;
                for(GameObject *block in blockList){
                    if(!(block.position.y == playerPosition.y 
                         && block.position.x > playerPosition.x && block.position.x < badGuyPosition.x)){
                        hasSeen = NO;
                    }
                }
            }
        }
        if(hasSeen){
            if(wasPlayerOne){
                self.moveBehavior = [[[HuntForPlayer alloc] initWithBadGuy:self follow:playerOne] autorelease];
            }else{
                self.moveBehavior = [[[HuntForPlayer alloc] initWithBadGuy:self follow:playerTwo] autorelease];
            }
            [self animate];
            [self startMoving];
        }
    }
    [super update:dt listOfBlocks:blockList];
}
-(void)registerPlayerOne:(Player *)_playerOne playerTwo:(Player *)_playerTwo{
    playerOne = _playerOne;
    playerTwo = _playerTwo;
}
-(void)collisionWithSprite:(GameObject *)otherObject{
    if([otherObject isKindOfClass:[Player class]]){
        [(Player *)otherObject damage:kOneHit];
    }
    [super collisionWithSprite:otherObject];
}
-(void)die{
    [self removeSelfFromCollisionList];
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:2], [CCCallFunc actionWithTarget:self selector:@selector(removeSelf)], nil]];
    self.currentAnimation = [self loadAnimation:@"SentryDying" frameCount:4 frameDuration:.5];
    [self animate];
    [[SimpleAudioEngine sharedEngine] playEffect:@"Sentry.mp3"];
    [super die];
}

@end
