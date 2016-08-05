//
//  MyFollowsListCell.m
//  Yantaiforum
//
//  Created by sunxb on 16/7/27.
//  Copyright © 2016年 sunxb. All rights reserved.
//

#import "MyFollowsListCell.h"
#import "NSString+calculate.h"

@interface MyFollowsListCell ()
{
    UIView * contentView;
    UILabel * titleLbl;
    UILabel * desLbl;
}
@end

@implementation MyFollowsListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setCellModel:(Mod_MyFollowsList *)cellModel {
    _cellModel = cellModel;
//    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:cellModel.faceurl]];
//    self.nameLabel.text = cellModel.username;
//    self.timeLabel.text = cellModel.tips;
//    self.fromLabel.text = cellModel.source;
    
    
    [self loadContentAndComment];// 加载内容区和评论区
}


- (void)loadContentAndComment {
    
    UIImageView * icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    icon.layer.cornerRadius = 20.0f;
    icon.layer.masksToBounds = YES;
    [icon sd_setImageWithURL:[NSURL URLWithString:self.cellModel.faceurl] placeholderImage:[UIImage imageNamed:@"pic_share_detail_null"]];
    [self.contentView addSubview:icon];
    
    CGFloat fromLabelWidth;
    CGFloat nameLabelWidth;
    CGFloat sexImgWidth = 15.0;
    
    UILabel * fromLabel = [[UILabel alloc] init];
    fromLabel.font = Font13;
    fromLabel.text = self.cellModel.source;
    fromLabel.textColor = color_717171;
    CGSize fromLabelSize = [NSString calculateStringSize:self.cellModel.source font:Font13 constranedToSize:CGSizeMake(MAXFLOAT, 20)];
    fromLabelWidth = fromLabelSize.width;
    fromLabel.frame = CGRectMake(__Screen_Width-10-fromLabelWidth, 10, fromLabelWidth, 20);
    [self.contentView addSubview:fromLabel];
    
    
    nameLabelWidth = [NSString calculateStringSize:self.cellModel.username font:Font15 constranedToSize:CGSizeMake(MAXFLOAT, 20)].width;
    if ((__Screen_Width-10-40-5-10-fromLabelWidth-5-10-5)>nameLabelWidth) {
        
    }
    else {
        nameLabelWidth = __Screen_Width-10-40-5-10-fromLabelWidth-5-sexImgWidth-5;
    }
    UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame)+5, 10, nameLabelWidth, 20)];
    nameLabel.text = self.cellModel.username;
    nameLabel.font = Font15;
    [self.contentView addSubview:nameLabel];
    
    
    UILabel * timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame)+5, CGRectGetMaxY(nameLabel.frame), __Screen_Width-70, 20)];
    timeLabel.text = self.cellModel.tips;
    timeLabel.font = Font13;
    timeLabel.textColor = color_717171;
    [self.contentView addSubview:timeLabel];
    
    
 
    // 内容
    contentView = [[UIView alloc] init];
    
    CGFloat totalHeight = 0;
    NSString * titleStr = self.cellModel.title;
    NSString * desStr = self.cellModel.des;
    
    titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
    desLbl = [[UILabel alloc] initWithFrame:CGRectZero];
    
    CGFloat picStartY = 0;
    
    if (titleStr.length != 0 && desStr.length == 0) {
        CGSize ksize = [NSString calculateStringSize:titleStr font:Font13 constranedToSize:CGSizeMake(__Screen_Width-55-10, MAXFLOAT)];
//        totalHeight = ksize.height;
        titleLbl.frame = CGRectMake(0, 0, __Screen_Width-55-10, ksize.height);
        titleLbl.numberOfLines = 0;
        titleLbl.font = Font13;
        titleLbl.text  = titleStr;
        [contentView addSubview:titleLbl];
        
        picStartY = CGRectGetMaxY(titleLbl.frame);
        totalHeight = CGRectGetMaxY(titleLbl.frame);
        
    }
    if (desStr.length != 0 && titleStr.length == 0) {
        CGSize ksize = [NSString calculateStringSize:self.cellModel.des font:Font13 constranedToSize:CGSizeMake(__Screen_Width-55-10, MAXFLOAT)];
//        totalHeight += ksize.height;
        
        desLbl.frame = CGRectMake(0, CGRectGetMaxY(titleLbl.frame), __Screen_Width-55-10, ksize.height);
        desLbl.numberOfLines = 0;
        desLbl.font = Font13;
        desLbl.text  = desStr;
        [contentView addSubview:desLbl];
        
        picStartY = CGRectGetMaxY(desLbl.frame);
        totalHeight = CGRectGetMaxY(desLbl.frame);
        
    }
    
    if (desStr.length!=0&&titleStr.length!=0) {
        CGSize ksize = [NSString calculateStringSize:titleStr font:Font13 constranedToSize:CGSizeMake(__Screen_Width-55-10, MAXFLOAT)];
        //        totalHeight = ksize.height;
        titleLbl.frame = CGRectMake(0, 0, __Screen_Width-55-10, ksize.height);
        titleLbl.numberOfLines = 0;
        titleLbl.font = Font13;
        titleLbl.text  = titleStr;
        [contentView addSubview:titleLbl];
        
        CGSize tsize = [NSString calculateStringSize:desStr font:Font13 constranedToSize:CGSizeMake(__Screen_Width-55-10, MAXFLOAT)];
        //        totalHeight += ksize.height;
        
        desLbl.frame = CGRectMake(0, CGRectGetMaxY(titleLbl.frame)+5, __Screen_Width-55-10, tsize.height);
        desLbl.numberOfLines = 0;
        desLbl.font = Font13;
        desLbl.text  = desStr;
        [contentView addSubview:desLbl];
        
        picStartY = CGRectGetMaxY(desLbl.frame);
        totalHeight = CGRectGetMaxY(desLbl.frame);
        
    }
    
    if (desStr.length==0&&titleStr.length==0) {
        
    }
    
    
    picStartY += 5;
    totalHeight += 5;
    
    // 计算图片
    if (self.cellModel.slidepicurlcount == 1) {
        Mod_MyFollowsSlidepicurl * picMod = self.cellModel.slidepicurl[0];
        CGFloat picHeight;
        CGFloat picWigth;
        if ([picMod.height isEqualToString:picMod.width]) {
            picWigth = (__Screen_Width-55-10);
            picHeight = picWigth;
        }
        else if (picMod.height.integerValue > picMod.width.integerValue){
            picWigth = (__Screen_Width-55-10)/2.0;
            picHeight = picWigth/(picMod.width.integerValue*1.0/picMod.height.integerValue);
        }
        else {
            picWigth = (__Screen_Width-55-10);
            picHeight = picWigth/(picMod.width.integerValue*1.0/picMod.height.integerValue);
        }
        UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, picStartY, picWigth, picHeight)];
        [imgView sd_setImageWithURL:[NSURL URLWithString:picMod.tburl]];
        [contentView addSubview:imgView];
        totalHeight += (picHeight+10);
        
    }
    if (self.cellModel.slidepicurlcount == 2) {
        CGFloat picHeight = (__Screen_Width-55-10-5)/2.0;// 宽高相同
        totalHeight += (picHeight+10);
        for (int i = 0; i < self.cellModel.slidepicurl.count; i ++) {
            Mod_MyFollowsSlidepicurl * picMod = self.cellModel.slidepicurl[i];
            UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i*(5+picHeight), picStartY, picHeight, picHeight)];
            [imgView sd_setImageWithURL:[NSURL URLWithString:picMod.tburl]];
            imgView.contentMode = UIViewContentModeScaleToFill;
            [contentView addSubview:imgView];
        }
    }
    if (self.cellModel.slidepicurlcount >= 3 && self.cellModel.slidepicurlcount <= 9) {
        CGFloat imgWidth = (__Screen_Width-55-10-10)/3.0;
        NSInteger rowNum = ceil(self.cellModel.slidepicurlcount/3.0);
        totalHeight += rowNum*(imgWidth+5);
        totalHeight += 5;
        
        for (int i = 0; i < self.cellModel.slidepicurl.count; i ++) {
            NSInteger row = i / 3;
            NSInteger col = i % 3;
            Mod_MyFollowsSlidepicurl * picMod = self.cellModel.slidepicurl[i];
            UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(col*(5+imgWidth), (picStartY)+row*(imgWidth+5), imgWidth, imgWidth)];
            [imgView sd_setImageWithURL:[NSURL URLWithString:picMod.tburl]];
            imgView.contentMode = UIViewContentModeScaleToFill;
            [contentView addSubview:imgView];
        }
    }
    
    contentView.frame = CGRectMake(55, 55, __Screen_Width-55-10, totalHeight);
    [self.contentView addSubview:contentView];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(contentView.frame)-1, __Screen_Width, 1)];
    lineView.backgroundColor = color_f0f0f0;
    [self.contentView addSubview:lineView];
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
