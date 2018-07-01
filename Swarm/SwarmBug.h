//
//  SwarmBug.h
//  Swarm
//
//  Created by Ernesto Elsäßer on 11/26/13.
//  Copyright (c) 2013 Ernesto Elsäßer. All rights reserved.
//

#import <ScreenSaver/ScreenSaver.h>
#import "SwarmParams.h"

@interface SwarmBug : NSObject

+ (void) setParams:(SwarmParams*)params;
- (id) init;
- (id) initWithTarget:(SwarmBug*)t;
- (void) updateTargetState;
- (void) updateState;
- (void) draw;

@end
