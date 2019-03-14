//
//  Heart.m
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Heart.h"
#import "Player.h"
#import "SimpleAudioEngine.h"


@implementation Heart
-(void)collisionWithSprite:(GameObject *)collider{
    if([collider isKindOfClass:[Player class]]){
        [[SimpleAudioEngine sharedEngine] playEffect:@"Heart.m4v"];
        [(Player *)collider heal:kOneHit];
        [self removeSelfFromCollisionList];
        [self removeSelf];
    }
}
@end
