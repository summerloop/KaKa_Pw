//
//  NutritionViewController.m
//  KaKa_Pw
//
//  Created by Plizarwireless on 14/12/12.
//  Copyright (c) 2014年 Plizarwireless. All rights reserved.
//

#define EatenKaKaURL @"http://wx.dearkaka.com/kaka/kaka-api!myNowOrder.shtml"
#define EatenGridFoodURL @"http://wx.dearkaka.com/kaka/kaka-api!myNowKaKa.shtml"
#define KaKaLISTURL @"http://wx.dearkaka.com/kaka/kaka-api!myKaKaList.shtml"

//#define TestmemberId @"297e9e79478ba5c70149c5a16f0501e4"


#import "NutritionViewController.h"
#import "CheckNutritionViewController.h"
#import "LoginViewController.h"
#import "AFNetworking.h"
#import "CalendarViewController.h"
#import "MBProgressHUD.h"
#import "CalHeadModel.h"
#import "CalFoodModel.h"
@interface NutritionViewController ()<UITableViewDataSource,UITableViewDelegate>
{

   UITableView *tbView;
    NSMutableArray *calHeadArr;
    NSMutableArray *nowOrderArr;
    NSMutableArray *todayArr;

    float width;
    float height;
    
    BOOL isRepeat;
}
@end

@implementation NutritionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    isRepeat = NO;
    calHeadArr = [NSMutableArray array];
    nowOrderArr = [NSMutableArray array];
    todayArr = [NSMutableArray array];
    
    //-------------------------------自定制返回按钮------------------------
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.backBarButtonItem = item;
    
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor colorWithRed:204/255.0 green:235/255.0 blue:168/255.0 alpha:1.0];
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
//    NSLog(@"self.frame.width = %f",[UIScreen mainScreen].bounds.size.width);
    
    tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, width, height-64-49)];
    tbView.backgroundColor = [UIColor colorWithRed:204/255.0 green:235/255.0 blue:168/255.0 alpha:1.0];
    tbView.delegate = self;
    tbView.dataSource = self;
    
//    不想让TableView显示无用的Cell分割线

    tbView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:tbView];
}


#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 2;
    
    
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
    cell.textLabel.font = [UIFont systemFontOfSize:15];
   
    UILabel *label = [UILabel new];
//    label.font = [UIFont systemFontOfSize:15];
    [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
    if (indexPath.row==0)
    {
        
//        cell.textLabel.text = @"今日卡卡分";
        label.frame = CGRectMake(width/2-40, 60, 80, 20);
        label.text = @"今日卡卡分";
        [cell.contentView addSubview:label];
        
       
    }
    else
    {
    
//        cell.textLabel.text = @"往日卡卡分";
        label.frame = CGRectMake(width/2-40, 60, 80, 20);
        label.text = @"往日卡卡分";
        [cell.contentView addSubview:label];
    }
    
    return cell;
    
}

