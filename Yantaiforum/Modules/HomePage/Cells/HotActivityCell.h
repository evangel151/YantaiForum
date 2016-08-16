//
//  HotActivityCell.h
//  Yantaiforum
//
//  Created by sunxb on 16/8/16.
//  Copyright © 2016年 sunxb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mod_HotActivity.h"

@interface HotActivityCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *rootView;
@property (weak, nonatomic) IBOutlet UILabel *mainTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mainImg;
@property (weak, nonatomic) IBOutlet UILabel *intersetedNumLbl;
@property (weak, nonatomic) IBOutlet UILabel *stateTipLable;
@property (weak, nonatomic) IBOutlet UIButton *checkMoreBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic,strong) mod_hotActivityList * model;

@end
