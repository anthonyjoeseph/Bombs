//
//  CameraDelegate.h
//  Detonate
//
//  Created by Anthony Gabriele on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CameraDelegate <NSObject>
-(void)shiftWorldtoFocalPoint:(CGPoint)focalPoint;
@end
