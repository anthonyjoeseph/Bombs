//
//  ShootingBehavior.m
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShootingBehavior.h"
#import "Bullet.h"
#import "SimpleAudioEngine.h"
#import "Player.h"
#import "BufferPool.h"


@implementation ShootingBehavior
@synthesize projectilePool = _projectilePool;
@synthesize reloadTime = _reloadTime;

-(id)initWithBadGuy:(GameObject *)badGuy projectilePool:(GameObjectPool *)projectilePool reloadTime:(float)reloadTime{
    if((self = [super initWithBadGuy:badGuy])){
        firstTime = YES;
        self.projectilePool = projectilePool;
        self.reloadTime = reloadTime;
        canSee = NO;
        canShoot = NO;
        timeSinceLastReload = reloadTime;
    }
    return self;
}
-(void)update:(ccTime)dt listOfBlocks:(NSArray *)blockList{
    if(firstTime){
        firstTime = NO;
        if([self.badGuy isUpsideDown]){
            [self.projectilePool makeUpsideDown];
        }
    }
    //checks if it shot last time
    //if it did shoot last time, canSee and canShoot will still residually be true
    //they have to remain residually true so that any extention of this class will
    //be able to successfully override this method, for example, StopToShoot
    if(canSee && canShoot){
        canShoot = NO;
        timeSinceLastReload = 0;
    }
    timeSinceLastReload += dt;
    if(timeSinceLastReload > self.reloadTime && !canShoot){
        canShoot = YES;
        timeSinceLastReload = 0;
    }
    
    CGPoint badGuyPosition = self.badGuy.position;
    GameDirection badGuyDirection = self.badGuy.direction;
    Bullet *projectile;
    
    CGPoint playerPosition = playerOne.position;
    canSee = NO;
    int badGuyOffsetX = 0;
    int badGuyOffsetY = 0;
    if((badGuyPosition.x == playerPosition.x || badGuyPosition.y == playerPosition.y)){
        if(badGuyPosition.y < playerPosition.y && badGuyDirection == kUp){
            canSee = YES;
            badGuyOffsetY = self.badGuy.contentSize.height / 2;
        }else if(badGuyPosition.y > playerPosition.y && badGuyDirection == kDown){
            canSee = YES;
            badGuyOffsetY = self.badGuy.contentSize.height / -2;
        }else if(badGuyPosition.x < playerPosition.x && badGuyDirection == kRight){
            canSee = YES;
            badGuyOffsetX = self.badGuy.contentSize.width / 2;
        }else if(badGuyPosition.x > playerPosition.x && badGuyDirection == kLeft){
            canSee = YES;
            badGuyOffsetX = self.badGuy.contentSize.width / -2;
        }
    }
    playerPosition = playerTwo.position;
    if((badGuyPosition.x == playerPosition.x || badGuyPosition.y == playerPosition.y)){
        if(badGuyPosition.y < playerPosition.y && badGuyDirection == kUp){
            canSee = YES;
            badGuyOffsetY = self.badGuy.contentSize.height / 2;
        }else if(badGuyPosition.y > playerPosition.y && badGuyDirection == kDown){
            canSee = YES;
            badGuyOffsetY = self.badGuy.contentSize.height / -2;
        }else if(badGuyPosition.x < playerPosition.x && badGuyDirection == kRight){
            canSee = YES;
            badGuyOffsetX = self.badGuy.contentSize.width / 2;
        }else if(badGuyPosition.x > playerPosition.x && badGuyDirection == kLeft){
            canSee = YES;
            badGuyOffsetX = self.badGuy.contentSize.width / -2;
        }
    }
    if(canSee && canShoot){
        //offset it to put it right in front of the shooter
        //[[SimpleAudioEngine sharedEngine] playEffect:@"Hut.mp3"];
        projectile = (Bullet *)[self.projectilePool placeObject:ccp(badGuyPosition.x + badGuyOffsetX, badGuyPosition.y + badGuyOffsetY)];
        projectile.direction = badGuyDirection;
        int projectileOffsetX = 0;
        int projectileOffsetY = 0;
        switch (projectile.direction){
            case kRight:
                projectileOffsetX = projectile.contentSize.width / 2;
                break;
            case kDown:
                projectileOffsetY = projectile.contentSize.width / -2;
                break;
            case kLeft:
                projectileOffsetX = projectile.contentSize.width / -2;
                break;
            case kUp:
                projectileOffsetY = projectile.contentSize.width / 2;
                break;
        }
        projectile.position = ccp(projectile.position.x + projectileOffsetX, projectile.position.y + projectileOffsetY);
    }
    
}
@end
