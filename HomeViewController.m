//
//  HomeViewController.m
//  Test_kaka
//
//  Created by Plizarwireless on 14/12/9.
//  Copyright (c) 2014年 Plizarwireless. All rights reserved.
//

#import "HomeViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "CateModel.h"
#import "FoodModel.h"
#import "commodityModel.h"

#import "DetailViewController.h"
#import "HomeCell.h"
#import "UIImageView+AFNetworking.h"

#import "ShopCarViewController.h"

//#import "WebErrorViewController.h"
@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    
    float xwidth;
    float yHeight;
    //    左侧按钮
    UIButton *leftBtn;
    
    //    纪录按钮点击状态
    BOOL isClicked;
    
    //    右侧跳转购物车按钮（跳转需登录）
    UIButton *shopBtn;
    
    UILabel *numberLabel;
    
    UITableView *_tbView;
    
    NSMutableArray *cateArray;
    
}
@end

@implementation HomeViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    
    {
        xwidth = [UIScreen mainScreen].bounds.size.width;
        yHeight = [UIScreen mainScreen].bounds.size.height;
        cateArray = [NSMutableArray array];
        
       
        isClicked = NO;
        
        
    }
    
    



    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"KaKa美食";
    // 表示00 坐标从导航栏下面开始
    self.navigationController.navigationBar.translucent = NO;
//    self.tabBarController.tabBar.translucent = NO;
    self.view.backgroundColor = [UIColor colorWithRed:204/255.0 green:235/255.0 blue:168/255.0 alpha:1.0];
    
//    self.view.backgroundColor = [UIColor redColor];
    leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    
    [leftBtn addTarget:self action:@selector(btClick:) forControlEvents:UIControlEventTouchUpInside];
    
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [leftBtn setTitle:@"展开全部" forState:UIControlStateNormal];
    
    shopBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    [shopBtn addTarget:self action:@selector(shop:) forControlEvents:UIControlEventTouchUpInside];
    shopBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//    shopBtn.layer.borderWidth = 0.3;
//    shopBtn.layer.borderColor = [[UIColor blackColor] CGColor];
//    [shopBtn setTitle:@"购物车" forState:UIControlStateNormal];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shopCar"]];
    imageView.frame = CGRectMake(0, 5, 20, 20);
    numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 5, 20, 20)];
    numberLabel.textColor = [UIColor whiteColor];
    numberLabel.font = [UIFont systemFontOfSize:12];
    numberLabel.text = [NSString stringWithFormat:@"0"];
    [shopBtn addSubview:numberLabel];
    [shopBtn addSubview:imageView];
    
    
    
    
    
    
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:shopBtn];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    
    //自定义返回按钮
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.backBarButtonItem = item;
    
    
    
    UIImage *imagNormal = [UIImage imageNamed:@"1.png"];
    UITabBarItem *v1 = [[UITabBarItem alloc]initWithTitle:@"KaKa美食" image:imagNormal tag:3];
    self.tabBarItem = v1;

    
    
    
    
    [self requestCateData];
//    [self inittbView];
    
    
}


- (void)inittbView
{
//    NSLog(@"SADSADSAD");
    
 
    
    
//    UIScreen *currentScreen = [UIScreen mainScreen];
    
    _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, xwidth, yHeight-64-49)];
    
    self.navigationController.automaticallyAdjustsScrollViewInsets = YES;
    _tbView.delegate = self;
    _tbView.dataSource = self;
    _tbView.backgroundColor = [UIColor redColor];
    _tbView.backgroundColor = [UIColor colorWithRed:204/255.0 green:235/255.0 blue:168/255.0 alpha:1.0];
    
    
    _tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    _tbView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [_tbView registerNib:[UINib nibWithNibName:@"HomeCell" bundle:nil] forCellReuseIdentifier:@"HomeCell"];
//    _tbView.opaque = NO;
    
    [self.view addSubview:_tbView];
    
    
    
    
    
}

