//
//  DetailCell2.h
//  KaKa
//
//  Created by Plizarwireless on 14/12/11.
//  Copyright (c) 2014年 Plizarwireless. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodModel.h"


@interface DetailCell2 : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *fiber;
@property (weak, nonatomic) IBOutlet UILabel *protein;
@property (weak, nonatomic) IBOutlet UILabel *va;
@property (weak, nonatomic) IBOutlet UILabel *vc;
@property (weak, nonatomic) IBOutlet UILabel *ve;
@property (weak, nonatomic) IBOutlet UILabel *mg;

@property (weak, nonatomic) IBOutlet UILabel *ca;
@property (weak, nonatomic) IBOutlet UILabel *fe;
@property (weak, nonatomic) IBOutlet UILabel *zn;
@property (weak, nonatomic) IBOutlet UILabel *k;

//详细描述内容
//@property (weak, nonatomic) IBOutlet  UILabel *bewrite;


//详细描述说明栏
@property (weak, nonatomic) IBOutlet UILabel *headWrite;

@property (nonatomic,strong)FoodModel *fmodel;
@end
