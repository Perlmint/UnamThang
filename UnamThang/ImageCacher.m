//
//  ImageCacher.m
//  UnamThang
//
//  Created by omniavinco on 12. 7. 4..
//  Copyright (c) 2012년 omniavinco. All rights reserved.
//

#import "ImageCacher.h"

@implementation ImageCacher

+ (ImageCacher *)sharedObject
{
    static ImageCacher *obj = nil;
    
    if (obj == nil) {
        obj = [[ImageCacher alloc] init];
    }
    
    return obj;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        data = [[NSMutableDictionary alloc] init];
        lastAccessedData = [[NSMutableOrderedSet alloc] initWithCapacity:CACHE_SIZE];
    }
    
    return self;
}

- (UIImage *)imageForURL:(NSString *)url
{
    UIImage *ret = [data objectForKey:url];
    
    [lastAccessedData addObject:url];
    if (lastAccessedData.count > CACHE_SIZE) {
        [lastAccessedData removeObjectAtIndex:0];
    }
    
    if (ret == nil) {
        ret = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
        [data setObject:ret forKey:url];
    }
    
    return ret;
}

- (void)cleanupCache
{
    [data removeAllObjects];
}

- (void)removeOldCache
{
    NSDictionary *tmpDictionary = [data dictionaryWithValuesForKeys:lastAccessedData.array];
    
    [data removeAllObjects];
    [data setDictionary:tmpDictionary];
}

@end
