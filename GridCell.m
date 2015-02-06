//
//  GridCell.m
//  KaKa_Pw
//
//  Created by Plizarwireless on 14/12/25.
//  Copyright (c) 2014年 Plizarwireless. All rights reserved.
//

#import "GridCell.h"

@implementation GridCell
{


    __weak IBOutlet UILabel *foodLabel;
  
   

    
    __weak IBOutlet UILabel *numberLabel;
    int number;
}
- (void)awakeFromNib {
    // Initialization code
    
    number = [numberLabel.text intValue];
    numberLabel.layer.cornerRadius = 5;
    numberLabel.clipsToBounds = YES;
//    NSLog(@"%i",number);
}

- (IBAction)reduceBtn:(id)sender
{
    

    number = [numberLabel.text intValue] -1;
    if (number>=0)
    {
        _gmodel.number = number;
        
        numberLabel.text = [NSString stringWithFormat:@"%i",number];
        
//        NSLog(@"===========%i",_gmodel.number);
    }
    
    
    else
    {
    
        number = 0;
        _gmodel.number = number;

    }
    
    if (_gmodel.number>0)
    {
        
//     NSLog(@"==========%i",_gmodel.number);
        if (_gCellBlock)
        {
            
            _gCellBlock(_gmodel.number);
        }
        
    }
}

- (IBAction)addBtn:(id)sender
{
    
    number = [numberLabel.text intValue] +1;
    if (number<=99)
    {
        numberLabel.text = [NSString stringWithFormat:@"%i",number];
     
        _gmodel.number = number;
    }
    else
    {
    
        number = 99;
        _gmodel.number = number;
    }

    if (_gmodel.number>0)
    {
        
        //     NSLog(@"==========%i",_gmodel.number);
        if (_gCellBlock)
        {
            
            _gCellBlock(_gmodel.number);
        }
        
    }

    
}

- (void)setGmodel:(GridFoodModel *)gmodel
{

    _gmodel = gmodel;
    
    foodLabel.text = gmodel.foodName;
    //防止刷新数据丢失
    numberLabel.text = [NSString stringWithFormat:@"%i",_gmodel.number];

    

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

//    if (_gmodel.number>0)
//    {
//        NSLog(@"ASDFASDFDFG");
//    }

    
    // Configure the view for the selected state
}

@end
