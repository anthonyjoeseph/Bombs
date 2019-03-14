//
//  GamePreferences.m
//  Detonate
//
//  Created by Anthony Gabriele on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GamePreferences.h"
#import "DpadInterface.h"


@implementation GamePreferences
@synthesize pauseScreenUp = _pauseScreenUp;
@synthesize onePlayerData = _onePlayerData;
@synthesize twoPlayerPlayerOneData = _twoPlayerPlayerOneData;
@synthesize twoPlayerPlayerTwoData = _twoPlayerPlayerTwoData;
@synthesize playerOneInterfaceType;
@synthesize playerTwoInterfaceType;

static GamePreferences *sharedInstance = nil;

-(id)init{
    if((self = [super init])){
        self.pauseScreenUp = NO;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if([userDefaults boolForKey:@"HasDefaults"]){
            self.playerOneInterfaceType = [userDefaults integerForKey:@"PlayerOneInterfaceType"];
            self.playerTwoInterfaceType = [userDefaults integerForKey:@"PlayerTwoInterfaceType"];
        }else{
            [userDefaults setBool:YES forKey:@"HasDefaults"];
            [userDefaults setInteger:kDPadInterface forKey:@"PlayerOneInterfaceType"];
            [userDefaults setInteger:kDPadInterface forKey:@"PlayerTwoInterfaceType"];
        }
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [paths objectAtIndex:0];
        NSString *documentPath = [documentDirectory stringByAppendingPathComponent:@"GameData.dat"];
        NSMutableDictionary *rootObject = [NSKeyedUnarchiver unarchiveObjectWithFile:documentPath];
        if(rootObject){
            self.onePlayerData = [rootObject objectForKey:@"onePlayerData"];
            self.twoPlayerPlayerOneData = [rootObject objectForKey:@"twoPlayerPlayerOneData"];
            self.twoPlayerPlayerTwoData = [rootObject objectForKey:@"twoPlayerPlayerTwoData"];
            //[decoder release];
        }else{
            self.onePlayerData = [[[PlayerData alloc] init] autorelease];
            self.twoPlayerPlayerOneData = [[[PlayerData alloc] init] autorelease];
            self.twoPlayerPlayerTwoData = [[[PlayerData alloc] init] autorelease];
        }
    }
    return self;
}
-(void)savePlayerProgress{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *gameStatePath = [documentsDirectory stringByAppendingPathComponent:@"GameData.dat"];
    NSMutableDictionary *rootObject = [[NSMutableDictionary alloc] init];
    [rootObject setObject:self.onePlayerData forKey:@"onePlayerData"];
    [rootObject setObject:self.twoPlayerPlayerOneData forKey:@"twoPlayerPlayerOneData"];
    [rootObject setObject:self.twoPlayerPlayerTwoData forKey:@"twoPlayerPlayerTwoData"];
    [NSKeyedArchiver archiveRootObject:rootObject toFile:gameStatePath];
    [rootObject release];
}

#pragma mark -
#pragma mark Singleton methods

+ (GamePreferences *)sharedInstance{
	@synchronized(self){
		if(!sharedInstance){
			sharedInstance = [[GamePreferences alloc] init];
		}
	}
    return sharedInstance;
}

+(id)alloc{
	@synchronized(self){
        if (!sharedInstance) {
			sharedInstance = [super alloc];
			return sharedInstance;
		}
	}
	
	return nil;
}

+(id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (!sharedInstance) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}
-(id)copyWithZone:(NSZone *)zone
{
    return self;
}

-(id)retain {
    return self;
}

-(NSUInteger)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}

/*-(void)release {
    //do nothing
}*/

- (id)autorelease {
    return self;
}
@end
