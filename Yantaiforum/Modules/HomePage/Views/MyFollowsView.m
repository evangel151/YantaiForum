//
//  MyFollowsView.m
//  Yantaiforum
//
//  Created by sunxb on 16/7/27.
//  Copyright © 2016年 sunxb. All rights reserved.
//

#import "MyFollowsView.h"
#import "MJPullTableView.h"
#import "MyFollowsListCell.h"

@interface MyFollowsView ()<UITableViewDelegate,UITableViewDataSource>
{
    MJPullTableView * rootTableView;
}
@end

@implementation MyFollowsView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addTableView];
    }
    return self;
}

- (void)followsViewLoadData {
    [rootTableView reloadData];
}

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
}

- (void)addTableView {
    rootTableView = [[MJPullTableView alloc] initWithFrame:self.bounds];
//    rootTableView.rowHeight = 200;
    rootTableView.delegate = self;
    rootTableView.dataSource = self;
    [self addSubview:rootTableView];
}

#pragma mark tableView delegate & dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellID = @"followListCellStyle1";
    MyFollowsListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [];
        
    }
    
    for (UIView * subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    cell.cellModel = self.dataArr[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self calculateContentHeight:self.dataArr[indexPath.row]]+50;
}

// 计算内容部分的高度
- (CGFloat)calculateContentHeight:(Mod_MyFollowsList *)cellModel {
    CGFloat totalHeight = 0.0;
    NSString * titleStr = cellModel.title;
    NSString * desStr = cellModel.des;
    if (titleStr.length != 0 && desStr.length == 0) {
        CGSize ksize = [titleStr sizeWithFont:Font13 constrainedToSize:CGSizeMake(__Screen_Width-55-10, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        totalHeight = ksize.height;
    }
    if (desStr.length != 0 && titleStr.length == 0 ) {
        CGSize ksize = [desStr sizeWithFont:Font13 constrainedToSize:CGSizeMake(__Screen_Width-55-10, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        totalHeight += ksize.height;
    }
    if (!(desStr.length!=0&&titleStr.length!=0)) {
        // 计算图片
        if (cellModel.slidepicurlcount == 1) {
            Mod_MyFollowsSlidepicurl * picMod = cellModel.slidepicurl[0];
            if ([picMod.height isEqualToString:picMod.width]) {
                totalHeight += (__Screen_Width-55-10);
            }
            else if (picMod.height.integerValue > picMod.width.integerValue){
                totalHeight += (__Screen_Width-55-10)/2.0/(picMod.width.integerValue*1.0/picMod.height.integerValue);
            }
            else {
                totalHeight += (__Screen_Width-55-10)/(picMod.width.integerValue*1.0/picMod.height.integerValue);
            }
            
        }
        if (cellModel.slidepicurlcount == 2) {
            totalHeight += (__Screen_Width-55-10-5)/2.0;
        }
        if (cellModel.slidepicurlcount >= 3 && cellModel.slidepicurlcount <= 9) {
            CGFloat imgWidth = (__Screen_Width-55-10-10)/3.0;
            NSInteger rowNum = ceil(cellModel.slidepicurlcount/3.0);
            totalHeight += (imgWidth+rowNum*(imgWidth+5));
        }
        
    }
    return totalHeight;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
