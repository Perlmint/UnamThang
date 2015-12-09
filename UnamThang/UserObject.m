//
//  UserObject.m
//  UnamThang
//
//  Created by omniavinco on 12. 7. 3..
//  Copyright (c) 2012년 omniavinco. All rights reserved.
//

#import "UserObject.h"
#import "Lib/JSON/SBJson.h"
#import "Constant.h"

@implementation UserObject

@synthesize fb, score = score_, friendList, friendUsingAppList, currentGame, challengeSenderList;

+ (UserObject *)sharedObject
{
    static UserObject *obj = nil;
    
    if (obj == nil) {
        obj = [[UserObject alloc] init];
    }
    
    return obj;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        // Facebook
        NSString *accessToken = [defaults objectForKey:@"fbAccessToken"];
        userDataDictionary = [defaults objectForKey:@"userData"];
        currentGame = [[NSMutableDictionary alloc] init];
        if (userDataDictionary == nil) {
            userDataDictionary = [[NSMutableDictionary alloc] init];
        }
        
        fb = [[Facebook alloc] initWithAppId:FB_APP_ID andDelegate:self];
        fb.accessToken = accessToken;
        fb.expirationDate = [defaults objectForKey:@"fbExpirationDate"];
        
        if (accessToken) {
            [self updateUserInfo];
            [self updateFriendList];
        }
    }
    
    return self;
}

- (bool)isValid
{
    return fb.isSessionValid;
}

- (void)authFacebook
{
    [fb authorize:[NSArray arrayWithObjects:@"offline_access",nil]];
}

- (id)objectForKey:(id)key
{
    return [userDataDictionary objectForKey:key];
}

#pragma mark - update data

- (void)updateFriendList
{
    [self fqlQuery:@"SELECT name,uid,pic_square,is_app_user FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1 = me())" withKey:@"1"];
}

- (void)updateUserInfo
{
    [self fqlQuery:@"SELECT uid,pic_square,name FROM user WHERE uid = me()" withKey:@"0"];
}

- (void)updateChallengeSenderList
{
    NSError *error = nil;
    NSString *recivedSenderList = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/getChallengeList.php?uid=%@", SERVER_HOST, [userDataDictionary objectForKey:@"uid"]]] encoding:NSUTF8StringEncoding error:&error];
    
    if (recivedSenderList) {
        challengeSenderList = [NSMutableArray arrayWithArray:[recivedSenderList.JSONValue
                                                              sortedArrayUsingComparator:
                                                              ^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
                                                                return [(NSString *)[obj1 objectForKey:@"uid"] compare:[obj2 objectForKey:@"uid"]];
                                                            }]];
        for (NSInteger i = 0, size = challengeSenderList.count; i < size; ++i) {
            [challengeSenderList replaceObjectAtIndex:i withObject:[NSMutableDictionary dictionaryWithDictionary:[challengeSenderList objectAtIndex:i]]];
        }
        NSMutableArray *uidList = [NSMutableArray arrayWithCapacity:challengeSenderList.count];
        for (NSDictionary *item in challengeSenderList) {
            [uidList addObject:[item objectForKey:@"uid"]];
        }
        
        [self fqlQuery:[NSString stringWithFormat:@"SELECT name,uid,pic_square FROM user WHERE uid IN (%@)", [uidList componentsJoinedByString:@","]] withKey:@"2"];
    }
}

#pragma mark - facebook

- (void)fqlQuery:(NSString *)query withKey:(NSString *)key
{
    [fb requestWithMethodName:@"fql.query" andParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:query, @"query", key, @"tag", nil] andHttpMethod:@"GET" andDelegate:self];
}

- (void)fbDidLogin
{
    [self updateUserInfo];
    [self updateFriendList];
}

- (void)fbDidLogout
{
    
}

- (void)fbDidNotLogin:(BOOL)cancelled
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"fbAuthFailed" object:nil];
}

- (void)fbSessionInvalidated
{
    
}

- (void)fbDidExtendToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt
{
    fb.accessToken = accessToken;
    [self saveData];
    [self updateFriendList];
}