- (void)requestCateData
{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载....";
    NSString *str = @"http://wx.dearkaka.com/kaka/kaka-api!menus.shtml";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
    
        for (int j=0;j<array.count;j++)
        {
            NSDictionary *Dic = array[j];
            CateModel *model = [[CateModel alloc]init];
            
            model.Id = Dic[@"id"];
            //            NSLog(@"%@",model.Id);
            model.isDel = Dic[@"isDel"];
            model.leaf = Dic[@"leaf"];
            model.menuName = Dic[@"menuName"];
            model.type = Dic[@"type"];
            model.isOpening = NO;
            
            //            NSLog(@"%@",model.menuName);
            
            //多路POST请求
            NSString *s = @"http://wx.dearkaka.com/kaka/kaka-api!commoditys.shtml";
            
            NSURL *url = [NSURL URLWithString:s];
            //            设置请求体
            NSString *body = [NSString stringWithFormat:@"pageVO.menuName=%@",model.menuName];
            //        NSLog(@"%@",model.menuName);
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
            
            [request setHTTPMethod:@"POST"];
            [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            int long bodyLen = [body lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
            NSString *l = [NSString stringWithFormat:@"%ld", bodyLen];
            
            [request addValue:l forHTTPHeaderField:@"Content-Length"];
            // 将请求参数转化为二进制 设置到请求体中
            NSData *d = [body dataUsingEncoding:NSUTF8StringEncoding];
            
            [request setHTTPBody:d];
            
        
            
            AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc]initWithRequest:request];
            op.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                //            NSLog(@"SUCCESS %i",i);
                NSArray *array1 = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                
                //            NSLog(@"%lu",(unsigned long)array1.count);
                
                for (int i=0; i<array1.count; i++)
                {
                    
                    NSDictionary *foodDic = array1[i];
                    FoodModel *fmodel = [[FoodModel alloc]init];
                    
                    //                    NSLog(@"%@",fmodel.bewrite);
                    fmodel.showImg = foodDic[@"showImg"];
                    
                    fmodel.combination = foodDic[@"combination"];
                    fmodel.commodityName = foodDic[@"commodityName"];
                    
                    fmodel.price = foodDic[@"price"];
                    //                    NSLog(@"%@",fmodel.price);
                    fmodel.heat = foodDic[@"heat"];
                    fmodel.fiber = foodDic[@"fiber"];
                    fmodel.protein = foodDic[@"protein"];
                    fmodel.va = foodDic[@"va"];
                    fmodel.vc = foodDic[@"vc"];
                    fmodel.ve = foodDic[@"ve"];
                    fmodel.mg = foodDic[@"mg"];
                    fmodel.fe = foodDic[@"fe"];
                    fmodel.zn = foodDic[@"zn"];
                    fmodel.k = foodDic[@"k"];
                    fmodel.Id = foodDic[@"id"];
                    fmodel.type = foodDic[@"type"];
                    fmodel.isPackage = foodDic[@"isPackage"];
                    fmodel.ca = foodDic[@"ca"];
                    fmodel.bewrite = foodDic[@"bewrite"];
                    fmodel.number = 1;
                    NSArray *commodityArr = foodDic[@"commoditys"];
                    fmodel.commodityArray = commodityArr;
//                    NSLog(@"%i",fmodel.commodityArray.count);
                    
                    
                    [model.Foodarray addObject:fmodel];
                    if (j==array.count-1 && i==array1.count-1)
                    {
                        
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        
                        [self inittbView];
                    }

                }
               
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络不给力" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
                NSLog(@"web error!");
                
            }];
            
            [[NSOperationQueue mainQueue] addOperation:op];
            
            [cateArray addObject:model];
           
            
        }
        
        
        
        
        
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        
//        [self inittbView];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"网络未连接" message:@"请检查网络设置后,点击确定按钮重新加载" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alertView show];
        NSLog(@"web error!");
        
        
    }];
    
    
    
}

- (void)requestFoodData
{

   
   
  



}

#pragma mark - UIAlertViewDelagate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (buttonIndex==0)
    {
        
        [self requestCateData];
    }



}

- (void)btClick:(UIButton *)bt
{
    
    if (isClicked)
    {
        
        [leftBtn setTitle:@"展开全部" forState:UIControlStateNormal];
        
        for (int i=0; i<cateArray.count; i++)
        {
            
            CateModel *model = cateArray[i];
            model.isOpening = NO;

            
        }
        
        
        [_tbView reloadData];
        
        //        NSLog(@"展开全部");
        isClicked = NO;
    }
    else if (!isClicked)
    {
        [leftBtn setTitle:@"收起全部" forState:UIControlStateNormal];
        for (int i=0; i<cateArray.count; i++)
        {
            
            CateModel *model = cateArray[i];
            model.isOpening = YES;
            
            
        }
        
        
        [_tbView reloadData];
        
        isClicked = YES;
    }
    
    
    
}


