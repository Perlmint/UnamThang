//
//  NSObject_aaa.h
//  UnamThang
//
//  Created by omniavinco on 12. 7. 4..
//  Copyright (c) 2012년 omniavinco. All rights reserved.
//

#import "Utils.h"

NSString *getInitials(NSString *str)
{
    NSArray *cho = [[NSArray alloc] initWithObjects:@"ㄱ",@"ㄲ",@"ㄴ",@"ㄷ",@"ㄸ",@"ㄹ",@"ㅁ",@"ㅂ",@"ㅃ",@"ㅅ",@" ㅆ",@"ㅇ",@"ㅈ",@"ㅉ",@"ㅊ",@"ㅋ",@"ㅌ",@"ㅍ",@"ㅎ",nil];
    NSString *choString = [cho componentsJoinedByString:@""];
    
	NSMutableString *returnText = [[NSMutableString alloc] init];
    NSRange range;
    range.length = 1;
	for (int i=0;i<[str length];i++) {
        range.location = i;
		NSInteger code = [str characterAtIndex:i];
		if (code >= 44032 && code <= 55203) { // 한글영역에 대해서만 처리
			NSInteger UniCode = code - 44032; // 한글 시작영역을 제거
			NSInteger choIndex = UniCode/21/28; // 초성
            
			[returnText appendString:[cho objectAtIndex:choIndex]];
		}
        else if ([choString rangeOfString:[str substringWithRange:range]].location != NSNotFound)
        {
            [returnText appendString:[str substringWithRange:range]];
        }
	}
	return returnText;
}

void playSound(SystemSoundID *audioEffect, NSString * fName, NSString * ext)
{
    NSString *path  = [[NSBundle mainBundle] pathForResource : fName ofType :ext];
    if ([[NSFileManager defaultManager] fileExistsAtPath : path])
    {
        NSURL *pathURL = [NSURL fileURLWithPath : path];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef) pathURL, audioEffect);
        AudioServicesPlaySystemSound(*audioEffect);
    }
    else
    {
        NSLog(@"error, file not found: %@", path);
    }
}
