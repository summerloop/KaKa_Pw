//
//  OrderListViewController.m
//  KaKa_Pw
//
//  Created by Plizarwireless on 15/1/13.
//  Copyright (c) 2015年 Plizarwireless. All rights reserved.
//


#define ORDERINFOURL @"http://wx.dearkaka.com/kaka/kaka-api!orderInfo.shtml"
#import "OrderListViewController.h"
#import "AFNetworking.h"
#import "OrderListModel.h"
#import "OrderListCell.h"
#import "OrderInfoViewController.h"
#import "MBProgressHUD.h"
@interface OrderListViewController ()<UITableViewDataSource,UITableViewDelegate>
{


    UITableView *_tbView;
    float xwidth;
    float yHeight;
}
@end

@implementation OrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
  
    self.navigationController.navigationBar.translucent = NO;
    
    xwidth = [UIScreen mainScreen].bounds.size.width;
    yHeight = [UIScreen mainScreen].bounds.size.height;
    
    self.title = @"全部订单";
    self.view.backgroundColor = [UIColor colorWithRed:204/255.0 green:235/255.0 blue:168/255.0 alpha:1.0];
    
    _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, xwidth,yHeight-64+49)];
    _tbView.backgroundColor = [UIColor colorWithRed:204/255.0 green:235/255.0 blue:168/255.0 alpha:1.0];
    [_tbView registerNib:[UINib nibWithNibName:@"OrderListCell" bundle:nil] forCellReuseIdentifier:@"orderListCell"];
    
    _tbView.delegate = self;
    _tbView.dataSource = self;
    [self.view addSubview:_tbView];
    
    
}


#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{


    return _OrderArray.count;


}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

       OrderListModel *model = _OrderArray[indexPath.row];
    OrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderListCell"];
    cell.layer.borderWidth = 0.3;
    cell.layer.borderColor = [[UIColor colorWithRed:93/255.0 green:179/255.0 blue:88/255.0 alpha:1.0] CGColor];
//    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.listModel = model;
   cell.backgroundColor = [UIColor colorWithRed:204/255.0 green:235/255.0 blue:168/255.0 alpha:1.0];

    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OrderListModel *model = _OrderArray[indexPath.row];

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载...";
   
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:ORDERINFOURL parameters:@{@"commodityOrderId":model.orderId} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
 
        OrderInfoViewController *info = [[OrderInfoViewController alloc]init];
        
        info.memberName = dic[@"memberName"];
        info.memberPhone = dic[@"phone"];
        info.memberAddress = dic[@"address"];
        info.allMoney = dic[@"money"];
        info.remark = dic[@"remark"];
        info.commodityArr = dic[@"orderCommoditys"];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.navigationController pushViewController:info animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"网络未连接" message:@"请检查网络设置后,重新加载" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alertView show];
    }];
    


}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{


    return 155.0;


}
- (void)viewWillAppear:(BOOL)animated
{

    self.tabBarController.tabBar.hidden = YES;
   
    

 
}
- (void)viewWillDisappear:(BOOL)animated
{



    
    self.tabBarController.tabBar.hidden = NO;

}
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
