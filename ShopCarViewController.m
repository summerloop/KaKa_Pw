//
//  ShopCarViewController.m
//  KaKa_Pw
//
//  Created by Plizarwireless on 14/12/12.
//  Copyright (c) 2014年 Plizarwireless. All rights reserved.
//

#import "ShopCarViewController.h"
#import "DetailViewController.h"
#import "commodityModel.h"
#import "FoodModel.h"
#import "BuyInfo.h"
#import "CheckNutritionViewController.h"
#import "PayViewController.h"
#import "LoginViewController.h"
//#import "ShopCell.h"
@interface ShopCarViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{


    UITableView *tbView;
    UIView *view;
//    UITabBarItem *item;
    //合计显示label
    UILabel *totalLabel;

    int sum;
    int count;
    
    float width;
    float height;
}
@end

@implementation ShopCarViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        sum = 0;
//        dataArray = [NSMutableArray array];
        UIImage *imageNormal = [UIImage imageNamed:@"3.png"];
        UITabBarItem *item = [[UITabBarItem alloc]initWithTitle:@"购物车" image:imageNormal tag:1];
       
        self.tabBarItem = item;
      
         width = [UIScreen mainScreen].bounds.size.width;
        height = [UIScreen mainScreen].bounds.size.height;

    }

    return self;
}






- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

     self.view.backgroundColor = [UIColor colorWithRed:204/255.0 green:235/255.0 blue:168/255.0 alpha:1.0];
//------------购物车为空时加载的页面------------------------
    view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, height-64-49)];
    view.backgroundColor = [UIColor colorWithRed:204/255.0 green:235/255.0 blue:168/255.0 alpha:1.0];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(width*0.28, height*0.2, 140, 110)];
    
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    imageView.image = [UIImage imageNamed:@"empty_shopCar"];
    [view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(width*0.28+20,height*0.2+120,150, 40)];
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"您的购物车中没有菜品!快去选可口的菜品吧!";
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 2;
    [view addSubview:label];
    
    UIButton *goButton = [[UIButton alloc]initWithFrame:CGRectMake(width*0.28+40, height*0.2+170, 80, 30)];
    goButton.backgroundColor = [UIColor colorWithRed:93/255.0 green:179/255.0 blue:88/255.0 alpha:1.0];
    [goButton setTitle:@"去看看" forState:UIControlStateNormal];
    [goButton addTarget:self action:@selector(goFirst:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:goButton];
    
    
    
    
//-------------------------------自定制返回按钮------------------------
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.backBarButtonItem = item;
    
    self.navigationController.navigationBar.translucent = NO;
    
    
    
    //    NSLog(@"self.frame.width = %f",[UIScreen mainScreen].bounds.size.width);
    
    
    tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, width, height-64-49)];
    tbView.backgroundColor = [UIColor colorWithRed:204/255.0 green:235/255.0 blue:168/255.0 alpha:1.0];
    tbView.delegate = self;
    tbView.dataSource = self;
    
//  --------------------footerview----------------------------
    UILabel *footerView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, 40)];
    footerView.text = @"结算";
    footerView.textColor = [UIColor whiteColor];
    footerView.backgroundColor = [UIColor colorWithRed:93/255.0 green:179/255.0 blue:88/255.0 alpha:1.0];
    
    footerView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Pay:)];
    [footerView addGestureRecognizer:tap];
    
    //    footerView.font = [UIFont systemFontOfSize:14];
    footerView.textAlignment = NSTextAlignmentCenter;
    tbView.tableFooterView = footerView;
    
//------------------------------headView--------------------------------
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 80)];
    
    headView.backgroundColor = [UIColor colorWithRed:203/255.0 green:236/255.0 blue:165/255.0 alpha:1.0];
    headView.layer.borderWidth = 0.3;
    headView.layer.borderColor = [[UIColor colorWithRed:93/255.0 green:179/255.0 blue:88/255.0 alpha:1.0] CGColor];
    
//--------------------------添加按钮---------------------------------
    UIButton *addBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width*0.3, 40)];
