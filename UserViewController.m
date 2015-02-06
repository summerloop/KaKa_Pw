//
//  UserViewController.m
//  KaKa_Pw
//
//  Created by Plizarwireless on 14/12/12.
//  Copyright (c) 2014年 Plizarwireless. All rights reserved.
//


//#define TestmemberId @"297e9e79478ba5c70149c5a16f0501e4"
#define ORDERURL @"http://wx.dearkaka.com/kaka/kaka-api!orderList.shtml"
#define COUPONURL @"http://wx.dearkaka.com/kaka/kaka-api!memberCoupon.shtml"

#import "UserViewController.h"
#import "LoginViewController.h"
#import "OrderListViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "OrderListModel.h"
#import "OrderInfoModel.h"
#import "CouponModel.h"
#import "CouponViewController.h"

@interface UserViewController ()<UITableViewDataSource,UITableViewDelegate>
{


    UITableView *_tbview;
    float xwidth;
    float yHeight;
    NSMutableArray *orderListArr;
    NSMutableArray *couponArr;
    NSString *memberId;
}
@end

@implementation UserViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        xwidth = [UIScreen mainScreen].bounds.size.width;
        yHeight = [UIScreen mainScreen].bounds.size.height;
        orderListArr = [NSMutableArray array];
        couponArr = [NSMutableArray array];
        
    }


    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    NSLog(@"view did load");
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor =  [UIColor colorWithRed:204/255.0 green:235/255.0 blue:168/255.0 alpha:1.0];

    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    [btn setTitle:@"注销" forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    self.navigationItem.rightBarButtonItem = rightBtn;
    
}

- (void)initTableView
{

    _tbview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, xwidth,yHeight-64) style:UITableViewStylePlain];
    _tbview.dataSource = self;
    _tbview.delegate = self;
    
    _tbview.backgroundColor = [UIColor colorWithRed:204/255.0 green:235/255.0 blue:168/255.0 alpha:1.0];
    
//    改变分割线的颜色
    _tbview.separatorColor = [UIColor colorWithRed:93/255.0 green:179/255.0 blue:88/255.0 alpha:1.0];
//   改变分割线的位置大小
//    _tbview.separatorInset = UIEdgeInsetsMake(0, -20, 0, 0);
    
//    _tbview.tintColor = [UIColor greenColor];
    
//    不显示无用cell的分割线
    _tbview.tableFooterView = [[UIView alloc] init];
    
    _tbview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    ------------画分割线---------------
    UILabel *separatorLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 110, xwidth, 1)];
    separatorLabel.backgroundColor = [UIColor colorWithRed:93/255.0 green:179/255.0 blue:88/255.0 alpha:1.0];
    [_tbview addSubview:separatorLabel];
    
    for (int i=0; i<2; i++)
    {
        separatorLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 154+44*i, xwidth, 1)];
        separatorLabel.backgroundColor = [UIColor colorWithRed:93/255.0 green:179/255.0 blue:88/255.0 alpha:1.0];
        [_tbview addSubview:separatorLabel];
        
    }
    
    
    [self.view addSubview:_tbview];

  
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, xwidth, 130)];
    UILabel *defaultLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 80, 20)];
    defaultLabel1.textColor = [UIColor grayColor];
    defaultLabel1.text = @"会员须知";
    [footerView addSubview:defaultLabel1];
    
    defaultLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(30, 50, xwidth-60, 35)];
    defaultLabel1.numberOfLines=0;
    defaultLabel1.lineBreakMode = NSLineBreakByWordWrapping;
    defaultLabel1.text = @"1.如遇不可抗拒或其他无法控制的愿意造成网站系统崩溃或无法正常使用将不承担责任";
    defaultLabel1.font = [UIFont systemFontOfSize:13];
    defaultLabel1.textColor = [UIColor grayColor];
    [footerView addSubview:defaultLabel1];
    
    
    defaultLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(30, 90, xwidth-60, 40)];
    defaultLabel1.numberOfLines=0;
    defaultLabel1.lineBreakMode = NSLineBreakByWordWrapping;
    defaultLabel1.text = @"2.我们将会尽合理的可能协助处理善后事宜,并努力使客户减少可能遭受的损失";
    defaultLabel1.font = [UIFont systemFontOfSize:13];
    defaultLabel1.textColor = [UIColor grayColor];
    [footerView addSubview:defaultLabel1];
    
    
    _tbview.tableFooterView = footerView;
    


}

