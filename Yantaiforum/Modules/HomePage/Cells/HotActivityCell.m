//
//  HotActivityCell.m
//  Yantaiforum
//
//  Created by sunxb on 16/8/16.
//  Copyright © 2016年 sunxb. All rights reserved.
//

#import "HotActivityCell.h"


@implementation HotActivityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.rootView.backgroundColor = [UIColor whiteColor];
    self.rootView.layer.masksToBounds = YES;
    self.rootView.layer.cornerRadius = 3.0;
    
    [self.checkMoreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.checkMoreBtn.backgroundColor = color(0, 140, 186);
    self.checkMoreBtn.layer.cornerRadius = 3.0f;
    self.checkMoreBtn.layer.masksToBounds = YES;
    
    self.stateTipLable.textColor = [UIColor whiteColor];
    self.stateTipLable.textAlignment = NSTextAlignmentCenter;
    // 右侧圆角
    CGRect rect = CGRectMake(0, 0, 55, 15);
    CGSize radio = CGSizeMake(7.5, 7.5);//圆角尺寸
    UIRectCorner corner = UIRectCornerTopRight|UIRectCornerBottomRight;//这只圆角位置
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corner cornerRadii:radio];
    CAShapeLayer * masklayer = [[CAShapeLayer alloc]init];//创建shapelayer
    masklayer.frame = self.stateTipLable.bounds;
    masklayer.path = path.CGPath;//设置路径
    self.stateTipLable.layer.mask = masklayer;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(mod_hotActivityList *)model {
    _model = model;
    
    self.mainTitleLabel.text = model.title;
    [self.mainImg sd_setImageWithURL:[NSURL URLWithString:model.picurl]];
    self.intersetedNumLbl.text = [NSString stringWithFormat:@"已经有%ld人感兴趣",model.member];
    self.stateTipLable.text = model.activitystatus;
    if ([model.activitystatus isEqualToString:@"正在进行"]) {
        self.stateTipLable.backgroundColor = color(252, 193, 87);
    }
    else if ([model.activitystatus isEqualToString:@"已经结束"]) {
        self.stateTipLable.backgroundColor = [UIColor lightGrayColor];
    }
    self.timeLabel.text = [NSString stringWithFormat:@"%@~%@",[self timeTransform:model.startdate],[self timeTransform:model.enddate]];
    
}

- (NSString *)timeTransform:(NSString *)_time {
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[_time longLongValue]];
    return [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
}

@end
