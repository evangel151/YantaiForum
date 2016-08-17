//
//  WeatherView.m
//  Yantaiforum
//
//  Created by sunxb on 16/8/17.
//  Copyright © 2016年 sunxb. All rights reserved.
//

#import "WeatherView.h"

#define weatherButtonWidth (__Screen_Width-30*4)/3.0

@implementation WeatherView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.hidden = YES;
        [self loadWeatherUI];
    }
    return self;
}

- (void)loadWeatherUI {
//    UIImageView * numImgA = [[UIImageView alloc] initWithFrame:CGRectMake(20, 40, 40, 80)];
//    UIImageView * numImgB = [[UIImageView alloc] initWithFrame:CGRectMake(70, 40, 40, 80)];
//    
//    [self addSubview:numImgA];
//    [self addSubview:numImgB];
//    
//    UILabel * tempLbl = [[UILabel alloc] initWithFrame:CGRectMake(115, 100, 50, 20)];
//    tempLbl.font = Font12;
//    [self addSubview:tempLbl];
//    
//    UILabel * timeLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(numImgA.frame)+5, 100, 20)];
//    timeLbl.font = Font12;
//    [self addSubview:timeLbl];
//    
//    UILabel * pmLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(timeLbl.frame)+5, 100, 20)];
//    pmLbl.font = Font12;
//    [self addSubview:pmLbl];
//    
//    UIImageView * weatherImg = [[UIImageView alloc] initWithFrame:CGRectMake(__Screen_Width-50, 60, 40, 40)];
//    [self addSubview:weatherImg];
//    
//    UILabel * weatherLbl = [[UILabel alloc] initWithFrame:CGRectMake(__Screen_Width-50, CGRectGetMaxY(weatherImg.frame)+5, 50, 20)];
//    weatherLbl.font = Font12;
//    [self addSubview:weatherLbl];
//    
//    UILabel * cityLbl = [[UILabel alloc] initWithFrame:CGRectMake(__Screen_Width-50, CGRectGetMaxY(weatherLbl.frame)+5, 50, 20)];
//    cityLbl.font = Font12;
//    [self addSubview:cityLbl];
    
    for (int i = 0; i < 6; i ++) {
        NSInteger col = i / 3;
        NSInteger row = i % 3;
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.adjustsImageWhenHighlighted = NO;
        btn.tag = 1000+i;
        btn.frame = CGRectMake(30+(weatherButtonWidth+30)*row, 200+(weatherButtonWidth+30)*col, weatherButtonWidth, weatherButtonWidth);
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"weather_%d",i]] forState:UIControlStateNormal];
        [self addSubview:btn];
    }
    
    
}

- (void)weatherViewShow {
    self.hidden = NO;
    self.alpha = 1.0;
    [UIView animateWithDuration:0.18 animations:^{
        for (UIButton * button in self.subviews) {
            button.transform = CGAffineTransformMakeScale(1.2, 1.2);
        }
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.18 animations:^{
            for (UIButton * button in self.subviews) {
                button.transform = CGAffineTransformMakeScale(1.0, 1.0);
            }
        }];
        
    }];
    
}

- (void)wearherViewHidden {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.1;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
