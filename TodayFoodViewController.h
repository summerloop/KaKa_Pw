//
//  TodayFoodViewController.h
//  KaKa_Pw
//
//  Created by Plizarwireless on 14/12/25.
//  Copyright (c) 2014年 Plizarwireless. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GridFoodModel.h"
//typedef void (^checkBlock)(int numberOfStyle);
@interface TodayFoodViewController : UIViewController



//@property (nonatomic,copy)checkBlock cBlock;

+(NSMutableArray *)ShareMultArr;

@property (nonatomic,strong)NSMutableArray *todayArray;
@end
