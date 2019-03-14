//
//  GameObject.m
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameObject.h"
#import "Constants.h"

@implementation GameObject
@synthesize direction = _direction;
@synthesize remover = _remover;
@synthesize poolRegistrar = _poolRegistrar;
@synthesize currentAnimation = _currentAnimation;
@synthesize currentIdleFrameName = _currentIdleFrameName;

//When subclassing, override this method for initialization
-(id)initWithBatchNode:(CCSpriteBatchNode *)batchNode{
    //makes the rect equal to the entire batchNode image by default
    CGRect imageRect = CGRectZero;
    imageRect.size = batchNode.texture.contentSize;
    if((self = [super initWithBatchNode:batchNode rect:imageRect])){
        animating = NO;
        isUpsideDown = NO;
    }
    return self;
}
-(void)setDirection:(GameDirection)newDirection{
    switch (newDirection) {
		case kRight:
			[self setRotation: 0];
			[self setFlipX: NO];
			[self setFlipY: NO];
			break;
		case kDown:
			[self setRotation: 90];
			[self setFlipX: NO];
			[self setFlipY: NO];
			break;
		case kLeft:
			[self setRotation: 0];
			[self setFlipX: YES];
			[self setFlipY: NO];
			break;
		case kUp:
			[self setRotation: 90];
			[self setFlipX: YES];
			[self setFlipY: YES];
			break;
	}
    _direction = newDirection;
}
-(void)animate{
    if(currentAnimateAction){
        [self stopAction:currentAnimateAction];
        [currentAnimateAction release];
    }
    currentAnimateAction = [[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:self.currentAnimation restoreOriginalFrame:YES]] retain];
    [self runAction: currentAnimateAction];
    animating = YES;
}
-(void)idle{
    if(currentAnimateAction){
        [self stopAction:currentAnimateAction];
    }
    [self setDisplayFrame: currentIdleFrame];
    animating = NO;
}
-(void)setCurrentIdleFrameName:(NSString *)theFrame{
    if(currentIdleFrame){
        [currentIdleFrame release];
    }
    currentIdleFrame = [[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:theFrame] retain];
    _currentIdleFrameName = theFrame;
}
-(void)updateView{
    if(animating){
        [self animate];
    }else{
        [self idle];
    }
}
//I don't know why this method isn't included in cocos2d
-(CCAnimation *)loadAnimation:(NSString *)fileName frameCount:(int)numFrames frameDuration:(float)delay{
	NSString *plistFileName = [fileName stringByAppendingString:@".plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: plistFileName];
    
    NSMutableArray *frames = [[NSMutableArray alloc] init];
    CCSpriteFrame *theFrame;
    NSString *frameName;
    for(int i = 1; i <= numFrames; i++) {
        frameName = [fileName stringByAppendingString:[NSString stringWithFormat: @"%i.png", i]];
        theFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: frameName];
        [frames addObject: theFrame];
    }
    return [CCAnimation animationWithFrames:[frames autorelease] delay:delay];
}
-(CGPoint)tileCenterNearestSelf{
    int playerX = self.position.x - (kTileSize / 2);
    int playerXOffset = playerX % kTileSize;
    int playerY = self.position.y - (kTileSize / 2);
    int playerYOffset = playerY % kTileSize;
    int tileCenterX = playerX;
    int tileCenterY = playerY;
    if(playerXOffset != 0){
        if(playerXOffset < (kTileSize / 2)){
            tileCenterX -= playerXOffset;
        }
        if(playerXOffset >= (kTileSize / 2)){
            tileCenterX += (kTileSize - playerXOffset);
        }
    }
    if(playerYOffset != 0){
        if(playerYOffset < (kTileSize / 2)){
            tileCenterY -= playerYOffset;
        }
        if(playerYOffset >= (kTileSize / 2)){
            tileCenterY += (kTileSize - playerYOffset);
        }
    }
    tileCenterX += (kTileSize / 2);
    tileCenterY += (kTileSize / 2);
    return ccp(tileCenterX, tileCenterY);
}
-(void)update:(ccTime)dt listOfBlocks:(NSArray *)blockList{
    //override me
}
-(void)removeSelfFromCollisionList{
    [self.remover removeObjectFromCollisionList:self];
}
-(void)removeSelf{
    [self.remover removeObject:self];
}
-(int)drawOrder{
    return 0;
}
-(void)makeUpsideDown{
    [self setFlipY:YES];
    isUpsideDown = YES;
}
-(bool)isUpsideDown{
    return isUpsideDown;
}
-(void)setFlipY:(BOOL)flipY{
    if(isUpsideDown){
        [super setFlipY:!flipY];
    }else{
        [super setFlipY:flipY];
    }
}
-(void)dealloc{
    [currentAnimateAction release];
    [currentIdleFrame release];
    [super dealloc];
}
@end
