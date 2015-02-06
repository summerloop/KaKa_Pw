//
//  GridCell.h
//  KaKa_Pw
//
//  Created by Plizarwireless on 14/12/25.
//  Copyright (c) 2014年 Plizarwireless. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridFoodModel.h"


typedef void (^cellBlock)(int number);

@interface GridCell : UITableViewCell



@property (nonatomic,strong)GridFoodModel *gmodel;

@property (nonatomic,copy)cellBlock gCellBlock;
@end
