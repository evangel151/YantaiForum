//
//  HotActivityView.h
//  Yantaiforum
//
//  Created by sunxb on 16/8/16.
//  Copyright © 2016年 sunxb. All rights reserved.
//

#import "YTBaseView.h"

@interface HotActivityView : YTBaseView

@property (nonatomic,strong) NSArray * dataArr;

- (void)loadHotActivityView;
@end
