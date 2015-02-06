
//
//  OrderInfoViewController.m
//  KaKa_Pw
//
//  Created by Plizarwireless on 15/1/14.
//  Copyright (c) 2015年 Plizarwireless. All rights reserved.
//

#import "OrderInfoViewController.h"
#import "CheckNutritionViewController.h"
#import "OrderInfoModel.h"
#import "OrderInfoCell.h"
@interface OrderInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
{

    UITableView *_tbView;
    float xwidth;
    float yHeight;
    NSMutableArray *infoArray;
    
}
@end

@implementation OrderInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
//    NSLog(@"_orderCommodity.count==%i",_commodityArr.count);
    
    self.navigationController.navigationBar.translucent = NO;
    xwidth = [UIScreen mainScreen].bounds.size.width;
    yHeight = [UIScreen mainScreen].bounds.size.height;
    
    self.title = @"我的订单";
    self.view.backgroundColor = [UIColor colorWithRed:204/255.0 green:235/255.0 blue:168/255.0 alpha:1.0];
    
    _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, xwidth,yHeight-64+49)];
    
    _tbView.backgroundColor = [UIColor colorWithRed:204/255.0 green:235/255.0 blue:168/255.0 alpha:1.0];
    [_tbView registerNib:[UINib nibWithNibName:@"OrderInfoCell" bundle:nil] forCellReuseIdentifier:@"InfoCell"];
    
    _tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tbView.delegate = self;
    _tbView.dataSource = self;
   
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, xwidth, 80)];
//    headView.layer.borderWidth = 0.3;
//    headView.layer.borderColor = [[UIColor colorWithRed:93/255.0 green:179/255.0 blue:88/255.0 alpha:1.0] CGColor];
    
    UIButton *checkBtn = [[UIButton alloc]initWithFrame:CGRectMake(xwidth*0.36, 10, 100, 30)];
    [checkBtn setTitle:@"查看营养分数" forState:UIControlStateNormal];
    [checkBtn addTarget:self action:@selector(checkNutrition) forControlEvents:UIControlEventTouchUpInside];
    
    [checkBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
    checkBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:158/255.0 blue:0 alpha:1.0];
//    checkBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    
    UILabel *totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(xwidth*0.36-20, 50, 40, 30)];
    
    totalLabel.text = @"合计:";
    totalLabel.alpha = 0.6;
    [totalLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
    
    UILabel *countLabel = [[UILabel alloc]initWithFrame:CGRectMake(xwidth*0.36+20, 50, 60, 30)];
    countLabel.textColor = [UIColor redColor];
    [countLabel setFont:[UIFont systemFontOfSize:15]];
    countLabel.text = [NSString stringWithFormat:@"￥%1.f元",[_allMoney floatValue]];
    
    
    [headView addSubview:countLabel];
    [headView addSubview:totalLabel];
    [headView addSubview:checkBtn];
    
    _tbView.tableHeaderView = headView;
    
     UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, xwidth, 110)];
    
    UILabel *receiptLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 10, 80, 20)];
    receiptLabel.text = @"收货信息";
    [receiptLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
    
    UILabel *memberNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 30, 80, 20)];
    memberNameLabel.text = _memberName;
    memberNameLabel.font = [UIFont systemFontOfSize:15];
    
    
    UILabel *memberPhoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 30, 120, 20)];
    memberPhoneLabel.text = _memberPhone;
    memberPhoneLabel.font = [UIFont systemFontOfSize:15];
    
    UILabel *memberAddressLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 60, xwidth-80, 40)];
    memberAddressLabel.text = _memberAddress;
    memberAddressLabel.font = [UIFont systemFontOfSize:15];
    memberAddressLabel.numberOfLines = 0;
    memberAddressLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    
    [footerView addSubview:memberAddressLabel];
    [footerView addSubview:memberPhoneLabel];
    [footerView addSubview:memberNameLabel];
    [footerView addSubview:receiptLabel];
    _tbView.tableFooterView = footerView;
    
    
     [self.view addSubview:_tbView];
    
    UILabel *separatorLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 80, xwidth, 1)];
    separatorLabel.backgroundColor = [UIColor colorWithRed:93/255.0 green:179/255.0 blue:88/255.0 alpha:1.0];
    [_tbView addSubview:separatorLabel];
    
    for (int i=0; i<infoArray.count; i++)
    {
        OrderInfoModel *model = infoArray[i];
        
        
       separatorLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 80+(i+1)*70, xwidth, 1)];
        separatorLabel.tag = i+1;
         separatorLabel.backgroundColor = [UIColor colorWithRed:93/255.0 green:179/255.0 blue:88/255.0 alpha:1.0];
        
        if ([model.allPrice intValue]==0)
        {
            UILabel *label = (UILabel *)[self.view viewWithTag:i];
            label.hidden = YES;
            model.commodityName = [NSString stringWithFormat:@"底料:%@",model.commodityName];
        
        }
        
    
        [_tbView addSubview:separatorLabel];
        
    }
    
}


- (void)checkNutrition
{

    CheckNutritionViewController *check = [[CheckNutritionViewController alloc]init];
    
    check.orderArray = infoArray;
//    check.infoArray = nil;
    check.numberOfStyle = 5;
    [self.navigationController pushViewController:check animated:YES];
  
  


}
- (void)setCommodityArr:(NSMutableArray *)commodityArr
{
    infoArray = [NSMutableArray array];
    _commodityArr = commodityArr;
    
    for (int i=0; i<_commodityArr.count; i++)
    {
      
        OrderInfoModel *infoModel = [[OrderInfoModel alloc]init];
        NSDictionary *dic = _commodityArr[i];
        infoModel.allPrice = dic[@"allPrict"];
        infoModel.num = dic[@"num"];
        
        NSDictionary *subDic = dic[@"commodity"];
        
        infoModel.commodityName = subDic[@"commodityName"];
        infoModel.ca = subDic[@"ca"];
        infoModel.fe = subDic[@"fe"];
        infoModel.fiber = subDic[@"fiber"];
        infoModel.heat = subDic[@"heat"];
        infoModel.Id = subDic[@"id"];
        infoModel.k = subDic[@"k"];
        infoModel.mg = subDic[@"mg"];
        
        infoModel.va = subDic[@"va"];
        infoModel.vc = subDic[@"vc"];
        infoModel.ve = subDic[@"ve"];
        infoModel.zn = subDic[@"zn"];
        infoModel.protein = subDic[@"protein"];
        
        
        [infoArray addObject:infoModel];
    }
    

//    NSLog(@"%i",infoArray.count);

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{



    return infoArray.count;


}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    OrderInfoModel *infoModel = infoArray[indexPath.row];
    OrderInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
    
    cell.infoModel = infoModel;
     cell.backgroundColor = [UIColor colorWithRed:204/255.0 green:235/255.0 blue:168/255.0 alpha:1.0];
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{


    return 70.0;


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
