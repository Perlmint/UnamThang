//
//  RMPaintStep.m
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

#import "RMPaintStep.h"
#import "RMCanvasView.h"

@implementation RMPaintStep

@dynamic data;
@synthesize start;
@synthesize end;
@synthesize color;
@synthesize size;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    UIColor *color_ = [UIColor colorWithRed:[aDecoder decodeFloatForKey:@"red"] green:[aDecoder decodeFloatForKey:@"green"] blue:[aDecoder decodeFloatForKey:@"blue"] alpha:[aDecoder decodeFloatForKey:@"alpha"]];
    CGPoint start_ = [aDecoder decodeCGPointForKey:@"start"];
    CGPoint end_ = [aDecoder decodeCGPointForKey:@"end"];
    
    self = [self initWithColor:color_ start:start_ end:end_ size:0.f];
    return self;
}

- (id)initWithColor:(UIColor*)aColor start:(CGPoint)aStart end:(CGPoint)anEnd size:(CGFloat)size_ {
    if ((self = [super init])) {
        self.color = aColor;
        self.start = aStart;
        self.end = anEnd;
        self.size = size_;
    }
    return self;
}

- (id)initWithData:(NSArray*)data {    
    if ((self = [super init])) {
        self.start = CGPointFromString([data objectAtIndex:0]);
		self.end = CGPointFromString([data objectAtIndex:1]);
        self.color = [UIColor colorWithRed:[[data objectAtIndex:2] floatValue] 
                                     green:[[data objectAtIndex:3] floatValue]
                                      blue:[[data objectAtIndex:4] floatValue] 
                                     alpha:[[data objectAtIndex:5] floatValue]];
        self.size = [[data objectAtIndex:6] floatValue];
    }
    return self;
}

- (NSArray*) data {
    CGFloat red, green, blue, alpha;
    [self.color getRed:&red green:&green blue:&blue alpha:&alpha];
    return [NSArray arrayWithObjects:NSStringFromCGPoint(start), 
            NSStringFromCGPoint(end), 
            [NSNumber numberWithFloat:red], 
            [NSNumber numberWithFloat:green], 
            [NSNumber numberWithFloat:blue], 
            [NSNumber numberWithFloat:alpha], nil];
}

- (void)paintInCanvas:(RMCanvasView*)canvas {
    canvas.brushColor = self.color;
    canvas.brushScale = self.size;
    [canvas renderLineFromPoint:self.start toPoint:self.end];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    CGFloat red, green, blue, alpha;
    [self.color getRed:&red green:&green blue:&blue alpha:&alpha];
    [aCoder encodeFloat:red forKey:@"red"];
    [aCoder encodeFloat:green forKey:@"green"];
    [aCoder encodeFloat:blue forKey:@"blue"];
    [aCoder encodeFloat:alpha forKey:@"alpha"];
    [aCoder encodeCGPoint:start forKey:@"start"];
    [aCoder encodeCGPoint:end forKey:@"end"];
}

- (NSString *)toJSON
{
    CGFloat red, green, blue, alpha;
    [self.color getRed:&red green:&green blue:&blue alpha:&alpha];
    /*
     NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"\"{%f, %f}\"", start.x, start.y], @"start", [NSString stringWithFormat:@"\"{%f, %f}\"", end.x, end.y], @"end", [NSNumber numberWithFloat:red], @"red",[NSNumber numberWithFloat:green], @"green",[NSNumber numberWithFloat:blue], @"blue",[NSNumber numberWithFloat:alpha], @"alpha", nil];
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (NSObject *key in data.keyEnumerator)
    {
        //[tmpArray addObject:[NSString stringWithFormat:@"%@", key, [data objectForKey:key]]];
    }
     */
    NSArray *tmpArray = [NSArray arrayWithObjects:[NSString stringWithFormat:@"\"{%f, %f}\"", start.x, start.y], [NSString stringWithFormat:@"\"{%f, %f}\"", end.x, end.y], [NSNumber numberWithFloat:red], [NSNumber numberWithFloat:green], [NSNumber numberWithFloat:blue], [NSNumber numberWithFloat:alpha], [NSNumber numberWithFloat:size], nil];

    return [NSString stringWithFormat:@"[%@]", [tmpArray componentsJoinedByString:@","]];
}

@end
