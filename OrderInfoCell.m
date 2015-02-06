//
//  OrderInfoCell.m
//  KaKa_Pw
//
//  Created by Plizarwireless on 15/1/14.
//  Copyright (c) 2015年 Plizarwireless. All rights reserved.
//

#import "OrderInfoCell.h"

@implementation OrderInfoCell
{

    __weak IBOutlet UILabel *NameLabel;

    __weak IBOutlet UILabel *priceLabel;

    __weak IBOutlet UILabel *numLabel;

}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setInfoModel:(OrderInfoModel *)infoModel
{

    _infoModel = infoModel;
    
    NameLabel.text = infoModel.commodityName;
    priceLabel.text = [NSString stringWithFormat:@"%i元/份",[infoModel.allPrice intValue]];
    numLabel.text = [NSString stringWithFormat:@"%i份",[infoModel.num intValue]];
    



}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
