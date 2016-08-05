//
//  NSString+calculate.h
//  Yantaiforum
//
//  Created by sunxb on 16/8/5.
//  Copyright © 2016年 sunxb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (calculate)

+ (CGSize)calculateStringSize:(NSString *)string font:(UIFont *)font constranedToSize:(CGSize)size;

@end
