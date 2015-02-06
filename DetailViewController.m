//
//  DetailViewController.m
//  KaKa
//
//  Created by Plizarwireless on 14/12/9.
//  Copyright (c) 2014年 Plizarwireless. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailCell1TableViewCell.h"
#import "DetailCell2.h"
#import "commodityModel.h"
#import "BuyInfo.h"
@interface DetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tbView;
   
   
        commodityModel *_cmodel;
    
    
    
}
@end

@implementation DetailViewController

+(NSMutableArray *)ShareMultArr
{
    static NSMutableArray *multArray = nil;
    
    if (multArray==nil)
    {
        
        multArray = [[NSMutableArray alloc]init];
        
    }
    
    
    return multArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.view.backgroundColor = [UIColor colorWithRed:204/255.0 green:235/255.0 blue:168/255.0 alpha:1.0];
    self.navigationController.navigationBar.translucent = NO;
    
    _cmodel = [[commodityModel alloc]init];
    
    
    
     UIScreen *currentScreen = [UIScreen mainScreen];
    CGFloat xWidth = currentScreen.bounds.size.width;
    CGFloat yHeight = currentScreen.bounds.size.height;
    
//    NSLog(@"%.1f",self.view.frame.size.height);
    
    tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, xWidth, yHeight-64-49)];
    tbView.backgroundColor =  [UIColor colorWithRed:204/255.0 green:235/255.0 blue:168/255.0 alpha:1.0];;
    tbView.dataSource = self;
    tbView.delegate = self;
//    tbView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
//    tbView.bounces = NO;
    
    
    [tbView registerNib:[UINib nibWithNibName:@"DetailCell1TableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell1"];
    [tbView registerNib:[UINib nibWithNibName:@"DetailCell2" bundle:nil] forCellReuseIdentifier:@"Cell2"];
    

   
    
    
    UILabel *ShopLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, yHeight-64-49, xWidth, 49)];
    
    
//    buyLabel.backgroundColor = [UIColor colorWithRed:93/255.0 green:179/255.0 blue:88/255.0 alpha:1.0];
    
    ShopLabel.backgroundColor = [UIColor colorWithRed:93/255.0 green:179/255.0 blue:88/255.0 alpha:1.0];
    ShopLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [ShopLabel addGestureRecognizer:tap];
    
    ShopLabel.textColor = [UIColor whiteColor];
    ShopLabel.text = @"放入购物车";
    ShopLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:ShopLabel];
    [self.view addSubview:tbView];
//    [self.view addSubview:view];
}

#pragma mark - tapClick
- (void)tapClick:(UITapGestureRecognizer *)tap
{

//    NSLog(@"TAPCLICK");
   
//    NSLog(@"%i",arr.count);
    
//    NSLog(@"%@",_cmodel.commodityName);
//    NSLog(@"%.1f",[_cmodel.heat floatValue]);
    
//    if (_fmodel.commodityArray.count!=0)
//    {
//        [[DetailViewController ShareMultArr]addObject:@{@"FoodModel":_fmodel,@"commodityModel":_cmodel}];
//        
//           }
//    
//    else
//    {
//    
//    [[DetailViewController ShareMultArr]addObject:@{@"FoodModel":_fmodel}];
//       
//        
//    }

    BuyInfo *buyInfo = [[BuyInfo alloc]init];
    buyInfo.fmodel = _fmodel;
    
    
    
    buyInfo.cmodel = _cmodel;
    
    [[DetailViewController ShareMultArr]addObject:buyInfo];
    
    
    
//    NSLog(@"%i",[DetailViewController ShareMultArr].count);
    
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"添加购物车成功" delegate:nil cancelButtonTitle:@"继续购物" otherButtonTitles:@"去购物车", nil];
//    [alert show];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"notif" object:[DetailViewController ShareMultArr] userInfo:nil];
    
    [self.navigationController popToRootViewControllerAnimated:YES];

    
}


#pragma mark - UIAlertViewDelegate
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
//{
//
//    if (buttonIndex==0)
//    {
//        [self.navigationController popToRootViewControllerAnimated:YES];
//       
//       
//        
//        
//
//    }
//
//    else
//    {
//    
//        self.tabBarController.selectedIndex = 2;
//    
//    }
//
//
//}

#pragma mark - UITableViewDataSource,UITableViewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{


    return 2;
    

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row==0)
  {
      
      DetailCell1TableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"Cell1"];
      cell1.fmodel = _fmodel;
      cell1.backgroundColor = [UIColor colorWithRed:204/255.0 green:235/255.0 blue:168/255.0 alpha:1.0];
      cell1.selectionStyle = UITableViewCellSelectionStyleNone;
      

      
      cell1.myBlock = ^(commodityModel *cmodel){
    
          _cmodel = cmodel;
          
//          NSLog(@"-------%@",cmodel.commodityName);
      };
    
//      cell1.layer.borderWidth = 0.3;
//      cell1.layer.borderColor = [[UIColor colorWithRed:93/255.0 green:179/255.0 blue:88/255.0 alpha:1.0] CGColor];
      
      return cell1;
      
      
    }
    else
    {
    
    
        DetailCell2 *cell2 = [tableView dequeueReusableCellWithIdentifier:@"Cell2"];
        cell2.fmodel = _fmodel;
        cell2.backgroundColor = [UIColor colorWithRed:204/255.0 green:235/255.0 blue:168/255.0 alpha:1.0];
         cell2.selectionStyle = UITableViewCellSelectionStyleNone;
        cell2.layer.borderWidth = 0.5;
        cell2.layer.borderColor = [[UIColor colorWithRed:93/255.0 green:179/255.0 blue:88/255.0 alpha:1.0] CGColor];
        
        
        return cell2;
    }
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row==0)
    {
        if (_fmodel.commodityArray.count==0)
        {
            return 275;
        }
        else
        return 335;
    }
    else
    {
        if ([_fmodel.bewrite isEqualToString:@""])
        {
            
            return 340;
        }
        else
    return 353+_fmodel.bewriteHeight+20;
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






- (void)viewWillAppear:(BOOL)animated
{

    self.tabBarController.tabBar.hidden = YES;


}

- (void)viewWillDisappear:(BOOL)animated
{

    self.tabBarController.tabBar.hidden = NO;

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