- (void)request:(FBRequest *)request didLoad:(id)result
{
    NSString *tag = [request.params objectForKey:@"tag"];
    if ([tag isEqualToString:@"0"]) {
        // UserInfo
        if ([result count] > 0) {
            [userDataDictionary setObject:[[result objectAtIndex:0] objectForKey:@"name"] forKey:@"name"];
            [userDataDictionary setObject:[[result objectAtIndex:0] objectForKey:@"uid"] forKey:@"uid"];
            [userDataDictionary setObject:[[result objectAtIndex:0] objectForKey:@"pic_square"] forKey:@"pic_square"];
            [self saveData];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"fbAuthSuccess" object:nil];
        }
        else
            [[NSNotificationCenter defaultCenter] postNotificationName:@"fbAuthFailed" object:nil];
    }
    else if([tag isEqualToString:@"2"])
    {
        NSArray *array = [result sortedArrayUsingComparator:
                       ^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
                           return [(NSString *)[obj1 objectForKey:@"uid"] compare:[obj2 objectForKey:@"uid"]];
                       }];
        NSEnumerator *newEnumerator = [array objectEnumerator];
        NSEnumerator *oldEnumerator = [challengeSenderList objectEnumerator];
        NSMutableDictionary *dict = nil, *dict2 = nil;
        while (dict = [oldEnumerator nextObject])
        {
            if (dict2 == nil || ![[dict objectForKey:@"uid"] isEqualToString:[NSString stringWithFormat:@"%@", [dict2 objectForKey:@"uid"]]]) {
                dict2 = [newEnumerator nextObject];
            }
            [dict setObject:[dict2 objectForKey:@"name"] forKey:@"name"];
            [dict setObject:[dict2 objectForKey:@"pic_square"] forKey:@"pic_square"];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"challengeSenderReciveSuccess" object:nil];
    }
    else if ([tag isEqualToString:@"1"])
    {
        // FriendList - sort recived list
        NSMutableArray *array = [NSMutableArray arrayWithArray:
                                 [result sortedArrayUsingComparator:
                                  ^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
                                      return [(NSString *)[obj1 objectForKey:@"name"] compare:[obj2 objectForKey:@"name"]];
                                  }]];
        
        // only app user
        friendUsingAppList = [[NSMutableArray alloc] init];
        friendList = [[NSMutableArray alloc] init];
        for (NSDictionary *friend in array) {
            if ([[friend objectForKey:@"is_app_user"] isEqualToNumber:[NSNumber numberWithInt:0]]) {
                [friendList addObject:friend];
            }
            else {
                [friendUsingAppList addObject:friend];
            }
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"fbFriendListRecived" object:nil];
    }
}

- (void)logonServer
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/login.php", SERVER_HOST]]];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [[NSString stringWithFormat:@"uid=%@", [userDataDictionary objectForKey:@"uid"]] dataUsingEncoding:NSUTF8StringEncoding];
    
    if ([NSURLConnection connectionWithRequest:request delegate:self]) {
        recivedData = [[NSMutableData alloc] init];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"logonFailed" object:nil];
    }
}

#pragma mark - URLConnection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [recivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *recivedString = [[NSString alloc] initWithData:recivedData encoding:NSUTF8StringEncoding];
    
    if (recivedString == nil || recivedString.length == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"logonFailed" object:nil];
        return;
    }
    
    score_ = [recivedString.JSONValue integerValue];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"logonSuccess" object:nil];
}

#pragma mark - Save Data

// TODO: #1 send score to server
- (void)setScore:(NSUInteger)score
{
    // TODO #1
}

- (void)saveData
{
    [[NSUserDefaults standardUserDefaults] setObject:fb.accessToken forKey:@"fbAccessToken"];
    [[NSUserDefaults standardUserDefaults] setObject:fb.expirationDate forKey:@"fbExpirationDate"];
    [[NSUserDefaults standardUserDefaults] setObject:userDataDictionary forKey:@"userData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
