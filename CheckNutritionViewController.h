//
//  CheckNutritionViewController.h
//  KaKa_Pw
//
//  Created by Plizarwireless on 14/12/17.
//  Copyright (c) 2014年 Plizarwireless. All rights reserved.
//

#import <UIKit/UIKit.h>

//ios64位定义枚举方法  服用营养自测详情界面枚举类型
//typedef NS_ENUM(NSInteger, CheckViewStyle)
//{
//
//    CheckViewStyleShopCarScore,
//    CheckViewStyleCalendarScore,
//    CheckViewStyleTodayScore,
//    CheckViewStyleGridScore,
//    CheckViewStyleOrderScore
//
//};
@interface CheckNutritionViewController : UIViewController

@property (nonatomic,assign) int numberOfStyle;

//枚举类型本质是基本数据类型中得整数类型 不需要加星号
//@property (nonatomic,assign)CheckViewStyle style;


@property (nonatomic,strong)NSMutableArray *infoArray; //购物车界面进入需用

@property (nonatomic,strong)NSMutableArray *calenDarArray; //日历界面进入需用

@property (nonatomic,strong)NSMutableArray *TodayArray;  //今日卡卡分进入需用

//@property (nonatomic,assign) CGFloat totalHeat;   //日历界面进入用到

@property (nonatomic,strong)NSMutableArray *orderArray;  //订单页查看营养详情

@property (nonatomic,copy)NSString *memberId;

@end
