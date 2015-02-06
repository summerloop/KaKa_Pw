//
//  HomeCell.m
//  KaKa
//
//  Created by Plizarwireless on 14/12/10.
//  Copyright (c) 2014年 Plizarwireless. All rights reserved.
//

#import "HomeCell.h"
#import "UIImageView+AFNetworking.h"
//#import "UIImageView+WebCache.h"
@implementation HomeCell


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setFmodel:(FoodModel *)fmodel
{

   
    _fmodel = fmodel;
    
    _nameLabel.text = fmodel.commodityName;
    
    _combinationLabel.text = fmodel.combination;
    
    _priceLabel.text = [NSString stringWithFormat:@"￥%@元/份",fmodel.price];
    
    
//    [_ImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://wx.dearkaka.com/kaka/%@",fmodel.showImg]]];
//
//    [_ImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://wx.dearkaka.com/kaka/%@",fmodel.showImg]] placeholderImage:[UIImage imageNamed:@"7"]];
    
//    NSData *imageData = UIImageJPEGRepresentation([UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://wx.dearkaka.com/kaka/%@",fmodel.showImg]]]], 0.5);  http://115.29.141.254/%@
    


    


}


@end
