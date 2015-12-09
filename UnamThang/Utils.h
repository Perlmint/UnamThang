//
//  NSObject_aaa.h
//  UnamThang
//
//  Created by omniavinco on 12. 7. 4..
//  Copyright (c) 2012년 omniavinco. All rights reserved.
//
#ifndef UnamThang_Utils_h
#define UnamThang_Utils_h

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

NSString *getInitials(NSString *str);
void playSound(SystemSoundID *audioEffect, NSString * fName, NSString * ext);

#endif