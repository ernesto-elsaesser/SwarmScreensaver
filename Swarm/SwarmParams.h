//
//  SwarmProps.h
//  Swarm
//
//  Created by Ernesto Elsäßer on 06/01/14.
//  Copyright (c) 2014 Ernesto Elsäßer. All rights reserved.
//

#import <ScreenSaver/ScreenSaver.h>

@interface SwarmParams : NSObject

@property float dt,targetVel,targetAcc,maxVel,maxAcc,noise,halfDtSq,dtInv,targetVelSq,maxVelSq,minVel,minVelSq,lineWidth;
@property int bugNum,targetNum,trailLen,screenw,screenh;

- (id) initWithBounds:(NSRect)bounds;

@end
