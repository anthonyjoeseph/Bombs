//
//  Level.h
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "LevelChanger.h"
#import "PoolRegistrar.h"
#import "GameObject.h"
#import "Player.h"
#import "Block.h"
#import "Explosion.h"
#import "CameraDelegate.h"
@interface Level : CCLayer <PoolRegistrar>{
	CGSize mapSizeInTiles;
	CGSize tileSize;
    ccColor4B backgroundColor;
    NSMutableDictionary *pools;
    NSMutableDictionary *newPools;
    NSMutableArray *newPoolKeys;
    bool updateCycle;
    NSMutableArray *blockPools;
    NSMutableArray *blocks;
    Player *playerOne;
    Player *playerTwo;
    NSMutableArray *knowsPlayers;
    int numPlayers;
    bool isLevelOver;
    
    //id<ClipDelegate> _clipDelegate;
    float musicDuration;
}
-(void)initializeActionLayer:(NSString *)fileName;
-(id)initWithTMXFile:(NSString *)tmxFile withDelegate:(id<LevelChanger>) theDelegate numPlayers:(int)numPlayers;
-(ccColor4B)backgroundColor;
-(void)createObjectOfType:(NSString*)type atLocation:(CGPoint)spawnLocation properties:(NSDictionary *)properties isUpsideDown:(bool)isUpsideDown;
-(CCNode *)contextNode;
-(GameObjectPool *)poolWithKey:(NSString *)gameObjectType;
-(void)registerSelf:(id)pool forKey:(NSString *)gameObjectType;
-(void)update:(ccTime)dt;
-(Player *)getPlayer:(int)playerNumber;
-(double)mapWidth;
-(double)mapHeight;
-(CGPoint)rootPosition:(CGPoint)offsetPosition withSize:(CGSize)theSize;
-(CGPoint)offsetPosition:(CGPoint)rootPosition withSize:(CGSize)theSize;

@property (nonatomic, assign) id<LevelChanger> levelDelegate;
//@property (nonatomic, assign) id<ClipDelegate> clipDelegate;
@property (nonatomic, retain) NSMutableArray *listOfGameObjects; 
@property (nonatomic, retain) NSMutableArray *collisionList;
@end
