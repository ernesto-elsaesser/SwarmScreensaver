//
//  SwarmProps.m
//  Swarm
//
//  Created by Ernesto Elsäßer on 06/01/14.
//  Copyright (c) 2014 Ernesto Elsäßer. All rights reserved.
//

#import "SwarmParams.h"

@implementation SwarmParams

- (id) initWithBounds:(NSRect)bounds
{
    self.screenw = bounds.size.width;
    self.screenh = bounds.size.height;
    
    self.dt = 0.3; //0.3;
    self.targetVel = 18; // 0.03;
    self.targetAcc = 12; //0.02;
    self.maxVel = 30; // 0.05;
    self.maxAcc = 18; //0.03;
    self.noise = 6; //0.01;
    self.lineWidth = 2.0;
    
    self.targetNum = 3;
    self.bugNum = 8;
    self.trailLen = 40; //SSRandomIntBetween(24, 60);
    
    self.halfDtSq = self.dt*self.dt*0.5;
    self.dtInv = 1.0/self.dt;
    self.targetVelSq = self.targetVel*self.targetVel;
    self.maxVelSq = self.maxVel*self.maxVel;
    self.minVel = self.maxVel*0.5;
    self.minVelSq = self.minVel*self.minVel;
    
    return self;
}

@end
