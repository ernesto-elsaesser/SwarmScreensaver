//
//  SwarmBug.m
//  Swarm
//
//  Created by Ernesto Elsäßer on 11/26/13.
//  Copyright (c) 2013 Ernesto Elsäßer. All rights reserved.
//

#import "SwarmBug.h"

@interface SwarmBug ()

@property float x,y,xvel,yvel,hue;
@property NSMutableArray *history;
@property SwarmBug *target;

@end

@implementation SwarmBug

static SwarmParams* params;

+ (void) setParams:(SwarmParams*)p
{
    params = p;
    
}

- (id) init
{
    self.history = [[NSMutableArray alloc] initWithCapacity: params.trailLen];
    
    self.x = SSRandomFloatBetween(0, params.screenw);
    self.y = SSRandomFloatBetween(0, params.screenh);
    
    self.xvel = SSRandomFloatBetween(0, params.targetVel/2);
    self.yvel = SSRandomFloatBetween(0, params.targetVel/2);
    
    self.hue = 0.1;
    
    [self positionToHistory];
    
    return self;
}

- (id) initWithTarget:(SwarmBug*)t
{
    self = [self init];
    
    self.target  = t;
    self.xvel = SSRandomFloatBetween(0, params.maxVel/2);
    self.yvel = SSRandomFloatBetween(0, params.maxVel/2);
    
    self.hue = 0.66;
    
    return self;
}

-(void) positionToHistory
{
    [self.history addObject: [NSValue valueWithPoint: NSMakePoint(self.x,self.y)]];
    if ([self.history count] > params.trailLen) [self.history removeObjectAtIndex:0];
}

-(void) draw
{
    
    NSBezierPath* path = [NSBezierPath bezierPath];
    
    NSPoint cur,prev;
    NSUInteger len = [self.history count];
    float frag = 1.0/len;
    
    NSColor *color = [NSColor colorWithCalibratedHue:self.hue saturation:1.0 brightness:1.0 alpha:frag];
    
    prev = ((NSValue*)[self.history objectAtIndex:0]).pointValue;
    
    [path setLineWidth:params.lineWidth];
    
    for(NSUInteger i = 1; i < len; i++) {
        
        cur = ((NSValue*)[self.history objectAtIndex:i-1]).pointValue;
        [path removeAllPoints];
        [path moveToPoint:prev];
        [path lineToPoint: cur];
        [color set];
        [path stroke];
        
        prev = cur;
        color = [color colorWithAlphaComponent:color.alphaComponent + frag];
    }

}

-(void) updateTargetState
{
    
    float theta = SSRandomFloatBetween(0, 6.28); // value???
    float ax = params.targetAcc*cos(theta);
    float ay = params.targetAcc*sin(theta);
    
    self.xvel += ax*params.dt;
    self.yvel += ay*params.dt;
    
    /* check velocity */
    float temp = pow(self.xvel,2) + pow(self.yvel,2);
    
    if (temp > params.targetVelSq) {
        temp = params.targetVel/sqrt(temp);
        
        /* save old vel for acc computation */
        ax = self.xvel;
        ay = self.yvel;
        
        /* compute new velocity */
        self.xvel *= temp;
        self.yvel *= temp;
        
        /* update acceleration */
        ax = (self.xvel-ax)*params.dtInv;
        ay = (self.yvel-ay)*params.dtInv;
    }
    
    /* update position */
    self.x += self.xvel*params.dt + ax*params.halfDtSq;
    self.y += self.yvel*params.dt + ay*params.halfDtSq;
    
    [self checkBounds];
    [self positionToHistory];
    
}

- (void) updateState
{
    
    float theta = atan2(self.target.y - self.y + SSRandomFloatBetween(0, params.noise),
                  self.target.x - self.x + SSRandomFloatBetween(0, params.noise));

    float ax = params.maxAcc*cos(theta);
    float ay = params.maxAcc*sin(theta);
    
    self.xvel += ax*params.dt;
    self.yvel += ay*params.dt;
    
    /* check velocity */
    float temp = pow(self.xvel,2) + pow(self.yvel,2);
    
    if (temp > params.maxVelSq) {
        
        temp = params.maxVel/sqrt(temp);
        
        /* save old vel for acc computation */
        ax = self.xvel;
        ay = self.yvel;
        
        /* compute new velocity */
        self.xvel *= temp;
        self.yvel *= temp;
        
        /* update acceleration */
        ax = (self.xvel-ax)*params.dtInv;
        ay = (self.yvel-ay)*params.dtInv;
        
    } else if (temp < params.minVelSq) {
        
        temp = params.minVel/sqrt(temp);
        
        /* save old vel for acc computation */
        ax = self.xvel;
        ay = self.yvel;
        
        /* compute new velocity */
        self.xvel *= temp;
        self.yvel *= temp;
        
        /* update acceleration */
        ax = (self.xvel-ax)*params.dtInv;
        ay = (self.yvel-ay)*params.dtInv;
    }
    
    /* update position */
    self.x += self.xvel*params.dt + ax*params.halfDtSq;
    self.y += self.yvel*params.dt + ay*params.halfDtSq;
        
    [self checkBounds];
    [self positionToHistory];

}

- (void) checkBounds
{
    
    /* check limits on targets */
    if (self.x < 0) {
        /* bounce */
        self.x = -self.x;
        self.xvel = -self.xvel;
    } else if (self.x >= params.screenw) {
        /* bounce */
        self.x = 2*params.screenw-self.x;
        self.xvel = -self.xvel;
    }
    if (self.y < 0) {
        /* bounce */
        self.y = -self.y;
        self.yvel = -self.yvel;
    } else if (self.y >= params.screenh) {
        /* bounce */
        self.y = 2*params.screenh-self.y;
        self.yvel = -self.yvel;
    }
    
}


@end