//    NSLog(@"%.1f",width*0.3);
    [addBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    addBtn.backgroundColor = [UIColor colorWithRed:90/255.0 green:180/255.0 blue:83/255.0 alpha:1.0];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [addBtn setTitle:@"添加" forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(Back:) forControlEvents:UIControlEventTouchUpInside];
    
    [headView addSubview:addBtn];
    
//------------------------查看营养分数按钮-------------------------------
    UIButton *checkBtn = [[UIButton alloc]initWithFrame:CGRectMake(width*0.3, 0, width*0.4, 40)];
    [checkBtn setTitle:@"查看营养分数" forState:UIControlStateNormal];
    checkBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:158/255.0 blue:0 alpha:1.0];
    checkBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [checkBtn addTarget:self action:@selector(Check:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:checkBtn];
    
//-----------------------清空按钮-------------------------------
    UIButton *clearBtn = [[UIButton alloc]initWithFrame:CGRectMake(width*0.7, 0, width*0.3, 40)];
    [clearBtn setImage:[UIImage imageNamed:@"clear"] forState:UIControlStateNormal];
    [clearBtn setTitle:@"清空" forState:UIControlStateNormal];
    clearBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    clearBtn.backgroundColor = [UIColor colorWithRed:217/255.0 green:80/255.0 blue:78/255.0 alpha:1.0];
//    clearBtn.enabled = NO;
    [clearBtn addTarget:self action:@selector(Clear:) forControlEvents:UIControlEventTouchUpInside];
    
    [headView addSubview:clearBtn];
    
//---------------------合计--------------------------------
    UILabel *indicator = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, 40, 20)];
    indicator.text = @"合计:";
    indicator.font = [UIFont systemFontOfSize:15];
    indicator.textColor = [UIColor grayColor];
    [headView addSubview:indicator];
    
    
// ------------------------------合计价格-------------------
    totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 60, width-40, 20)];
    totalLabel.font = [UIFont systemFontOfSize:15];
    totalLabel.textColor = [UIColor redColor];
    totalLabel.text = [NSString stringWithFormat:@"0.00元"];
    [headView addSubview:totalLabel];
    
    
    
 
    
    
    
    tbView.tableHeaderView = headView;
    
   
    
}


- (void)goFirst:(UIButton *)bt
{


    self.tabBarController.selectedIndex = 0;

}
#pragma mark - 结算
- (void)Pay:(UITapGestureRecognizer *)tap
{


    
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSDictionary *defaultsdic = [defaults objectForKey:@"Login"];
        
//        NSLog(@"%@",defaultsdic);
        if (defaultsdic.count==0)
        {
            
//            NSLog(@"未登录");
            
            LoginViewController *login = [[LoginViewController alloc]init];
            login.ispopHome = NO;
            [self.navigationController pushViewController:login animated:YES];
            
            
        }
        
        else
        {
//            NSLog(@"已登录");
            //            下单页面
        
            PayViewController *pay = [[PayViewController alloc]init];
            pay.memberId = defaultsdic[@"memberId"];
            pay.allMoney = sum;
            
            pay.payArray = [DetailViewController ShareMultArr];
            
            pay.payblock = ^(BOOL isPay)
            {
            
                if (isPay==YES)
                {
                    
                    
                    [[DetailViewController ShareMultArr]removeAllObjects];
                    
                    [tbView reloadData];
                    
                    totalLabel.text = [NSString stringWithFormat:@"￥0.00元"];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"shop" object:[DetailViewController ShareMultArr] userInfo:nil];
                    [tbView removeFromSuperview];
                    [self.view addSubview:view];
                }
            
            
            };
        
           
            [self.navigationController pushViewController:pay animated:YES];
          
            
        }
        
        
    
        
    
    
    
    




}



#pragma mark - 添加
- (void)Back:(UIButton *)bt
{

    self.tabBarController.selectedIndex = 0;

  

}

#pragma mark - 清空
- (void)Clear:(UIButton *)bt
{


    if ([DetailViewController ShareMultArr].count==0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"购物车已经为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];

        
    }
    else
    {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"清空" message:@"您确定要清空购物车吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
    }


}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{



    if (buttonIndex==1) {
        

        [[DetailViewController ShareMultArr]removeAllObjects];
        
        [tbView reloadData];
        
        totalLabel.text = [NSString stringWithFormat:@"￥0.00元"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"shop" object:[DetailViewController ShareMultArr] userInfo:nil];
        [tbView removeFromSuperview];
        [self.view addSubview:view];
        
        
    }



}

#pragma mark - 跳转到营养自测详情页面
- (void)Check:(UIButton *)bt
{

    CheckNutritionViewController *check = [[CheckNutritionViewController alloc]init];
    
    check.title = @"营养自测详情";
    check.numberOfStyle = 1;
//    check.style = CheckViewStyleShopCarScore;
    check.infoArray = [DetailViewController ShareMultArr];
  
    [self.navigationController pushViewController:check animated:YES];
    
    


}



