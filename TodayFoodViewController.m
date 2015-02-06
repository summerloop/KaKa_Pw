//
//  TodayFoodViewController.m
//  KaKa_Pw
//
//  Created by Plizarwireless on 14/12/25.
//  Copyright (c) 2014年 Plizarwireless. All rights reserved.
//

#import "TodayFoodViewController.h"
#import "AFNetworking.h"  //异步解析数据类封装
#import "MBProgressHUD.h"  //活动显示器
#import "CateModel.h"   //分类目录模型

#import "GridFoodModel.h" //日常餐数据模型
#import "GridCell.h"   //自定制今日摄入cell
#import "CalFoodModel.h"

@interface TodayFoodViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

{

    UITableView *_tbView;
    float xWidth;     //运行此程序设备的屏幕宽度
    float yHeight;    //运行此程序设备的屏幕高度


    UIButton *leftBtn;     //左侧按钮


    BOOL isClicked;     //纪录左侧按钮点击状态
    NSArray *_sortArr;
    NSMutableArray *_cateArray;

   
}
@end

@implementation TodayFoodViewController


+(NSMutableArray *)ShareMultArr
{
    static NSMutableArray *multArray = nil;
    
    if (multArray==nil)
    {
        
        multArray = [[NSMutableArray alloc]init];
        
    }
    
    
    return multArray;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
        
    {
        
        _cateArray = [NSMutableArray array];
     
       
        
        xWidth = [UIScreen mainScreen].bounds.size.width;
        yHeight = [UIScreen mainScreen].bounds.size.height;
        isClicked = NO;

    }
    

    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    _sortArr = @[@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i"];
    
    
    self.view.backgroundColor = [UIColor colorWithRed:204/255.0 green:235/255.0 blue:168/255.0 alpha:1.0];

    self.navigationController.navigationBar.translucent = NO;
       //标题栏
    self.title = @"今日摄入食物";
    
    //右侧按钮
    UIButton *checkBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    checkBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [checkBtn setTitle:@"查看分数" forState:UIControlStateNormal];
    [checkBtn addTarget:self action:@selector(check:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:checkBtn];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    
//    左侧按钮
    leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    
    [leftBtn addTarget:self action:@selector(btClick:) forControlEvents:UIControlEventTouchUpInside];
    
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [leftBtn setTitle:@"展开全部" forState:UIControlStateNormal];
    
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    
   
//    [self inittableView];
    [self requestKaKaFoodData];
    
//     [self requestGridFoodData];
}

#pragma mark - 加载tableview
- (void)inittableView
{

    _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, xWidth, yHeight-64)];
    
    
    _tbView.backgroundColor = [UIColor colorWithRed:204/255.0 green:235/255.0 blue:168/255.0 alpha:1.0];
    _tbView.delegate = self;
    _tbView.dataSource = self;
    
    _tbView.tableFooterView = [[UIView alloc]init];
    [_tbView registerNib:[UINib nibWithNibName:@"GridCell" bundle:nil] forCellReuseIdentifier:@"GCell"];
    
    

    
    [self.view addSubview:_tbView];



}



#pragma mark - 左侧按钮
- (void)btClick:(UIButton *)bt
{
    
    if (isClicked)
    {
        
        [leftBtn setTitle:@"展开全部" forState:UIControlStateNormal];
        
        for (int i=0; i<_cateArray.count; i++)
        {
            
            CateModel *model = _cateArray[i];
            model.isOpening = NO;
            
            
        }
        
        
        [_tbView reloadData];
        
        //        NSLog(@"展开全部");
        isClicked = NO;
    }
    else if (!isClicked)
    {
        [leftBtn setTitle:@"收起全部" forState:UIControlStateNormal];
        for (int i=0; i<_cateArray.count; i++)
        {
            
            CateModel *model = _cateArray[i];
            model.isOpening = YES;
            
            
        }
        
        
        [_tbView reloadData];
        
        ;        isClicked = YES;
    }
    
    
    
}


