//
//  DetailCell1TableViewCell.m
//  KaKa
//
//  Created by Plizarwireless on 14/12/11.
//  Copyright (c) 2014年 Plizarwireless. All rights reserved.
//



#import "DetailCell1TableViewCell.h"
//#import "UIImageView+WebCache.h"

#import "UIImageView+AFNetworking.h"
#import "commodityModel.h"

@implementation DetailCell1TableViewCell
{
    UIPopoverListView *poplistview;

    NSMutableArray *commodityArr;

    //判断是否点击了commodity
    BOOL isChoose;

    
    UILabel *commodityLabel;
    UILabel *combinationLabel;
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        isChoose = NO;
    }
    
    return self;
    
}


- (void)awakeFromNib {
    // Initialization code
//   isChoose = NO;
    
    commodityArr = [NSMutableArray array];
    UIScreen *currentScreen = [UIScreen mainScreen];
    CGFloat xWidth = currentScreen.bounds.size.width;
//    CGFloat Yheight = currentScreen.bounds.size.height;
    
    
    commodityLabel = [[UILabel alloc]initWithFrame:CGRectMake(27, 302, xWidth-54, 30)];
    commodityLabel.backgroundColor = [UIColor whiteColor];
    commodityLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(commodityChoose:)];
    [commodityLabel addGestureRecognizer:tap];
    commodityLabel.layer.borderWidth = 1;
    commodityLabel.layer.cornerRadius = 5;
    commodityLabel.clipsToBounds = YES;
    commodityLabel.layer.borderColor = [[UIColor colorWithRed:93/255.0 green:179/255.0 blue:88/255.0 alpha:1.0] CGColor];

    commodityLabel.font = [UIFont systemFontOfSize:14];
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jiantou.png"]];
    imageView.frame = CGRectMake(commodityLabel.frame.size.width-20, 5, 20, 20);
    [commodityLabel addSubview:imageView];
    imageView.autoresizesSubviews = YES;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    
    [self addSubview:commodityLabel];
    
    
    
    combinationLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 181, xWidth-16, 42)];
    combinationLabel.numberOfLines = 2;
    combinationLabel.lineBreakMode = NSLineBreakByWordWrapping;
    combinationLabel.font = [UIFont systemFontOfSize:14];
    
    
    [self addSubview:combinationLabel];
    
    
    
       }

 

- (void)commodityChoose:(UITapGestureRecognizer*)tap
{

    
    CGFloat yHeight;
    
    CGFloat xWidth = self.frame.size.width-40;
    if (_fmodel.commodityArray.count*44>272.0)
    {
        
        yHeight = 272.0f;
    }
    else
    {
        
        
        yHeight = _fmodel.commodityArray.count*44+30;
        
        
    }
    CGFloat yOffset = (568 - yHeight)/2.0f;
    poplistview = [[UIPopoverListView alloc] initWithFrame:CGRectMake(10, yOffset, xWidth, yHeight)];
    poplistview.delegate = self;
    poplistview.datasource = self;
    poplistview.listView.scrollEnabled = YES;
    poplistview.listView.bounces = NO;
//    poplistview.listView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [poplistview setTitle:@"底料"];
    
    [poplistview show];
  


}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
    if (_fmodel.commodityArray.count!=0)
    {
        if (isChoose==NO)
        {
            
            if (_myBlock) {
                
                _myBlock(commodityArr[0]);
            }
            
        }
        
         
    }
   

    // Configure the view for the selected state
}




- (void)setFmodel:(FoodModel *)fmodel
{


    _fmodel = fmodel;
    
    [_ImgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://wx.dearkaka.com/kaka/%@",_fmodel.showImg]]];
    
    
//    NSLog(@"%@",[NSString stringWithFormat:@"http://wx.dearkaka.com/kaka/%@",_fmodel.showImg]);
    
    combinationLabel.text = _fmodel.combination;
    _price.text = [NSString stringWithFormat:@"￥%@元/份",_fmodel.price];
    _heat.text = [NSString stringWithFormat:@"%.1f大卡",[_fmodel.heat floatValue]];
//    NSLog(@"%lu",(unsigned long)_fmodel.commodityArray.count);
//    _commoty.hidden = YES;
//    _chooseLabel.hidden = YES;
    if (_fmodel.commodityArray.count==0)
    {
        
        
        _chooseLabel.hidden = YES;
        commodityLabel.hidden = YES;
    }

    
    for (int k=0; k<_fmodel.commodityArray.count; k++)
    {

        NSDictionary *coDic = _fmodel.commodityArray[k];
        commodityModel *cmodel = [[commodityModel alloc]init];
        cmodel.bewrite = coDic[@"bewrite"];
        cmodel.ca = coDic[@"ca"];
        cmodel.commodityName = coDic[@"commodityName"];
        
//        NSLog(@"%@",cmodel.commodityName);
        cmodel.fe = coDic[@"fe"];
        cmodel.fiber = coDic[@"fiber"];
        cmodel.heat = coDic[@"heat"];
        cmodel.Id = coDic[@"id"];
        cmodel.k = coDic[@"k"];
        cmodel.mg = coDic[@"mg"];
        cmodel.price = coDic[@"price"];
        cmodel.protein = coDic[@"protein"];
        cmodel.showImg = coDic[@"showImg"];
        cmodel.sort = coDic[@"sort"];
        cmodel.status = coDic[@"status"];
        cmodel.stock = coDic[@"stock"];
        cmodel.type = coDic[@"type"];
        cmodel.va = coDic[@"va"];
        cmodel.vc = coDic[@"vc"];
        cmodel.ve = coDic[@"ve"];
        cmodel.zn = coDic[@"zn"];
        cmodel.number = 1;
        
        [commodityArr addObject:cmodel];

    }
    if (_fmodel.commodityArray.count!=0)
    {
        commodityLabel.text = [commodityArr[0] commodityName];
        
    }
    
    }


#pragma mark - UIPopoverListViewDataSource
- (UITableViewCell *)popoverListView:(UIPopoverListView *)popoverListView cellForIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    //    UITableViewCell *cell1 = [popoverListView ]
    //    if (!cell) {
    //        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    //    }
    commodityModel *cmodel = commodityArr[indexPath.row];
    
    cell.textLabel.text = cmodel.commodityName;
    cell.backgroundColor = [UIColor colorWithRed:204/255.0 green:235/255.0 blue:168/255.0 alpha:1.0];
    return cell;
}

- (NSInteger)popoverListView:(UIPopoverListView *)popoverListView
       numberOfRowsInSection:(NSInteger)section
{
  
    return _fmodel.commodityArray.count;
    
}

#pragma mark - UIPopoverListViewDelegate
- (void)popoverListView:(UIPopoverListView *)popoverListView
     didSelectIndexPath:(NSIndexPath *)indexPath
{
//        NSLog(@"%s : %ld", __func__, (long)indexPath.row);
    // your code here
    
    isChoose = YES;
    commodityLabel.text = [commodityArr[indexPath.row] commodityName];
    
    // commoditymodel 购物车底料信息
    

    
    if (_myBlock) {
        
        _myBlock(commodityArr[indexPath.row]);
    }
    
}



- (CGFloat)popoverListView:(UIPopoverListView *)popoverListView
   heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

  
 
      return 44.0f;
}



@end
