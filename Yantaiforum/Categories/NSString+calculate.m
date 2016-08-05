//
//  NSString+calculate.m
//  Yantaiforum
//
//  Created by sunxb on 16/8/5.
//  Copyright © 2016年 sunxb. All rights reserved.
//

#import "NSString+calculate.h"

@implementation NSString (calculate)

+ (CGSize)calculateStringSize:(NSString *)string font:(UIFont *)font constranedToSize:(CGSize)size {
    return [string sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
}

@end