- (void)shop:(UIButton *)bt
{
    

   
    
   
//        ShopCarViewController *shop = [[ShopCarViewController alloc]init];
//        
//        [self.navigationController pushViewController:shop animated:YES];
        
        self.tabBarController.selectedIndex = 2;
        
        
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return cateArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    
    CateModel *model = cateArray[section];
    
    if (model.isOpening)
    {
        return [model.Foodarray count];
        
    }
    else
    {
        
        
        return 0;
        
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell"];
    
    
    CateModel *model = cateArray[indexPath.section];
    FoodModel *fmodel = model.Foodarray[indexPath.row];
    cell.fmodel = fmodel;
    
    //    [cell.ImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://wx.dearkaka.com/kaka/%@",fmodel.showImg]]];
    cell.backgroundColor = [UIColor colorWithRed:204/255.0 green:235/255.0 blue:168/255.0 alpha:1.0];
    //    cell.textLabel.text = fmodel.commodityName;
    //    cell.detailTextLabel.text = fmodel.combination;
    
    cell.layer.borderColor = [UIColor colorWithRed:32.0/255.0 green:121.0/255.0 blue:66.0/255.0 alpha:1.0].CGColor;
    
    cell.layer.borderWidth = 0.3;
    //    cell.alpha = 0.5;
    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
    
    
    
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,30)];

    
    UILabel *label=[[UILabel alloc]init];
    label.backgroundColor=[UIColor colorWithRed:32.0/255.0 green:121.0/255.0 blue:66.0/255.0 alpha:1.0];
    label.tag=section+10;
    label.frame=CGRectMake(0, 0, self.view.frame.size.width, 40);
    label.textColor = [UIColor whiteColor];
    
    
    label.layer.borderWidth = 0.5;
    label.layer.borderColor = [[UIColor colorWithRed:204/255.0 green:235/255.0 blue:168/255.0 alpha:1.0] CGColor];

    
    
    
    CateModel *model = cateArray[section];
    label.font = [UIFont systemFontOfSize:15];
    label.text = [NSString stringWithFormat:@"    %@",model.menuName];
    
    
    
    
    
    
    //添加点击的手势
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBtClick:)];
    [label addGestureRecognizer:tap];
    //支持点击事件
    label.userInteractionEnabled=YES;

    
       //        view.backgroundColor = [UIColor colorWithRed:32.0/255.0 green:121.0/255.0 blue:66.0/255.0 alpha:1.0];
        [view addSubview:label];
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-20, 10, 20, 20)];
   
   
    
    
    
    if (isClicked)
    {
        
            imageView.image = [UIImage imageNamed:@"up"];
    }
    else
    {
        
            imageView.image = [UIImage imageNamed:@"down"];
        
    }
    
    model.imageView = imageView;
    [view addSubview:imageView];
    return view;
    
    
    
    
    
    
    
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    
    
    return 40;
    
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    return 100;
    
}
//当点击viewForHeader,调用的方法
-(void)tapBtClick:(UITapGestureRecognizer *)tap
{
    
    //从新加载Sections
    //    [tbView reloadSections:[NSIndexSet indexSetWithIndex:tap.view.tag-10] withRowAnimation:UITableViewRowAnimationFade];
    
    
    CateModel *model = cateArray[tap.view.tag-10];
    model.isOpening = !model.isOpening;
    
    [_tbView reloadSections:[NSIndexSet indexSetWithIndex:tap.view.tag-10] withRowAnimation:UITableViewRowAnimationFade];
    
    UIImageView *imageView = model.imageView;
    
//    imageView.image = [UIImage imageNamed:@"up"];
    

    if (model.isOpening) {
 
        imageView.image = [UIImage imageNamed:@"up"];

    }
    else
    {
    
        imageView.image = [UIImage imageNamed:@"down"];

    
    }
    
//    NSLog(@"headView被点击了");
    
}
 




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DetailViewController *detail = [[DetailViewController alloc]init];
    
    
    CateModel *model = cateArray[indexPath.section];
    FoodModel *fmodel = model.Foodarray[indexPath.row];
    
    detail.title = fmodel.commodityName;
    detail.fmodel = fmodel;
    [self.navigationController pushViewController:detail animated:YES];
    
      [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleNotification:) name:@"notif" object:nil];
    
  
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handle:) name:@"shop" object:nil];


}

- (void)handle:(NSNotification *)n
{
    NSMutableArray *array = [n object];
    numberLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)array.count];



}
- (void)handleNotification:(NSNotification *)n
{
    NSMutableArray *array = [n object];
    
    numberLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)array.count];
    
    



}

- (void)free
{

// removeObserver ,该方法为取消监听，释放内存
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"notif" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"shop" object:nil];
    
}
@end
