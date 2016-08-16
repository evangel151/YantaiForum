//
//  Mod_HotActivity.h
//  Yantaiforum
//
//  Created by sunxb on 16/8/16.
//  Copyright © 2016年 sunxb. All rights reserved.
//

#import "YTBaseModel.h"

@protocol mod_hotActivityList
@end

@interface mod_hotActivityList : YTBaseModel
@property (nonatomic,strong) NSString * id;
@property (nonatomic,strong) NSString * title;
@property (nonatomic,assign) NSInteger click;
@property (nonatomic,strong) NSString * pubdate;
@property (nonatomic,strong) NSString * status;
@property (nonatomic,strong) NSString * startdate;
@property (nonatomic,strong) NSString * enddate;
@property (nonatomic,strong) NSString * activitystatus;
@property (nonatomic,assign) NSInteger activitystatustype;
@property (nonatomic,strong) NSString * icon;
@property (nonatomic,strong) NSString * activitydate;
@property (nonatomic,strong) NSString * picurl;
@property (nonatomic,strong) NSString * address;
@property (nonatomic,assign) NSInteger member;
@property (nonatomic,strong) NSString * activity_url;
@property (nonatomic,strong) NSString * jump_url;

@end

@interface Mod_HotActivity : YTBaseModel
@property (nonatomic,strong) NSMutableArray <mod_hotActivityList> * list;
@end