#pragma mark - 请求数据
- (void)requestKaKaFoodData
{


   
//    卡卡餐：http://wx.dearkaka.com/kaka/kaka-api!commoditys.shtml
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText = @"正在加载";
    
    NSString *str = @"http://wx.dearkaka.com/kaka/kaka-api!commoditys.shtml";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        CateModel *cmodel = [[CateModel alloc]init];
        cmodel.typeName = @"卡卡餐";
        for (NSDictionary *Dic in array)
        {
            
            GridFoodModel *gmodel = [[GridFoodModel alloc]init];
            
            
            gmodel.heat = Dic[@"heat"];
            gmodel.k = Dic[@"k"];
            gmodel.zn = Dic[@"zn"];
            gmodel.fe = Dic[@"fe"];
            gmodel.ca = Dic[@"ca"];
            gmodel.mg = Dic[@"mg"];
            gmodel.ve = Dic[@"ve"];
            gmodel.vc = Dic[@"vc"];
            gmodel.va = Dic[@"va"];
            gmodel.protein = Dic[@"protein"];
            gmodel.fiber = Dic[@"fiber"];
            gmodel.Id = Dic[@"id"];
            gmodel.foodName = Dic[@"commodityName"];
            gmodel.isDel = Dic[@"isDel"];
            gmodel.typeName = @"卡卡餐";
            
            [cmodel.Foodarray addObject:gmodel];
            
            
        }
        
        [_cateArray addObject:cmodel];
        
        [self requestGridFoodData];
//          [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络不给力" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
//        NSLog(@"web error!");
    }];
  
    

}

- (void)requestGridFoodData
{

    
    //    日常餐： http://wx.dearkaka.com/kaka/kaka-api!findKaKaFoodGrid.shtml
    
    NSString *str = @"http://wx.dearkaka.com/kaka/kaka-api!findKaKaFoodGrid.shtml";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        for (int i=0; i<_sortArr.count; i++)
     {
         
         NSMutableArray *_tempArr = [NSMutableArray array];
         
            CateModel *cmodel = [[CateModel alloc]init];

           for (int j=0;j<array.count;j++)
          {
            
            NSDictionary *Dic = array[j];
            
            GridFoodModel *gmodel = [[GridFoodModel alloc]init];
            
            
            gmodel.heat = Dic[@"heat"];
            gmodel.k = Dic[@"k"];
            gmodel.zn = Dic[@"zn"];
            gmodel.fe = Dic[@"fe"];
            gmodel.ca = Dic[@"ca"];
            gmodel.mg = Dic[@"mg"];
            gmodel.ve = Dic[@"ve"];
            gmodel.vc = Dic[@"vc"];
            gmodel.va = Dic[@"va"];
            gmodel.protein = Dic[@"protein"];
            gmodel.fiber = Dic[@"fiber"];
            gmodel.Id = Dic[@"id"];
            gmodel.foodName = Dic[@"foodName"];
            gmodel.isDel = Dic[@"isDel"];
//            gmodel.typeName = Dic[@"typeName"];
            
              
            NSArray *Namearray = [Dic[@"typeName"] componentsSeparatedByString:@"-"];
            gmodel.typeName = Namearray[1];
              gmodel.fulltypeName = Namearray[0];
//              NSLog(@"%@",gmodel.fulltypeName);
            
              if ([Namearray[0] isEqualToString:_sortArr[i]])
              {
                  
//
                  [_tempArr addObject:gmodel];
                  
                  cmodel.typeName = gmodel.typeName;
              }
             
              cmodel.Foodarray = _tempArr;
        }
         
         [_cateArray addObject:cmodel];
         
    }
       
//        NSLog(@"%lu",(unsigned long)_cateArray.count);
    
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [self addNumbers];
        [self inittableView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络不给力" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];//        NSLog(@"web error!");
    }];

    
    

}


- (void)addNumbers
{

    for (int i=0; i<_cateArray.count; i++)
    {
        CateModel *cmodel = _cateArray[i];
        
        for (int j=0; j<cmodel.Foodarray.count; j++)
        {
            GridFoodModel *gmodel = cmodel.Foodarray[j];
            
            for (int k=0; k<_todayArray.count; k++)
            {
                
                CalFoodModel *calmodel  = _todayArray[k];
                
                if ([gmodel.foodName isEqualToString:calmodel.foodName])
                {
                    
                    gmodel.number = [calmodel.num intValue];
                    
                }
                
            }
            
        }
        
        
    }



}
#pragma mark - UIAlertViewDelagate
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    
//    if (buttonIndex==0)
//    {
//        
//        [self requestKaKaFoodData];
//    }
//    
//    
//    
//}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{



    return _cateArray.count;


}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  
    
    CateModel *model = _cateArray[section];
    
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


//    static NSString *str = @"cell_ID";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
//    if (!cell)
//    {
//        
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
//        
//        
//    }
    