#pragma mark - 今日、往日卡卡分
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row==0)
    {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSDictionary *defaultsdic = [defaults objectForKey:@"Login"];
        
//        defaultsdic[@"memberId"];
//        NSLog(@"%@",defaultsdic);
        
        //        {
        //        memberAddress = "";
        //        memberID = 297e9e794a941251014a9ec8a9910014;
        //        memberName = "";
        //        memberPhone = 13246753047;
        //        nickName = 13246753047;
        //    }

        
        
 
        if (defaultsdic.count==0)
        {
            
//            NSLog(@"未登录");
            
            LoginViewController *login = [[LoginViewController alloc]init];
            login.ispopHome = NO;
            [self.navigationController pushViewController:login animated:YES];
            
            
        }
        
       else
       {
//           NSLog(@"已登录");
//           今日卡卡分界面
//        POST多路请求
           [nowOrderArr removeAllObjects];

           MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
           hud.labelText = @"正在加载...";
           
           NSString *str1 = [NSString stringWithFormat:@"%@?memberId=%@",EatenKaKaURL,defaultsdic[@"memberId"]];
           
           NSString *str2 = [NSString stringWithFormat:@"%@?memberId=%@",EatenGridFoodURL,defaultsdic[@"memberId"]];
           
           NSArray *array = [NSArray arrayWithObjects:str1,str2, nil];
           
           for (int i=0; i<array.count; i++)
           {
               NSURL *url = [NSURL URLWithString:array[i]];
               NSURLRequest *request = [NSURLRequest requestWithURL:url];
               AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc]initWithRequest:request];
               
               op.responseSerializer = [AFHTTPResponseSerializer serializer];
               
               [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                   NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                   
                   
//                   NSLog(@"%@",array);
                   if (i==0)    //MyNowOrder
                   {
                       
                       for (int j=0; j<array.count; j++)
                       {
                           
                           CalFoodModel *cfmodel = [[CalFoodModel alloc]init];
                           
                           NSDictionary *dic = array[j];
                           NSDictionary *subDic = dic[@"commodity"];
                           
                           cfmodel.num = dic[@"num"];
                           cfmodel.foodName = subDic[@"commodityName"];
                           cfmodel.ca = subDic[@"ca"];
                           cfmodel.fe = subDic[@"fe"];
                           cfmodel.fiber = subDic[@"fiber"];
                           cfmodel.heat = subDic[@"heat"];
                           cfmodel.Id = subDic[@"id"];
                           cfmodel.k = subDic[@"k"];
                           cfmodel.mg = subDic[@"mg"];
                           cfmodel.protein = subDic[@"protein"];
                           cfmodel.va = subDic[@"va"];
                           cfmodel.vc = subDic[@"vc"];
                           cfmodel.ve = subDic[@"ve"];
                           cfmodel.zn = subDic[@"zn"];
                           
                           [nowOrderArr addObject:cfmodel];
                           
                           
                       }

                    
//                       [todayArr addObject:nowOrderArr];
                       
                       
                       
                   }
                   
                 else      //MyNowKaKa
                   {
                       
                       
                       for (int j=0; j<array.count; j++)
                       {
                           
                           CalFoodModel *cfmodel = [[CalFoodModel alloc]init];
                           
                           NSDictionary *dic = array[j];
                           NSDictionary *commodityDic = dic[@"commodity"];
                           NSDictionary *GridDic = dic[@"kakaFoodGrid"];
                           NSDictionary *KaKaDic = dic[@"myKaKa"];
                           
                           cfmodel.totalHeat = KaKaDic[@"heat"];
                           
                           
                           cfmodel.num = dic[@"num"];
                           if (![commodityDic isEqual:[NSNull null]])
                           {
                               
                           
                           cfmodel.foodName = commodityDic[@"commodityName"];
                           cfmodel.ca = commodityDic[@"ca"];
                           cfmodel.fe = commodityDic[@"fe"];
                           cfmodel.fiber = commodityDic[@"fiber"];
                           cfmodel.heat = commodityDic[@"heat"];
                           cfmodel.Id = commodityDic[@"id"];
                           cfmodel.k = commodityDic[@"k"];
                           cfmodel.mg = commodityDic[@"mg"];
                           cfmodel.protein = commodityDic[@"protein"];
                           cfmodel.va = commodityDic[@"va"];
                           cfmodel.vc = commodityDic[@"vc"];
                           cfmodel.ve = commodityDic[@"ve"];
                           cfmodel.zn = commodityDic[@"zn"];
                           
                               for (int k=0; k<nowOrderArr.count; k++)
                               {
                                   
                                   CalFoodModel *calmodel = nowOrderArr[k];
                                   
                                   if ([cfmodel.foodName isEqualToString:calmodel.foodName])
                                   {
                                       
                                       
                                       isRepeat = YES;
                                       break;
                                   }
                                   else
                                   {
                                   
                                       isRepeat = NO;
                                   
                                   }
                                   
                               }
                               
                               if (isRepeat)
                               {
                                   
                               }
                               else
                               {
                           [nowOrderArr addObject:cfmodel];
                               }
                    }
                         
                           
                           else
                           {
                           
                               cfmodel.foodName = GridDic[@"foodName"];
                               cfmodel.ca = GridDic[@"ca"];
                               cfmodel.fe = GridDic[@"fe"];
                               cfmodel.fiber = GridDic[@"fiber"];
                               cfmodel.heat = GridDic[@"heat"];
                               cfmodel.Id = GridDic[@"id"];
                               cfmodel.k = GridDic[@"k"];
                               cfmodel.mg = GridDic[@"mg"];
                               cfmodel.protein = GridDic[@"protein"];
                               cfmodel.va = GridDic[@"va"];
                               cfmodel.vc = GridDic[@"vc"];
                               cfmodel.ve = GridDic[@"ve"];
                               cfmodel.zn = GridDic[@"zn"];
                               
                               [nowOrderArr addObject:cfmodel];

                           }
                           
                       }

                       
                       
                       
//                       NSLog(@"now order is %i",nowOrderArr.count);
                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                       CheckNutritionViewController *check = [[CheckNutritionViewController alloc]init];
                       
                       check.TodayArray = nowOrderArr;
                       check.memberId = defaultsdic[@"memberId"];
//                       check.infoArray = nil;
                       check.numberOfStyle = 3;  //可以修改
                       [self.navigationController pushViewController:check animated:YES];
                       
                   }
                   
               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                   
                   
                   NSLog(@"ERROR:%@",error);
               }];
               
               
               [[NSOperationQueue mainQueue] addOperation:op];
               
           }
           
        
