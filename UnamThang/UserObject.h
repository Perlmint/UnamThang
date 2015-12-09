//
//  UserObject.h
//  UnamThang
//
//  Created by omniavinco on 12. 7. 3..
//  Copyright (c) 2012년 omniavinco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Lib/Facebook/Facebook.h"

@interface UserObject : NSObject <FBSessionDelegate, FBRequestDelegate, NSURLConnectionDataDelegate, NSURLConnectionDelegate>
{
    Facebook *fb;
    NSMutableArray *friendUsingAppList;
    NSMutableArray *friendList;
    NSMutableArray *challengeSenderList;
    NSMutableDictionary *userDataDictionary;
    NSMutableDictionary *currentGame;
    
    NSMutableData *recivedData;
}

@property (readonly) Facebook *fb;
@property (nonatomic) NSUInteger score;
@property (readonly) NSArray *friendList;
@property (readonly) NSArray *friendUsingAppList;
@property (readonly) NSArray *challengeSenderList;
@property (nonatomic, retain) NSMutableDictionary *currentGame;

+ (UserObject *)sharedObject;
- (bool)isValid;
- (void)authFacebook;
- (id)objectForKey:(id)key;
- (void)logonServer;
- (void)updateChallengeSenderList;

@end
