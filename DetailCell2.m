//
//  DetailCell2.m
//  KaKa
//
//  Created by Plizarwireless on 14/12/11.
//  Copyright (c) 2014年 Plizarwireless. All rights reserved.
//

#import "DetailCell2.h"

@implementation DetailCell2
{

    UILabel *bewrite;
    
}
- (void)awakeFromNib {
   
    bewrite = [[UILabel alloc]init];
//    bewrite.frame = CGRectMake(8, 361, self.frame.size.width, _fmodel.bewriteHeight);
    
    
    
    

    [self addSubview:bewrite];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFmodel:(FoodModel *)fmodel
{

    _fmodel = fmodel;
    _fiber.text = [NSString stringWithFormat:@"%.1f",[_fmodel.fiber floatValue]];
    _protein.text = [NSString stringWithFormat:@"%.1f",[_fmodel.protein floatValue]];
    _va.text = [NSString stringWithFormat:@"%.1f",[_fmodel.va floatValue]];
    _vc.text = [NSString stringWithFormat:@"%.1f",[_fmodel.vc floatValue]];
    _ve.text = [NSString stringWithFormat:@"%.1f",[_fmodel.ve floatValue]];
    _mg.text = [NSString stringWithFormat:@"%.1f",[_fmodel.mg floatValue]];
    _ca.text = [NSString stringWithFormat:@"%.1f",[_fmodel.ca floatValue]];
    _fe.text = [NSString stringWithFormat:@"%.1f",[_fmodel.fe floatValue]];
    _zn.text = [NSString stringWithFormat:@"%.1f",[_fmodel.zn floatValue]];
    _k.text = [NSString stringWithFormat:@"%.1f",[_fmodel.k floatValue]];
    bewrite.text = _fmodel.bewrite;

//    NSArray *array = @[@"<font face=\"times new roman\">",@"</font>",@"<div>",@"</div>",@"<span style=\"font-size: 12px;\">",@"</span>",@"&nbsp;",@"<br>"];
//    NSString *s = _fmodel.bewrite;
//   
//
//    
//    for (int i=0; i<array.count; i++)
//    {
//        NSString *str = [s stringByReplacingOccurrencesOfString:array[i] withString:@""];
//        s = str;
//        
//
//    }
//    
//    bewrite.text = s;
    
    bewrite.lineBreakMode = NSLineBreakByWordWrapping;
    bewrite.font = [UIFont systemFontOfSize:14];
    bewrite.numberOfLines = 0;
    bewrite.lineBreakMode = NSLineBreakByWordWrapping;
    
    UIScreen *currentScreen = [UIScreen mainScreen];
//    currentScreen.bounds.size.width 当前屏幕的宽度
    bewrite.frame = CGRectMake(8, 353, currentScreen.bounds.size.width-16, _fmodel.bewriteHeight+20);
    bewrite.lineBreakMode = NSLineBreakByWordWrapping;
    
    if ([_fmodel.bewrite isEqualToString:@""])
    {
        
        _headWrite.hidden = YES;
    }
    
}
@end