//           AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//           
//           manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//           
//           [manager POST:EatenKaKaURL parameters:@{@"memberId":defaultsdic[@"memberId"]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
//               
//               NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//               
//               NSLog(@"sadasdsaasddsadas%@",dic);
//               
//               
//           } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//               
//               
//               NSLog(@"web error");
//               
//           }];
//
        
       }
    }
    
    

    else if (indexPath.row==1)
    {
    
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSDictionary *defaultsdic = [defaults objectForKey:@"Login"];
        
//        NSLog(@"%@",defaultsdic);
        if (defaultsdic.count==0)
        {
            
            NSLog(@"未登录");
            
            LoginViewController *login = [[LoginViewController alloc]init];
            login.ispopHome = NO;
            [self.navigationController pushViewController:login animated:YES];
            
            
        }
        
        else
        {
            NSLog(@"已登录");
//            往日卡卡分日记界面
            [calHeadArr removeAllObjects];
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"正在加载...";
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            [manager POST:KaKaLISTURL parameters:@{@"memberId":defaultsdic[@"memberId"]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                
               
//                NSLog(@"往日卡卡分数据为%lu",(unsigned long)array.count);
                for (int i=0; i<array.count; i++)
                {
                    CalHeadModel *headModel = [[CalHeadModel alloc]init];
                    NSDictionary *dic = array[i];
                    headModel.createDate = dic[@"createDate"];
//                    NSLog(@"%@",headModel.createDate);
                    headModel.totalHeat = dic[@"heat"];
//                    NSLog(@"%@",headModel.totalHeat);
                    
                    headModel.kakaFoods = dic[@"kakaFoods"];
//                    NSLog(@"%lu",(unsigned long)headModel.kakaFoods.count);
                    
                    [calHeadArr addObject:headModel];
                }
                
                NSLog(@"卡卡卡LIST%lu",(unsigned long)calHeadArr.count);
               
                
                CalendarViewController *cal = [[CalendarViewController alloc]init];
                
                cal.calHeadArr = calHeadArr;
                
                [self.navigationController pushViewController:cal animated:YES];
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
               
                NSLog(@"Web ERROR");
                
            }];
            
            
           
        }

    
    
      
    
    }
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    return 160;
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSString *)title
{

  return @"营养自测";

}

- (UITabBarItem *)tabBarItem
{

    UIImage *imageNormal = [UIImage imageNamed:@"2.png"];
    UITabBarItem *item = [[UITabBarItem alloc]initWithTitle:@"营养自测" image:imageNormal tag:1];
   
    return item;


}


- (void)viewWillAppear:(BOOL)animated
{

   
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
