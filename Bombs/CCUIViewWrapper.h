//
//  CCUIViewWrapper.h
//  Detonate
//
//  Created by Anthony Gabriele on 8/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface CCUIViewWrapper : CCSprite{
	UIView *uiItem;
	float rotation;
}

+ (id) wrapperForUIView:(UIView*)ui;
- (id) initForUIView:(UIView*)ui;
- (void) updateUIViewTransform;

@property (nonatomic, retain) UIView *uiItem;

@end