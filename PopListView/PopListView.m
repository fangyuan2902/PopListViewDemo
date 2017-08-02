//
//  PopListView.m
//  PopListView
//
//  Created by *** on 2017/7/31.
//  Copyright © 2017年 yuanfang. All rights reserved.
//

#import "PopListView.h"

@interface PopListView () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UIView *backGroundView;
@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *sureButton;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UILabel *titleLabel;
@property (assign, nonatomic) NSInteger selectIndex;

@end

@implementation PopListView

#pragma mark - event

- (void)sureAction {
    if ([self.delegate respondsToSelector:@selector(sureButtonActionIndex:)]) {
        [self.delegate sureButtonActionIndex:self.selectIndex];
    }
    [self dismissView];
}

- (void)cancelAction {
    if ([self.delegate respondsToSelector:@selector(cancelButtonActionIndex:)]) {
        [self.delegate cancelButtonActionIndex:self.selectIndex];
    }
    [self dismissView];
}

- (void)showInView:(UIView *)view {
    _containerView.frame = CGRectZero;
    [UIView animateWithDuration:0.8 animations:^{
        
    } completion:^(BOOL finished) {
        _containerView.frame = CGRectMake(50, 80, self.bounds.size.width - 100, self.bounds.size.height - 160);
        if (view) {
            [view addSubview:self];
        } else {
            [[UIApplication sharedApplication].keyWindow addSubview:self];
        }
    }];
}

- (void)dismissView {
    _containerView.frame = CGRectMake(50, 80, self.bounds.size.width - 100, self.bounds.size.height - 160);
    [UIView animateWithDuration:0.35 animations:^{
        
    } completion:^(BOOL finished) {
        _containerView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        [self removeFromSuperview];
    }];
}

#pragma mark - init

- (instancetype)initWithTitle:(NSString *)title listArray:(NSArray *)listArray selectStyle:(PopViewListSelectStyle)selectStyle {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        [self addSubview:self.backGroundView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView)];
        [self.backGroundView addGestureRecognizer:tap];
        
        self.selectStyle = selectStyle;
        [self addSubview:self.containerView];
        [self.containerView addSubview:self.tableView];
        [self.containerView addSubview:self.titleLabel];
        [self.containerView addSubview:self.sureButton];
        [self.containerView addSubview:self.cancelButton];
        self.titleString = title;
        self.listArray = listArray;
        _selectImage = @"images.bundle/select.png";
        _unselectImage = @"images.bundle/unselect.png";
        [self resetCancelButtonX:self.containerView.frame.size.width / 2 - 110 w:100];
        [self resetSureButtonX:self.containerView.frame.size.width / 2 + 10 w:100];
    }
    return self;
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifierString = @"";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierString];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierString];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, cell.contentView.frame.size.width, 0.5)];
        lineView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
        [cell.contentView addSubview:lineView];
        
        UIImageView *imagev = [[UIImageView alloc] init];
        imagev.tag = 10000;
        [cell.contentView addSubview:imagev];
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor blackColor];
        label.tag = 10001;
        [cell.contentView addSubview:label];
        
        if (self.selectStyle == PopViewListSelectStyleLeft) {
            imagev.frame = CGRectMake(5, 10, 20, 20);
            label.frame = CGRectMake(35, 10, 200, 20);
        } else if (self.selectStyle == PopViewListSelectStyleRight) {
            imagev.frame = CGRectMake(cell.contentView.frame.size.width - 35, 10, 20, 20);
            label.frame = CGRectMake(5, 10, 200, 20);
        } else {
            label.frame = CGRectMake(5, 10, 200, 20);
        }
        
    }
    UIImageView *imagev = [cell.contentView viewWithTag:10000];
    imagev.image = [UIImage imageNamed:self.unselectImage];
    
    UILabel *label = [cell.contentView viewWithTag:10001];
    label.text = [self.listArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView *imagev = [cell.contentView viewWithTag:10000];
    imagev.image = [UIImage imageNamed:self.selectImage];
    self.selectIndex = indexPath.row;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView *imagev = [cell.contentView viewWithTag:10000];
    imagev.image = [UIImage imageNamed:self.unselectImage];
}

#pragma mark - set method

