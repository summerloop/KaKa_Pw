//
//  BuyInfo.h
//  KaKa_Pw
//
//  Created by Plizarwireless on 14/12/18.
//  Copyright (c) 2014年 Plizarwireless. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FoodModel.h"
#import "commodityModel.h"
@interface BuyInfo : NSObject

@property (nonatomic,strong)FoodModel *fmodel;
@property (nonatomic,strong)commodityModel *cmodel;

@end
