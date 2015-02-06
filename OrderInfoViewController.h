//
//  OrderInfoViewController.h
//  KaKa_Pw
//
//  Created by Plizarwireless on 15/1/14.
//  Copyright (c) 2015年 Plizarwireless. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderInfoViewController : UIViewController

@property (nonatomic,copy)NSString *allMoney;

@property (nonatomic,copy)NSString *memberPhone;
@property (nonatomic,copy)NSString *memberName;
@property (nonatomic,copy)NSString *memberAddress;
@property (nonatomic,copy)NSString *remark;
@property (nonatomic,strong)NSMutableArray *commodityArr;
@end
