//
//  SwarmView.m
//  Swarm
//
//  Created by Ernesto Elsäßer on 06/01/14.
//  Copyright (c) 2014 Ernesto Elsäßer. All rights reserved.
//

#import "SwarmView.h"
#import "SwarmBug.h"
#import "SwarmParams.h"

@interface SwarmView ()

@property SwarmParams *params;
@property NSMutableArray *bugs, *targets;
@property NSDateFormatter *dateFormatter;
@property NSPoint clockPoint;
@property NSDictionary *clockAttributes;

@end

@implementation SwarmView

- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        [self setAnimationTimeInterval:1/30.0];
    }
    
    [self spawnBugs];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"HH:mm"];
    
    self.clockPoint = NSMakePoint(self.params.screenw - 100, self.params.screenh - 100);
    
    self.clockAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSFont fontWithName:@"Helvetica" size:26], NSFontAttributeName,[NSColor blackColor], NSForegroundColorAttributeName, nil];

    
    return self;
}

- (void) spawnBugs
{
    self.params = [[SwarmParams alloc] initWithBounds:[self bounds]];
    
    [SwarmBug setParams:self.params];
    
    self.targets = [[NSMutableArray alloc] init];
    self.bugs = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.params.targetNum; i++) {
        
        SwarmBug *t = [[SwarmBug alloc] init];
        [self.targets addObject: t];
        
        for (int i = 0; i < self.params.bugNum; i++) {
            
            SwarmBug *b = [[SwarmBug alloc] initWithTarget:t];
            [self.bugs addObject: b];
        }
    }
    
    
}

- (void)startAnimation
{
    [super startAnimation];
}

- (void)stopAnimation
{
    [super stopAnimation];
}

- (void)drawRect:(NSRect)rect
{
    [super drawRect:rect];
}

- (void)animateOneFrame
{
    // background
    
    NSBezierPath* frame = [NSBezierPath bezierPathWithRect:[self bounds]];
    [[NSColor blackColor] set];
    [frame fill];
    
    // targets
    
    for(SwarmBug *t in self.targets) {
        
        [t updateTargetState];
        [t draw];
    
    }

    // bugs
    
    for(SwarmBug *b in self.bugs) {
        
        [b updateState];
        [b draw];
        
    }
    
    
    NSString *test = [self.dateFormatter stringFromDate:[NSDate date]];
    [test drawAtPoint:self.clockPoint withAttributes:self.clockAttributes];
    
    return;
}

- (BOOL)hasConfigureSheet
{
    return NO;
}

- (NSWindow*)configureSheet
{
    return nil;
}

@end
