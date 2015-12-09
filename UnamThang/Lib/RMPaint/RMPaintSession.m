//
//  RMPaintSession.m
//  GLPaint
//
//  Created by Hermes Pique on 5/9/12.
//	Copyright 2012 Robot Media SL <http://www.robotmedia.net>. All rights reserved.
//
//	This file is part of RMPaint.
//
//	RMPaint is free software: you can redistribute it and/or modify
//	it under the terms of the GNU Lesser Public License as published by
//	the Free Software Foundation, either version 3 of the License, or
//	(at your option) any later version.
//
//	RMPaint is distributed in the hope that it will be useful,
//	but WITHOUT ANY WARRANTY; without even the implied warranty of
//	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//	GNU Lesser Public License for more details.
//
//	You should have received a copy of the GNU Lesser Public License
//	along with RMPaint.  If not, see <http://www.gnu.org/licenses/>.

#import "RMPaintSession.h"
#import "RMCanvasView.h"
#import "../JSON/SBJson.h"

@interface paintDescriptor:NSObject {
    RMCanvasView *targetCanvas;
    NSEnumerator *enumerator;
    CGFloat delay;
}
@property (nonatomic) RMCanvasView *targetCanvas;
@property (nonatomic) NSEnumerator *enumerator;
@property (nonatomic) CGFloat delay;
+ (paintDescriptor *)descriptorWithCanvas:(RMCanvasView *)canvas andEnumerator:(NSEnumerator *)enume;
+ (paintDescriptor *)descriptorWithCanvas:(RMCanvasView *)canvas andEnumerator:(NSEnumerator *)enume andDelay:(CGFloat)del;
@end

@implementation paintDescriptor
@synthesize targetCanvas, enumerator, delay;
+ (paintDescriptor *)descriptorWithCanvas:(RMCanvasView *)canvas andEnumerator:(NSEnumerator *)enume
{
    return [paintDescriptor descriptorWithCanvas:canvas andEnumerator:enume andDelay:0];
}
+ (paintDescriptor *)descriptorWithCanvas:(RMCanvasView *)canvas andEnumerator:(NSEnumerator *)enume andDelay:(CGFloat)del
{
    paintDescriptor *ret = [[paintDescriptor alloc] init];
    ret.targetCanvas = canvas;
    ret.enumerator = enume;
    ret.delay = del;
    return ret;
}
@end

@implementation RMPaintSession

@synthesize steps = steps_;

- (id) init {
    if ((self = [super init])) {
        steps_ = [[NSMutableArray alloc] init];        
    }
    return self;
}

- (id)initWith:(NSArray *)steps {
    if ((self = [self init])) {
        for (NSArray* stepData in steps) {
            RMPaintStep* step = [[RMPaintStep alloc] initWithData:stepData];
            [steps_ addObject:step];
        }
    }
    return self;
}

- (void) clear {
    [steps_ removeAllObjects];
}

- (void)paintInCanvas:(RMCanvasView*)canvas {
    [self performSelector:@selector(paint:) withObject:[paintDescriptor descriptorWithCanvas:canvas andEnumerator:self.steps.objectEnumerator]];
}

- (void)paintInCanvas:(RMCanvasView *)canvas withDelay:(CGFloat)delay
{
    [self performSelector:@selector(paint:) withObject:[paintDescriptor descriptorWithCanvas:canvas andEnumerator:self.steps.objectEnumerator andDelay:delay]];
}

- (void)paint:(paintDescriptor *)descriptor
{
    RMPaintStep* step = descriptor.enumerator.nextObject;
    
    if (step != nil) {
        [step paintInCanvas:descriptor.targetCanvas];
        [self performSelector:@selector(paint:) withObject:descriptor afterDelay:descriptor.delay];
    }
}

- (NSString *)save {
    NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:steps_.count];
    for (RMPaintStep *step in steps_) {
        [tmpArray addObject:[step toJSON]];
    }
    return [NSMutableString stringWithFormat:@"[%@]", [tmpArray componentsJoinedByString:@","]];
}

- (void) addStep:(RMPaintStep*)step {
    [steps_ addObject:step];
}

@end
