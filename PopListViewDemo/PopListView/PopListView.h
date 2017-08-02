//
//  PopListView.h
//  PopListView
//
//  Created by *** on 2017/7/31.
//  Copyright © 2017年 yuanfang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PopViewListButtonStyle) {
    PopViewListButtonStyleSureAndCancel,
    PopViewListButtonStyleSure,
    PopViewListButtonStyleCancel
};

typedef NS_ENUM(NSInteger, PopViewListSelectStyle) {
    PopViewListSelectStyleNone,
    PopViewListSelectStyleLeft,
    PopViewListSelectStyleRight
};

@protocol PopListViewDelegate <NSObject>

- (void)sureButtonActionIndex:(NSInteger)index;

@optional
-(void)cancelButtonActionIndex:(NSInteger)index;

@end

@interface PopListView : UIView

@property (nonatomic, assign) id<PopListViewDelegate> delegate;
@property (nonatomic, copy) NSString *titleString;//标题
@property (nonatomic, copy) NSString *sureString;//确认按钮标题
@property (nonatomic, copy) NSString *cancelString;//取消按钮标题
@property (nonatomic, copy) NSString *sureImage;//确认按钮背景图
@property (nonatomic, copy) NSString *cancelImage;//取消按钮背景图
@property (nonatomic, copy) NSString *selectImage;//单选选中按钮图
@property (nonatomic, copy) NSString *unselectImage;//单选非选中按钮图
@property (nonatomic, copy) UIColor *surebackgroundColor;//确认按钮背景颜色
@property (nonatomic, copy) UIColor *cancelbackgroundColor;//取消按钮背景颜色
@property (nonatomic, copy) UIColor *sureTitleColor;//确认按钮标题颜色
@property (nonatomic, copy) UIColor *cancelTitleColor;//取消按钮钮标颜色
@property (nonatomic, strong) NSArray *listArray;//数据列表
@property (nonatomic, assign) PopViewListSelectStyle selectStyle;//单选图片的布局
@property (nonatomic, assign) PopViewListButtonStyle buttonStyle;//确定取消按钮布局

/**
 初始化

 @param title 标题
 @param listArray 数据
 @param selectStyle //确定取消按钮
 @return return value description
 */
- (instancetype)initWithTitle:(NSString *)title listArray:(NSArray *)listArray selectStyle:(PopViewListSelectStyle)selectStyle;

/**
 弹出

 @param view 所在的视图
 */
- (void)showInView:(UIView *)view;

@end
