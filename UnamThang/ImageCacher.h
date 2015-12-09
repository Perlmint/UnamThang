//
//  ImageCacher.h
//  UnamThang
//
//  Created by omniavinco on 12. 7. 4..
//  Copyright (c) 2012년 omniavinco. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CACHE_SIZE 20

@interface ImageCacher : NSObject
{
    NSMutableDictionary *data;
    NSMutableOrderedSet *lastAccessedData;
}

+ (ImageCacher *)sharedObject;
- (UIImage *)imageForURL:(NSString *)url;
- (void)cleanupCache;
- (void)removeOldCache;
@end