- (void)btnClicked:(UIButton *)bt
{


    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在注销....";



    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];


    NSDictionary *dictionary = [NSDictionary dictionary];

    [defaults setObject:dictionary forKey:@"Login"];

    [defaults synchronize];


    [self performSelector:@selector(logout) withObject:nil afterDelay:1.0];
    
    


}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{


    return 1;

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 3;


}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

   static NSString *str = @"Cell_Id";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    
     cell.backgroundColor = [UIColor colorWithRed:204/255.0 green:235/255.0 blue:168/255.0 alpha:1.0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    for (UIView *views in cell.contentView.subviews)
    {
        
        [views removeFromSuperview];
        
    }
    
        if (indexPath.row==0)
        {
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            NSDictionary *dic = [defaults objectForKey:@"Login"];
//            NSLog(@"qwer%@",dic);
            
            UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"kakaTeacher.png"]];
            imageView.frame = CGRectMake(70, 10, 60, 90);
            [cell.contentView addSubview:imageView];
            
            
            UILabel *memberNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(xwidth/2, 20, 120, 20)];
            memberNameLabel.text = dic[@"nickName"];
            
            [cell.contentView addSubview:memberNameLabel];
            
            
            UILabel *memberLabel = [[UILabel alloc]initWithFrame:CGRectMake(xwidth/2+20, 60, 60, 20)];
            memberLabel.text = @"咔咔会员";
            memberLabel.font = [UIFont systemFontOfSize:14];
            memberLabel.textColor = [UIColor redColor];
            [cell.contentView addSubview:memberLabel];
            
        }
        
         else if (indexPath.row==1)
        {
               cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"我的订单";
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.imageView.image = [UIImage imageNamed:@"order"];
            
            
            
        }
         else
         {
             
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
             cell.textLabel.text = @"我的优惠券";
             cell.textLabel.font = [UIFont systemFontOfSize:15];
             cell.imageView.image = [UIImage imageNamed:@"couponId"];

         }
   

    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{


    if (indexPath.row==0)
    {
        
        return 110;
    }
  else
      return 44;


}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

   

    if (indexPath.row==1)
    {
        
        [orderListArr removeAllObjects];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"正在加载...";
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager POST:ORDERURL parameters:@{@"memberId":memberId} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
           
//            NSLog(@"%@",array);
            for (int i=0; i<array.count; i++)
            {
                
                OrderListModel *ordermodel = [[OrderListModel alloc]init];
                
                NSDictionary *dic = array[i];
                ordermodel.orderNum = dic[@"orderNum"];
                ordermodel.orderMoney = dic[@"money"];
                ordermodel.creadateDate = dic[@"createDate"];
                ordermodel.orderId = dic[@"id"];
                
              
                
                int orderNum = [dic[@"status"] intValue];
                if (orderNum==0)
                {
                    ordermodel.orderStatus = @"待付款";
                }
                
                else if (orderNum==1)
                {
                
                ordermodel.orderStatus = @"待发货";
                
                }
                else if (orderNum==2)
                {
                
                ordermodel.orderStatus = @"已发货";
                
                }
                else if (orderNum==3)
                {
                
                 ordermodel.orderStatus = @"已完成";
                
                }
                else
                {
                
             ordermodel.orderStatus = @"已取消";
                    
                }
                
                
                [orderListArr addObject:ordermodel];
                
                
            }
            
        
            OrderListViewController *List = [[OrderListViewController alloc]init];
//            NSLog(@"LIST.ORDERARRAY=%i",List.OrderArray.count);
            
            
         
            List.OrderArray = orderListArr;
            
             [self.navigationController pushViewController:List animated:YES];
          
            
            [hud hide:YES];
        
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [hud hide:YES];
            
        }];
        
        
    }
    
    
    else if (indexPath.row==2)
    {
    
        [couponArr removeAllObjects];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"正在加载...";
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];

        [manager POST:COUPONURL parameters:@{@"memberId":memberId,@"allMoney":@"10000000"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            for (int i=0; i<array.count; i++)
            {
                CouponModel *couponmodel = [[CouponModel alloc]init];
                
                NSDictionary *dic = array[i];
                
                couponmodel.bewrite = dic[@"bewrite"];
                couponmodel.couponMoney = dic[@"couponMoney"];
                couponmodel.couponName = dic[@"couponName"];
                couponmodel.createDate = dic[@"createDate"];
                couponmodel.endDate = dic[@"endDate"];
                couponmodel.couponId= dic[@"id"];
                couponmodel.num = dic[@"num"];
                
//                NSLog(@"%@",couponmodel.couponId);
                
                [couponArr addObject:couponmodel];
            }
            
            
            
             [hud hide:YES];
            CouponViewController *coupon = [[CouponViewController alloc]init];
            coupon.couponArray = couponArr;
            [self.navigationController pushViewController:coupon animated:YES];
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            
            NSLog(@"failer");
            
           
            [hud hide:YES];
        }];
    
    
    
        
        
    
    
    }
   



}


- (void)logout
{

    LoginViewController *login = [[LoginViewController alloc]init];
    login.ispopHome = YES;
    [self.navigationController pushViewController:login animated:YES];
     [MBProgressHUD hideHUDForView:self.view animated:YES];

}
- (NSString *)title
{
    
    return @"个人中心";
    
}

- (UITabBarItem *)tabBarItem
{
    
    UIImage *imageNormal = [UIImage imageNamed:@"4.png"];
    UITabBarItem *item = [[UITabBarItem alloc]initWithTitle:@"个人中心" image:imageNormal tag:1];
//    item.badgeValue = @"6";okm,dsa
    return item;
    
    
}



- (void)viewWillAppear:(BOOL)animated
{

//    NSLog(@"will appear");
    
    self.tabBarController.tabBar.hidden = NO;
    [_tbview removeFromSuperview];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *defaultsdic = [defaults objectForKey:@"Login"];
    
//    NSLog(@"%@",defaultsdic);
    if (defaultsdic.count==0)
    {
        
        //        NSLog(@"未登录");
        
        
        LoginViewController *login = [[LoginViewController alloc]init];
        
        login.ispopHome = YES;
        [self.navigationController pushViewController:login animated:YES];
        
        
    }
    
    else
    {
        //        NSLog(@"已登录");
        [self initTableView];
        
        memberId = defaultsdic[@"memberId"];
        
    }

    }

//- (id)init
//{
//    self = [super init];
//    
//    if (self) {
//
//        
//        
//    }
//
//
//    return self;
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
