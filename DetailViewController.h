//
//  DetailViewController.h
//  KaKa
//
//  Created by Plizarwireless on 14/12/9.
//  Copyright (c) 2014年 Plizarwireless. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodModel.h"
#import "commodityModel.h"


@interface DetailViewController : UIViewController
@property (nonatomic,strong)FoodModel *fmodel;



+(NSMutableArray *)ShareMultArr;
@end
