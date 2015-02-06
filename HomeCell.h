//
//  HomeCell.h
//  KaKa
//
//  Created by Plizarwireless on 14/12/10.
//  Copyright (c) 2014年 Plizarwireless. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodModel.h"
@interface HomeCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *ImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *combinationLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (nonatomic,strong) FoodModel *fmodel;
@end
