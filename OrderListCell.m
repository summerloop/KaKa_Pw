//
//  OrderListCell.m
//  KaKa_Pw
//
//  Created by Plizarwireless on 15/1/13.
//  Copyright (c) 2015年 Plizarwireless. All rights reserved.
//

#import "OrderListCell.h"


@implementation OrderListCell
{

    __weak IBOutlet UILabel *orderNumLabel;
    
    __weak IBOutlet UILabel *orderMoneyLabel;
    
    __weak IBOutlet UILabel *createDateLabel;

    __weak IBOutlet UILabel *orderStatusLabel;

}
- (void)awakeFromNib {
    // Initialization code
}



- (void)setListModel:(OrderListModel *)listModel
{


    _listModel = listModel;
    
    
    orderNumLabel.text = _listModel.orderNum;
    orderMoneyLabel.text = [NSString stringWithFormat:@"￥%i元",[_listModel.orderMoney intValue]];
    createDateLabel.text = _listModel.creadateDate;
    orderStatusLabel.text = _listModel.orderStatus;



}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