- (void)setButtonStyle:(PopViewListButtonStyle)buttonStyle {
    self.sureButton.hidden = NO;
    self.cancelButton.hidden = NO;
    if (buttonStyle == PopViewListButtonStyleSure) {
        self.cancelButton.hidden = YES;
        [self resetSureButtonX:(self.containerView.frame.size.width - 100) / 2 w:100];
    } else if (buttonStyle == PopViewListButtonStyleCancel) {
        self.sureButton.hidden = YES;
        [self resetCancelButtonX:(self.containerView.frame.size.width - 100) / 2 w:100];
    } else {
        [self resetCancelButtonX:self.containerView.frame.size.width / 2 - 110 w:100];
        [self resetSureButtonX:self.containerView.frame.size.width / 2 + 10 w:100];
    }
}

- (void)resetSureButtonX:(float)x w:(float)w {
    self.sureButton.frame = CGRectMake(x, self.containerView.frame.size.height - 45, w, 35);
}

- (void)resetCancelButtonX:(float)x w:(float)w {
    self.cancelButton.frame = CGRectMake(x, self.containerView.frame.size.height - 45, w, 35);
}

- (void)setTitleString:(NSString *)titleString {
    self.titleLabel.text = titleString;
}

- (void)setListArray:(NSArray *)listArray {
    _listArray = listArray;
}

- (void)setSureImage:(NSString *)sureImage {
    [self.sureButton setBackgroundImage:[UIImage imageNamed:sureImage] forState:UIControlStateNormal];
}

- (void)setSureString:(NSString *)sureString {
    [self.sureButton setTitle:sureString forState:UIControlStateNormal];
}

- (void)setSurebackgroundColor:(UIColor *)surebackgroundColor {
    [self.sureButton setBackgroundColor:surebackgroundColor];
}

- (void)setSureTitleColor:(UIColor *)sureTitleColor {
    [self.sureButton setTitleColor:sureTitleColor forState:UIControlStateNormal];
}

- (void)setCancelImage:(NSString *)cancelImage {
    [self.cancelButton setBackgroundImage:[UIImage imageNamed:cancelImage] forState:UIControlStateNormal];
}

- (void)setCancelString:(NSString *)cancelString {
    [self.cancelButton setTitle:cancelString forState:UIControlStateNormal];
}

- (void)setCancelbackgroundColor:(UIColor *)cancelbackgroundColor {
    [self.cancelButton setBackgroundColor:cancelbackgroundColor];
}

- (void)setCancelTitleColor:(UIColor *)cancelTitleColor {
    [self.cancelButton setTitleColor:cancelTitleColor forState:UIControlStateNormal];
}

- (void)setSelectImage:(NSString *)selectImage {
    _selectImage = selectImage;
}

- (void)setUnselectImage:(NSString *)unselectImage {
    _unselectImage = unselectImage;
}

#pragma mark - init UI

- (UIView *)backGroundView {
    if (_backGroundView == nil) {
        _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _backGroundView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.8];
    }
    return _backGroundView;
}

- (UIView *)containerView {
    if (_containerView == nil) {
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(50, 80, self.bounds.size.width - 100, self.bounds.size.height - 160)];
        _containerView.layer.cornerRadius = 5;
        _containerView.layer.masksToBounds = YES;
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return _containerView;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, self.containerView.frame.size.width, self.containerView.frame.size.height - 95) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _tableView.frame.size.height - 0.5, self.containerView.frame.size.width, 0.5)];
        lineView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
        [_tableView addSubview:lineView];
    }
    return _tableView;
}

- (UIButton *)sureButton {
    if (_sureButton == nil) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_sureButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _sureButton.layer.cornerRadius = 5;
        _sureButton.layer.masksToBounds = YES;
        _sureButton.backgroundColor = [UIColor colorWithRed:0.9 green:0.1 blue:0.1 alpha:1.0];
        [_sureButton addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

- (UIButton *)cancelButton {
    if (_cancelButton == nil) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _cancelButton.layer.cornerRadius = 5;
        _cancelButton.layer.masksToBounds = YES;
        _cancelButton.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1.0];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.containerView.frame.size.width, 40)];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, self.containerView.frame.size.width, 0.5)];
        lineView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
        [_titleLabel addSubview:lineView];
    }
    return _titleLabel;
}

@end
