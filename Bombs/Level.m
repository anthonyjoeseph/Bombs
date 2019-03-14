//
//  Level.m
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Level.h"
#import "Collidable.h"
#import "BadGuy.h"
#import "CreationPool.h"
#import "RecievesTouches.h"
#import "MustKill.h"
#import "HasProperties.h"
#import "SimpleAudioEngine.h"


@implementation Level
@synthesize levelDelegate = _levelDelegate;
@synthesize listOfGameObjects = _listOfGameObjects;
@synthesize collisionList = _collisionList;

-(id)initWithTMXFile:(NSString *)tmxFile withDelegate:(id<LevelChanger>)theDelegate numPlayers:(int)_numPlayers{
    if((self = [super init])){
        self.levelDelegate = theDelegate;
        numPlayers = _numPlayers;
        
        pools = [[NSMutableDictionary alloc] init];
        newPools = [[NSMutableDictionary alloc] init];
        newPoolKeys = [[NSMutableArray alloc] init];
        blockPools = [[NSMutableArray alloc] init];
        blocks = [[NSMutableArray alloc] init];
        knowsPlayers = [[NSMutableArray alloc] init];
        updateCycle = NO;
        isLevelOver = NO;
        
        [self initializeActionLayer:tmxFile];
        musicDuration = 0;
        
        [self schedule:@selector(update:)];
        
        self.isTouchEnabled = YES;
    }
    return self;
}
//removes the sprites that are created by the tile map and replaces them with GameObjects
-(void)initializeActionLayer:(NSString *)fileName{
    CCTMXTiledMap *theMap = [[CCTMXTiledMap tiledMapWithTMXFile:fileName] retain];
    mapSizeInTiles = theMap.mapSize;
    tileSize = theMap.tileSize;
    CCTMXLayer *currentLevel = [theMap layerNamed:@"Action"];
    
    NSDictionary *layerProperties = [currentLevel properties];
    int colorValue0 = [[layerProperties valueForKey:@"ColorValue0"] integerValue];
    int colorValue1 = [[layerProperties valueForKey:@"ColorValue1"] integerValue];
    int colorValue2 = [[layerProperties valueForKey:@"ColorValue2"] integerValue];
    int colorValue3 = [[layerProperties valueForKey:@"ColorValue3"] integerValue];
    backgroundColor = ccc4(colorValue0, colorValue1, colorValue2, colorValue3);
    
    int cols = mapSizeInTiles.width;
    int rows = mapSizeInTiles.height;
    int x, y;
    CCSprite *SpriteAtTile;
    CGPoint position;
    NSDictionary *properties;
    NSString *type;
    bool isUpsideDown = NO;
    for(x = 0; x < cols; x++){
        for(y = 0; y < rows; y++){
            if(numPlayers == 2){
                if(y > rows/2 || (y == rows/2 && x > rows/2)){
                    isUpsideDown = YES;
                }else{
                    isUpsideDown = NO;
                }
            }else{
                isUpsideDown = NO;
            }
            SpriteAtTile = [currentLevel tileAt: ccp(x,y)];
            int tileGid = [currentLevel tileGIDAt: ccp(x,y)];
            if (tileGid){
                properties = [theMap propertiesForGID:tileGid];
                if (properties){
                    type = [properties valueForKey:@"Type"];
                    position = [self offsetPosition:SpriteAtTile.position withSize:SpriteAtTile.contentSize];
                    [self createObjectOfType:type atLocation:position properties:properties isUpsideDown:isUpsideDown];
                }
            }
        }
    }
    for(id currentObject in knowsPlayers){
        [currentObject registerPlayerOne:playerOne playerTwo:playerTwo];
    }
    [knowsPlayers removeAllObjects];
    [theMap release];
}
-(ccColor4B)backgroundColor{
    return backgroundColor;
}
-(void)createObjectOfType:(NSString *)type atLocation:(CGPoint)spawnLocation properties:(NSDictionary *)properties isUpsideDown:(bool)isUpsideDown{
    GameObjectPool *currentPool = [pools objectForKey:type];
    id currentObject;
    if(currentPool == nil){
        currentPool = [[[CreationPool alloc] initWithGameObjectType:type poolRegistrar:self] autorelease];
        
        currentObject = [currentPool placeObject:spawnLocation];
        if([currentObject isKindOfClass:[Block class]]){
            [blockPools addObject:currentPool];
        }
    }else{
        currentObject = [currentPool placeObject:spawnLocation];
    }
    if(isUpsideDown){
        [currentObject makeUpsideDown];
    }
    if([currentObject conformsToProtocol:@protocol(KnowsPlayer)]){
        [knowsPlayers addObject:currentObject];
    }
    if([currentObject conformsToProtocol:@protocol(HasProperties)]){
        [currentObject addProperties:properties];
    }
    if([currentObject isKindOfClass:[Player class]]){
        if(!playerOne){
            playerOne = currentObject;
            playerOne.isPlayerOne = YES;
        }else if(numPlayers == 2){
            playerTwo = currentObject;
            playerTwo.isPlayerOne = NO;
        }else{
            [currentObject removeSelf];
            [currentObject removeSelfFromCollisionList];
        }
    }
}
-(CCNode *)contextNode{
    return self;
}
-(GameObjectPool *)poolWithKey:(NSString *)gameObjectType{
    return [pools objectForKey:gameObjectType];
}
-(void)registerSelf:(id)registerThisPool forKey:(NSString *)gameObjectType{
    if([pools objectForKey:gameObjectType]){
        [self registerSelf:registerThisPool forKey:[gameObjectType stringByAppendingString:@"1"]];
    }else{
        if(updateCycle){
            [newPools setObject:registerThisPool forKey:gameObjectType];
            [newPoolKeys addObject:gameObjectType];
        }else{
            [pools setObject:registerThisPool forKey:gameObjectType];
        }
    }
}
-(void) update:(ccTime)deltaTime
{
    bool hasMustKills = NO;
    updateCycle = YES;
    
    //redo the block array in case any blocks have exploded
    [blocks removeAllObjects];
    for(GameObjectPool *blockPool in blockPools){
        [blocks addObjectsFromArray:blockPool.collisionObjects];
    }
    for(GameObjectPool *currentPool in [pools objectEnumerator]){
        for(GameObject *currentObject in currentPool.collisionObjects){
            if([currentObject conformsToProtocol:@protocol(MustKill)]){
                hasMustKills = YES;
            }
            for(GameObjectPool *collisionPool in [pools objectEnumerator]){
                for(GameObject<Collidable> *collisionObject in collisionPool.collidableObjects){
                    if(collisionObject != currentObject){
                        CGRect myBoundingBox = [collisionObject boundingBox];
                        CGRect otherBox = [currentObject boundingBox];
                        if (CGRectIntersectsRect(myBoundingBox, otherBox)) {
                            [collisionObject collisionWithSprite:currentObject];
                        }
                    }
                }
            }
            [currentObject update:deltaTime listOfBlocks:blocks];
        }
    }
    //prevents an exception for mutating the gameObject set while it's enumerating
    NSArray *enumerator = [[pools allValues] retain];
    for(int i = 0; i < [enumerator count]; i++){
        [[enumerator objectAtIndex:i] removeObjectsMarkedForRemoval];
    }
    [enumerator release];
    //prevents an exception for mutating the Pool set while it's enumerating
    for(NSString *newPoolKey in [newPoolKeys objectEnumerator]){
        [pools setObject:[newPools objectForKey:newPoolKey] forKey:newPoolKey];
    }
    [newPoolKeys removeAllObjects];
    [newPools removeAllObjects];
    
    if(!isLevelOver && !hasMustKills){
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        [[SimpleAudioEngine sharedEngine] playEffect:@"Win.mp3"];
        isLevelOver = YES;
        [self.levelDelegate levelIsOver];
    }
}
- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    for(GameObjectPool *currentPool in [pools objectEnumerator]){
        for(id<RecievesTouches> currentObject in currentPool.touchableObjects){
            for(id touch in touches){
                [currentObject touch: [self convertTouchToNodeSpace: touch]];
            }
        }
        [currentPool removeObjectsMarkedForRemoval];
    }
}
- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{}
- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{}
- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{}
-(Player *)getPlayer:(int)playerNumber{
    if(playerNumber == 1){
        return playerOne;
    }
    if(playerNumber == 2){
        return playerTwo;
    }
    return nil;
}
-(double)mapWidth{
    return mapSizeInTiles.width * tileSize.width;
}
-(double)mapHeight{
    return mapSizeInTiles.height * tileSize.height;
}
-(CGPoint)rootPosition:(CGPoint)offsetPosition withSize:(CGSize)theSize{
	return ccp(offsetPosition.x - (theSize.width / 2), offsetPosition.y - (theSize.height / 2));
}
-(CGPoint)offsetPosition:(CGPoint)rootPosition withSize:(CGSize)theSize{
	return ccp(rootPosition.x + (theSize.width / 2), rootPosition.y + (theSize.height / 2));
}
-(void)dealloc{
    [pools release];
    [newPools release];
    [blockPools release];
    [blocks release];
    [knowsPlayers release];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    [super dealloc];
}
@end