//    for (UIView *view in cell.contentView.subviews)
//    {
//        
//        [view removeFromSuperview];
//    }
//    cell.backgroundColor = [UIColor colorWithRed:204/255.0 green:235/255.0 blue:168/255.0 alpha:1.0];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    CateModel *model = _cateArray[indexPath.section];
//    GridFoodModel *gmodel = model.Foodarray[indexPath.row];
//    
//    cell.layer.borderColor = [UIColor colorWithRed:32.0/255.0 green:121.0/255.0 blue:66.0/255.0 alpha:1.0].CGColor;
//    
//    cell.layer.borderWidth = 0.3;
//    cell.textLabel.text = gmodel.foodName;
//    cell.textLabel.font = [UIFont systemFontOfSize:14];
//    
//    UIButton *addBtn = [[UIButton alloc]initWithFrame:CGRectMake(xWidth/2+60, 13, 20, 20)];
////    addBtn.backgroundColor = [UIColor redColor];
////    [addBtn setImage:[UIImage imageNamed:@"加号_03"] forState:UIControlStateNormal];
//    [addBtn setBackgroundImage:[UIImage imageNamed:@"减号_03"] forState:UIControlStateNormal];
//    
//    UITextField *text = [[UITextField alloc]initWithFrame:CGRectMake(xWidth/2+85, 13, 30, 20)];
// 
//    
//    
//    text.tag = 10;
//    text.font = [UIFont systemFontOfSize:15];
//    text.borderStyle = UITextBorderStyleRoundedRect;
//    text.keyboardType=UIKeyboardTypeNumberPad;
//    text.textAlignment = NSTextAlignmentCenter;
//    text.backgroundColor = [UIColor whiteColor];
//    [cell.contentView addSubview:text];
//    
//    [cell.contentView addSubview:addBtn];
//    
//    
//    return cell;
    

    GridCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"GCell" forIndexPath:indexPath];
    
    cell1.backgroundColor = [UIColor colorWithRed:204/255.0 green:235/255.0 blue:168/255.0 alpha:1.0];
    cell1.layer.borderWidth = 0.3;
    cell1.layer.borderColor = [UIColor colorWithRed:32.0/255.0 green:121.0/255.0 blue:66.0/255.0 alpha:1.0].CGColor;
    cell1.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    CateModel *model = _cateArray[indexPath.section];
    GridFoodModel *gmodel = model.Foodarray[indexPath.row];
    

    cell1.gmodel = gmodel;
    cell1.gCellBlock = ^(int number){
    
    
        gmodel.number = number;
//        NSLog(@"today%i",gmodel.number);
        
    };
    
    
    
    return cell1;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{


//    CateModel *cmodel = _cateArray[indexPath.section];
//    GridFoodModel *gmodel = cmodel.Foodarray[indexPath.row];
    
    
    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];

//    NSLog(@"did select");


}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{



    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,40)];
    
    
    UILabel *label=[[UILabel alloc]init];
    label.backgroundColor=[UIColor colorWithRed:32.0/255.0 green:121.0/255.0 blue:66.0/255.0 alpha:1.0];
    label.tag=section+10;
    label.frame=CGRectMake(0, 0, self.view.frame.size.width, 40);
    label.textColor = [UIColor whiteColor];
    
    
    label.layer.borderWidth = 0.5;
    label.layer.borderColor = [[UIColor colorWithRed:204/255.0 green:235/255.0 blue:168/255.0 alpha:1.0] CGColor];
    
    
    
    
    CateModel *model = _cateArray[section];
    label.font = [UIFont systemFontOfSize:15];
    label.text = [NSString stringWithFormat:@"    %@",model.typeName];
    
    
    
    
    
    
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



//当点击viewForHeader,调用的方法
-(void)tapBtClick:(UITapGestureRecognizer *)tap
{
    
    //从新加载Sections
    //    [tbView reloadSections:[NSIndexSet indexSetWithIndex:tap.view.tag-10] withRowAnimation:UITableViewRowAnimationFade];
    
    
    CateModel *model = _cateArray[tap.view.tag-10];
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


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{




    return 40;

}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

//    CateModel *cmodel = _cateArray[indexPath.section];
//    GridFoodModel *gmodel = cmodel.Foodarray[indexPath.row];
//    
//    if (gmodel.number>0)
//    {
//        
//    }
//    


    return 44;


}



#pragma mark - 查看营养分数
- (void)check:(UIButton *)bt
{


    for (int i=0; i<_cateArray.count; i++)
    {
        CateModel *cmodel = _cateArray[i];
        
        for (int j=0; j<cmodel.Foodarray.count; j++)
        {
            GridFoodModel *gmodel = cmodel.Foodarray[j];
            
            if (gmodel.number>0)
            {
                
                
                [[TodayFoodViewController ShareMultArr]addObject:gmodel];
                
                
            }
        }
        
        
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"styleNotif" object:@"4" userInfo:nil];
    
    
//    [self.navigationController popViewControllerAnimated:YES];

    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
        
    }];

    

}



#pragma mark - 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