#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

     return [DetailViewController ShareMultArr].count;
  


}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{


    
    return 1;
    

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

   static NSString *str = @"Cell_ID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
        
        
    }
    cell.backgroundColor = [UIColor colorWithRed:204/255.0 green:235/255.0 blue:168/255.0 alpha:1.0];
    

    cell.layer.borderWidth = 0.3;
    cell.layer.borderColor = [[UIColor colorWithRed:93/255.0 green:179/255.0 blue:88/255.0 alpha:1.0] CGColor];
    BuyInfo *buyInfo = [DetailViewController ShareMultArr][indexPath.row];
    
    FoodModel *fmodel = buyInfo.fmodel;
    commodityModel *cmodel = buyInfo.cmodel;
    
    UIScreen *currentScreen = [UIScreen mainScreen];
    CGFloat xWidth = currentScreen.bounds.size.width;
    //        CGFloat yHeight = currentScreen.bounds.size.height;
    
    
    for (UIView *views in cell.contentView.subviews)
    {
        [views removeFromSuperview];
    }
    
    
    //自定义代码实现cell上的控件
    UILabel *mainDishLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, xWidth-70, 20)];
    mainDishLabel.tag = 1;
    mainDishLabel.font = [UIFont systemFontOfSize:15];
    //        mainDishLabel.textColor = [UIColor darkGrayColor];
    //        mainDishLabel.backgroundColor = [UIColor redColor];
     mainDishLabel.text = fmodel.commodityName;
    
    [cell.contentView addSubview:mainDishLabel];
    
    UILabel *priceLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(xWidth-60, 10, 60, 20)];
    priceLabel1.tag = 2;
    priceLabel1.font = [UIFont systemFontOfSize:15];
    priceLabel1.textColor = [UIColor redColor];
    
    priceLabel1.text = [NSString stringWithFormat:@"￥%i元",[fmodel.price intValue]];

    [cell.contentView addSubview:priceLabel1];
    
    
    
    UILabel *commodityLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, xWidth-40, 20)];
    commodityLabel.tag = 3;
    //        commodityLabel.textColor = [UIColor darkGrayColor];
    commodityLabel.font = [UIFont systemFontOfSize:14];
    commodityLabel.text = [NSString stringWithFormat:@"底料:%@",cmodel.commodityName];
    
    [cell.contentView addSubview:commodityLabel];
    
    
    UILabel *priceLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(xWidth-60, 40, 60, 20)];
    priceLabel2.tag = 4;
    priceLabel2.font = [UIFont systemFontOfSize:14];
    priceLabel2.textColor = [UIColor redColor];
    
    priceLabel2.text = [NSString stringWithFormat:@"￥%i元",[cmodel.price intValue]];
    [cell.contentView addSubview:priceLabel2];

    
  
    
    if (fmodel.commodityArray.count==0)
    {
        
        commodityLabel.hidden = YES;
        priceLabel2.hidden = YES;
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    
    
   
//    [cell setFoodModel:fmodel andCommodityModel:cmodel];
    
    
  
    return cell;

}








- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{


    
    
    BuyInfo *info = [DetailViewController ShareMultArr][indexPath.row];
    if (info.fmodel.commodityArray.count==0)
    {
        
        return 40;
    }
    else
    {
    
    return 70;
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{


    return UITableViewCellEditingStyleDelete;
  



}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{


      return @"删除";

}

//删除的方法
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{


    
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        
        
        FoodModel *fmodel;
        commodityModel *cmodel;
        
        BuyInfo *info = [DetailViewController ShareMultArr][indexPath.row];
        
        fmodel = info.fmodel;
        cmodel = info.cmodel;
        
        int total = [fmodel.price intValue] + [cmodel.price intValue];
        
        
        totalLabel.text = [NSString stringWithFormat:@"￥%i.00元",sum - total];
        
        sum = sum - total;
        
        
        [[DetailViewController ShareMultArr]removeObjectAtIndex:indexPath.row];
        
            
        
        
        //第一种方式，刷新整个视图
//                      [tableView reloadData];
        //第二种方式 刷新单个cell
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
        
        if ([DetailViewController ShareMultArr].count==0)
        {
            
//            [UIView animateWithDuration:1.0 animations:^{
//               //
//                
//            }];
            [tbView removeFromSuperview];
            [self.view addSubview:view];
        }
        
//        item.badgeValue = [NSString stringWithFormat:@"%i",[DetailViewController ShareMultArr].count];
       
        
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"shop" object:[DetailViewController ShareMultArr] userInfo:nil];
        
        
        
        
    }



}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated
{


     sum = 0;
    
    for (int i=0; i<[DetailViewController ShareMultArr].count; i++)
    {
        
        BuyInfo *info = [DetailViewController ShareMultArr][i];
        FoodModel *fmodel = info.fmodel;
        commodityModel *cmodel = info.cmodel;
        int total = [fmodel.price intValue]+[cmodel.price intValue];
        
        //    NSLog(@"总价为************%i",sum*[DetailViewController ShareMultArr].count);
        
        sum = sum+ total;
        
        
    }
    
    totalLabel.text = [NSString stringWithFormat:@"￥%i.00元",sum];
     [tbView reloadData];
    
    
    if ([DetailViewController ShareMultArr].count==0)
    {
        
       
        [self.view addSubview:view];
    }
    else
    {
        [self.view addSubview:tbView];
        
    }
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{

    [tbView removeFromSuperview];
    [view removeFromSuperview];

}


- (NSString *)title
{

  return @"购物车";

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
