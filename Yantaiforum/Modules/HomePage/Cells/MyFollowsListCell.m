//
//  MyFollowsListCell.m
//  Yantaiforum
//
//  Created by sunxb on 16/7/27.
//  Copyright © 2016年 sunxb. All rights reserved.
//

#import "MyFollowsListCell.h"

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
        
    }
    return self;
}

- (void)setCellModel:(Mod_MyFollowsList *)cellModel {
    _cellModel = cellModel;
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:cellModel.faceurl]];
    self.nameLabel.text = cellModel.username;
    self.timeLabel.text = cellModel.tips;
    self.fromLabel.text = cellModel.source;
    
    
    [self loadContentAndComment];// 加载内容区和评论区
}


- (void)loadContentAndComment {
    contentView = [[UIView alloc] init];
    
    CGFloat totalHeight = 0.0;
    NSString * titleStr = self.cellModel.title;
    NSString * desStr = self.cellModel.des;
    
    titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
    desLbl = [[UILabel alloc] initWithFrame:CGRectZero];
    
    CGFloat picStartY = 0;
    
    if (titleStr.length != 0) {
        CGSize ksize = [titleStr sizeWithFont:Font13 constrainedToSize:CGSizeMake(__Screen_Width-55-10, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        totalHeight = ksize.height;
        titleLbl.frame = CGRectMake(0, 0, __Screen_Width-55-10, ksize.height);
        titleLbl.numberOfLines = 0;
        titleLbl.font = Font13;
        titleLbl.text  = titleStr;
        [contentView addSubview:titleLbl];
        
        picStartY = ksize.height;
        
    }
    if (desStr.length != 0) {
        CGSize ksize = [self.cellModel.des sizeWithFont:Font13 constrainedToSize:CGSizeMake(__Screen_Width-55-10, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        totalHeight += ksize.height;
        
        desLbl.frame = CGRectMake(0, CGRectGetMaxY(titleLbl.frame), __Screen_Width-55-10, ksize.height);
        desLbl.numberOfLines = 0;
        desLbl.font = Font13;
        desLbl.text  = desStr;
        [contentView addSubview:desLbl];
        
        picStartY += ksize.height;
        
    }
    if (!(desStr.length!=0&&titleStr.length!=0)) {
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
            totalHeight += picHeight;
            
        }
        if (self.cellModel.slidepicurlcount == 2) {
            CGFloat picHeight = (__Screen_Width-55-10-5)/2.0;// 宽高相同
            totalHeight += picHeight;
            for (int i = 0; i < self.cellModel.slidepicurl.count; i ++) {
                Mod_MyFollowsSlidepicurl * picMod = self.cellModel.slidepicurl[i];
                UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i*(5+picHeight), picStartY, picHeight, picHeight)];
                [imgView sd_setImageWithURL:[NSURL URLWithString:picMod.tburl]];
                [contentView addSubview:imgView];
            }
        }
        if (self.cellModel.slidepicurlcount >= 3 && self.cellModel.slidepicurlcount <= 9) {
            CGFloat imgWidth = (__Screen_Width-55-10-10)/3.0;
            NSInteger rowNum = ceil(self.cellModel.slidepicurlcount/3.0);
            totalHeight += (imgWidth+(rowNum-1)*(imgWidth+5));
            
            for (int i = 0; i < self.cellModel.slidepicurl.count; i ++) {
                NSInteger row = i / 3;
                NSInteger col = i % 3;
                Mod_MyFollowsSlidepicurl * picMod = self.cellModel.slidepicurl[i];
                UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(col*(5+imgWidth), picStartY+row*(imgWidth+5), imgWidth, imgWidth)];
                [imgView sd_setImageWithURL:[NSURL URLWithString:picMod.tburl]];
                [contentView addSubview:imgView];
            }
        }
        
    }
    
    contentView.frame = CGRectMake(55, CGRectGetMaxY(self.timeLabel.frame), __Screen_Width-55-10, totalHeight);
    [self.contentView addSubview:contentView];
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
