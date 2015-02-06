//
//  DetailCell1TableViewCell.h
//  KaKa
//
//  Created by Plizarwireless on 14/12/11.
//  Copyright (c) 2014年 Plizarwireless. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodModel.h"
#import "commodityModel.h"
#import "UIPopoverListView.h"

typedef void (^MyBlock)(commodityModel *cmodel);


@interface DetailCell1TableViewCell : UITableViewCell<UIPopoverListViewDataSource,UIPopoverListViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *ImgView;

@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *heat;


@property (weak, nonatomic) IBOutlet UILabel *chooseLabel;


@property (nonatomic,copy) MyBlock myBlock;


@property (nonatomic,strong)FoodModel *fmodel;
@end
