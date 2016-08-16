//
//  HotActivityView.m
//  Yantaiforum
//
//  Created by sunxb on 16/8/16.
//  Copyright © 2016年 sunxb. All rights reserved.
//

#import "HotActivityView.h"
#import "MJPullTableView.h"
#import "HotActivityCell.h"

@interface HotActivityView()<UITableViewDelegate,UITableViewDataSource>
{
    MJPullTableView * rootTableView;
}
@end

@implementation HotActivityView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addTableView];
    }
    return self;
}

- (void)addTableView {
    rootTableView = [[MJPullTableView alloc] initWithFrame:self.bounds];
    rootTableView.backgroundColor = color(239, 239, 239);
    rootTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    rootTableView.delegate = self;
    rootTableView.dataSource = self;
    [self addSubview:rootTableView];
}

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
}

- (void)loadHotActivityView {
    [rootTableView reloadData];
}

#pragma mark delegate & dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellID = @"hotActivityCell";
    HotActivityCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HotActivityCell" owner:self options:nil] firstObject];
    }
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return __Screen_Width/(375*1.0/200);
}

@end
