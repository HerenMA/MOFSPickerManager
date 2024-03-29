//
//  MOFSDatePicker.m
//  MOFSPickerManager
//
//  Created by luoyuan on 16/8/26.
//  Copyright © 2016年 luoyuan. All rights reserved.
//

#import "MOFSDatePicker.h"

#define UISCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define UISCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

/// iPhone X / iPhone XS / iPhone XR / iPhone 11 / iPhone 12
#define HR_iPhoneX (@available(iOS 11.0, *) ? [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.f ? YES : NO : NO)
/// Tabbar safe bottom margin.
#define HR_TabbarSafeBottomMargin (HR_iPhoneX ? 34.f : 0.f)

@interface MOFSDatePicker()

@property (nonatomic, strong) NSMutableDictionary *recordDic;
@property (nonatomic, strong) UIView *bgView;

@end


@implementation MOFSDatePicker

- (NSMutableDictionary *)recordDic {
    if (!_recordDic) {
        _recordDic = [NSMutableDictionary dictionary];
    }
    return _recordDic;
}

#pragma mark - create UI

- (instancetype)initWithFrame:(CGRect)frame {
    [self initToolBar];
    [self initContainerView];
    
    CGRect initialFrame;
    if (CGRectIsEmpty(frame)) {
        initialFrame = CGRectMake(0, self.toolBar.frame.size.height, UISCREEN_WIDTH, 216);
    } else {
        initialFrame = frame;
    }
    self = [super initWithFrame:initialFrame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.datePickerMode = UIDatePickerModeDate;
        if (@available(iOS 13.4, *)) {
            self.preferredDatePickerStyle = UIDatePickerStyleWheels;
        } else {
            // Fallback on earlier versions
        }
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        [self initBgView];
    }
    return self;
}

- (void)initToolBar {
    self.toolBar = [[MOFSToolbar alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 44)];
    self.toolBar.translucent = NO;
}

- (void)initContainerView {
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT)];
    self.containerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    // self.containerView.userInteractionEnabled = YES;
    // [self.containerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenWithAnimation)]];
}

- (void)initBgView {
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, UISCREEN_HEIGHT - self.frame.size.height - HR_TabbarSafeBottomMargin - 44, UISCREEN_WIDTH, self.frame.size.height + HR_TabbarSafeBottomMargin + self.toolBar.frame.size.height)];
    self.bgView.backgroundColor = [UIColor whiteColor];
}

#pragma mark - Action

- (void)showMOFSDatePickerViewWithTag:(NSInteger)tag firstDate:(NSDate *)date commit:(CommitBlock)commitBlock cancel:(CancelBlock)cancelBlock {
    
     NSString *showtagStr = [NSString stringWithFormat:@"%ld",(long)tag];
    
    /*
    if ([self.recordDic.allKeys containsObject:showtagStr]) {
        NSDate *date1 = self.recordDic[showtagStr][showtagStr];
        self.date = date1;
    } else {*/
        if (date) {
            self.date = date;
        } else {
            self.date = [NSDate date];
        }
    // }
    
    [self showWithAnimation];
    __weak __typeof(self) weakSelf = self;
    
    self.toolBar.cancelBlock = ^{
        [weakSelf hiddenWithAnimation];
        if (cancelBlock) {
            cancelBlock();
        }
    };
    
    self.toolBar.commitBlock = ^{
       
        NSDictionary *dic = [NSDictionary dictionaryWithObject:weakSelf.date forKey:showtagStr];
        [weakSelf.recordDic setValue:dic forKey:showtagStr];
        
        [weakSelf hiddenWithAnimation];
        if (commitBlock) {
            commitBlock(weakSelf.date);
        }
    };

}

- (void)showWithAnimation {
    [self addViews];
    self.containerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    CGFloat height = self.bgView.frame.size.height;
    self.bgView.center = CGPointMake(UISCREEN_WIDTH / 2, UISCREEN_HEIGHT + height / 2);
    [UIView animateWithDuration:0.25 animations:^{
        self.bgView.center = CGPointMake(UISCREEN_WIDTH / 2, UISCREEN_HEIGHT - height / 2);
        self.containerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    }];
    
}

- (void)hiddenWithAnimation {
    CGFloat height = self.bgView.frame.size.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.bgView.center = CGPointMake(UISCREEN_WIDTH / 2, UISCREEN_HEIGHT + height / 2);
        self.containerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    } completion:^(BOOL finished) {
        [self hiddenViews];
    }];
}

- (void)addViews {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.containerView];
    [window addSubview:self.bgView];
    [self.bgView addSubview:self.toolBar];
    
    [self sizeToFit];
    CGRect initialFrame = self.frame;
    initialFrame.origin.x = (self.bgView.frame.size.width - initialFrame.size.width) / 2.0;
    self.frame = initialFrame;
    [self.bgView addSubview:self];
}

- (void)hiddenViews {
    [self removeFromSuperview];
    [self.toolBar removeFromSuperview];
    [self.bgView removeFromSuperview];
    [self.containerView removeFromSuperview];
}


@end
