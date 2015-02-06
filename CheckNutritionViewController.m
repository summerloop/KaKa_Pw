//
//  CheckNutritionViewController.m
//  KaKa_Pw
//
//  Created by Plizarwireless on 14/12/17.
//  Copyright (c) 2014年 Plizarwireless. All rights reserved.
//

#define SAVETODAYKAKA @"http://wx.dearkaka.com/kaka/kaka-api!saveMyKaKa.shtml"
// Need memberID
#import "MBProgressHUD.h"
#import "CheckNutritionViewController.h"
#import "BuyInfo.h"
#import "FoodModel.h"
#import "commodityModel.h"
#import "TodayFoodViewController.h"
#import "CalFoodModel.h"
#import "OrderInfoModel.h"
#import "GridFoodModel.h"
#import "AFNetworking.h"
@interface CheckNutritionViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{

    float xWidth;
    float yHeight;

    UITableView *_tbView;
    //总卡路里量
    float totalCalorie;   //购物车页面进入用到
    float totalCalorie1;   //日历页面进入用到
    float totalCalorie2;
    float totalCalorie3;  //
    float totalCalorie4;   //日常餐查看营养分数用到
    
    NSArray *_labels;
    NSArray *_nameLabels;
    NSMutableArray *_properyArray;
    
    NSArray *_faileArr;
    NSArray *_passArr;
    NSArray *_goodArr;
    
    NSMutableArray *foodArr;
    
    UIAlertView *alert1;
    UIAlertView *alert2;
  
    NSString *KaKaFoodParames;
    NSMutableArray *ParamesArr;
}
@end

@implementation CheckNutritionViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
       
        foodArr = [NSMutableArray array];
        _properyArray = [NSMutableArray array];
        ParamesArr = [NSMutableArray array];
    }


    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    NSLog(@"view did load");
    
     UIScreen *currentScreen = [UIScreen mainScreen];
   xWidth = currentScreen.bounds.size.width;
   yHeight = currentScreen.bounds.size.height;
  
    self.title = @"营养自测详情";
    
    _labels = @[@"钾",@"锌",@"铁",@"钙",@"镁",@"Ve",@"Vc",@"Va",@"蛋白质",@"纤维素"];
    _nameLabels = @[@"钾",@"锌",@"铁",@"钙",@"镁",@"维E",@"维C",@"维A",@"蛋白质",@"纤维素"];
    _faileArr = @[@"严重警告！缺钾会引起心跳过速、心率不齐，肌肉无力、易怒、恶心、呕吐、腹泻、低血压、精神错乱、以及心理冷淡！没错，说的就是你～",@"严重警告！缺锌会损害细胞的免疫功能，容易患感染性疾病，上呼吸道感染、支气管肺炎、反复感冒或腹泻！千万不要再掉以轻心啦！",@"严重警告！铁是给细胞打气供氧的重要矿物质，也是保持气色红润的关键哦，缺乏会导致皮肤苍白，贫血,对免疫系统有很大的影响！你最近是不是感觉无精打采，很容易疲劳呢:(",@"严重警告！钙是骨骼强壮、维持肌肉的收缩和神经冲动的传递的重要营养素。不达标会导致骨质疏松、手足抽搐、乏力；另外，失眠、经前抽筋、怕冷、易紧张哦！还等什么，赶紧补钙吧！",@"严重警告！缺镁会导致记忆力明显减退、精神紧张、易激动、神志不清、烦躁不安。时常还伴有恶心、呕吐、及态度淡漠！再也不可以对自己这样冷漠:(",@"严重警告！维生素e可是不老神器，缺乏会使体内产生大量的自由基，导致免疫力下降、代谢失常，迅速变衰老噢:(",@"严重警告！维生素c是维持身体正常代谢的万能小天使，缺乏会导致皮肤、气色变差，全身乏力、抑郁。而且细胞壁会很脆弱 ，容易淤青，红肿，牙龈出血呢:(",@"严重警告！维生素a 是细胞“滋润”因子，缺乏会严重皮肤干干眼睛干干的哦:(",@"严重警告！蛋白质是生命的物质基础，缺乏会导致代谢率下降、体质衰退、抵抗力减退、易患病，甚至器官的损害！快快行动起来，让淡漠、易怒、贫血、干瘦病或水肿，离你远远的！",@"严重警告！膳食纤维不能缺噢 便便会不顺畅的。太多“垃圾”堵在肠道，产生的毒素会让我们的免疫力变差，皮肤和情绪也会变得很糟糕！"];
//    NSLog(@"%i",_faileArr.count);
    
    _passArr = @[@"你的摄入量还不够理想，只刚刚满足了“低保户“要求，小心脏的质量需要继续努力！",@"你的摄入量还不够理想。想让细胞免疫力更强吗，那就继续努力吧！～",@"你的摄入量还不够理想。你懂的，男生女生都需要得更多的它 ，快快补充哦！",@"你的摄入量还不够理想。每日充值的钙会帮助肠道内多余脂肪排出体外，清肠又瘦身噢～",@"你的摄入量还不够理想。让好记性好脾气不要越走越远哦，再接再厉！",@"你的摄入量还不够理想。一不小心,自由基会反复产生哦， 快去消灭它！",@"你的摄入量还不够理想。维c是水溶性维生素, 一不小心就会下滑，要继续加油补够噢～",@"你的摄入量还不够理想。维生素a，c e可是抗自由基的金三角!继续加油,帮助小伙伴们打败自由基~",@"你的摄入量还不够理想，怒放的生命很容易体质衰退，快快重视起来！",@"你的摄入量还不够理想，膳食纤维可以增加饱腹感噢，继续努力，你会发现自己离油腻更远，身材越来越好呢～"];
//    NSLog(@"%i",_passArr.count);
    
    _goodArr = @[@"继续保持哦~血压正常了，心跳正常了，心情也更好啦！",@"继续保持哦~每颗细胞都在变强，打败病毒你最大～！",@"继续保持哦~红红的，红红的，你那红红的小脸蛋！～",@"继续保持哦~有没有感觉自己运动自如，心情松弛了呢～:)",@"继续保持哦~最近是否淡定许多呢，哈～",@"继续保持哦~就这样一直不老的美下去！",@"继续保持哦~看见自己容光焕发、气色红润了么？维C还会有效的促进铁的吸收呢～",@"继续保持哦~有没有感觉眼睛明亮,皮肤光泽了呢?自由基也被你给“亮瞎”了呢:)",@"继续保持哦~健康＋活力＋肌肉style噢～",@"继续保持哦~饭饭每日精， 便便每天见 ！"];
//    NSLog(@"-------------%i",_goodArr.count);
    
    
    
    self.navigationController.navigationBar.translucent = NO;
  _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, xWidth, yHeight-64+49)];
    
    
    _tbView.backgroundColor = [UIColor colorWithRed:204/255.0 green:235/255.0 blue:168/255.0 alpha:1.0];
    _tbView.delegate = self;
    _tbView.dataSource = self;
    [self.view addSubview:_tbView];
    
    
    
}



- (void)setTodayArray:(NSMutableArray *)TodayArray
{


    _TodayArray = TodayArray;
    
    float k = 0.0;
    float zn = 0.0;
    float fe = 0.0;
    float ca = 0.0;
    float mg = 0.0;
    float ve = 0.0;
    float vc = 0.0;
    float va = 0.0;
    float protein = 0.0;
    float fiber = 0.0;
    float calorie = 0.0;
    

    for (int i=0; i<_TodayArray.count; i++)
    {
        
        CalFoodModel *cfModel = _TodayArray[i];
        int num = [cfModel.num intValue];
        k += [cfModel.k floatValue]*num;
        zn += [cfModel.zn floatValue]*num;
        fe += [cfModel.fe floatValue]*num;
        ca += [cfModel.ca floatValue]*num;
        mg += [cfModel.mg floatValue]*num;
        ve += [cfModel.ve floatValue]*num;
        vc += [cfModel.vc floatValue]*num;
        va += [cfModel.va floatValue]*num;
        protein += [cfModel.protein floatValue]*num;
        fiber += [cfModel.fiber floatValue]*num;
        
        calorie = [cfModel.heat floatValue]*num +calorie;
        
        
         [ParamesArr addObject:[NSString stringWithFormat:@"%@-%i-0",cfModel.Id,[cfModel.num intValue]]];
        
        
    }

    totalCalorie2 = calorie;
    NSNumber *number1 = [NSNumber numberWithFloat:k];
    [_properyArray addObject:number1];
    
    NSNumber *number2 = [NSNumber numberWithFloat:zn];
    [_properyArray addObject:number2];
    
    
    NSNumber *number3 = [NSNumber numberWithFloat:fe];
    [_properyArray addObject:number3];
    
    NSNumber *number4 = [NSNumber numberWithFloat:ca];
    [_properyArray addObject:number4];
    NSNumber *number5 = [NSNumber numberWithFloat:mg];
    [_properyArray addObject:number5];
    NSNumber *number6 = [NSNumber numberWithFloat:ve];
    [_properyArray addObject:number6];
    NSNumber *number7 = [NSNumber numberWithFloat:vc];
    [_properyArray addObject:number7];
    
    NSNumber *number8 = [NSNumber numberWithFloat:va];
    [_properyArray addObject:number8];
    NSNumber *number9 = [NSNumber numberWithFloat:protein];
    [_properyArray addObject:number9];
    NSNumber *number10 = [NSNumber numberWithFloat:fiber];
    [_properyArray addObject:number10];




}
- (void)setInfoArray:(NSMutableArray *)infoArray
{

    _infoArray = infoArray;
    float calorie = 0.0;
    
    float k = 0.0;
    float zn = 0.0;
    float fe = 0.0;
    float ca = 0.0;
    float mg = 0.0;
    float ve = 0.0;
    float vc = 0.0;
    float va = 0.0;
    float protein = 0.0;
    float fiber = 0.0;

    
    for (int i=0; i<_infoArray.count; i++)
    {
        
        BuyInfo *info = _infoArray[i];
        FoodModel *fmodel = info.fmodel;
        commodityModel *cmodel = info.cmodel;
        
        calorie = [fmodel.heat floatValue]+[cmodel.heat floatValue]+calorie;
        
        k += [fmodel.k floatValue]+[cmodel.k floatValue];
        zn += [fmodel.zn floatValue] + [cmodel.k floatValue];
        fe += [fmodel.fe floatValue] + [cmodel.fe floatValue];
        ca += [fmodel.ca floatValue] + [cmodel.ca floatValue];
        mg += [fmodel.mg floatValue] + [cmodel.mg floatValue];
        ve += [fmodel.ve floatValue] + [cmodel.ve floatValue];
        vc += [fmodel.vc floatValue] + [cmodel.vc floatValue];
        va += [fmodel.va floatValue] + [cmodel.va floatValue];
        protein += [fmodel.protein floatValue] + [cmodel.protein floatValue];
        fiber += [fmodel.fiber floatValue] + [cmodel.fiber floatValue];
        
    }
        totalCalorie = calorie;
        NSNumber *number1 = [NSNumber numberWithFloat:k];
        [_properyArray addObject:number1];
    
        NSNumber *number2 = [NSNumber numberWithFloat:zn];
        [_properyArray addObject:number2];
    
    
        NSNumber *number3 = [NSNumber numberWithFloat:fe];
        [_properyArray addObject:number3];
    
        NSNumber *number4 = [NSNumber numberWithFloat:ca];
        [_properyArray addObject:number4];
        NSNumber *number5 = [NSNumber numberWithFloat:mg];
        [_properyArray addObject:number5];
        NSNumber *number6 = [NSNumber numberWithFloat:ve];
        [_properyArray addObject:number6];
        NSNumber *number7 = [NSNumber numberWithFloat:vc];
        [_properyArray addObject:number7];
    
        NSNumber *number8 = [NSNumber numberWithFloat:va];
        [_properyArray addObject:number8];
        NSNumber *number9 = [NSNumber numberWithFloat:protein];
        [_properyArray addObject:number9];
        NSNumber *number10 = [NSNumber numberWithFloat:fiber];
        [_properyArray addObject:number10];

    
    
    }

- (void)setCalenDarArray:(NSMutableArray *)calenDarArray
{

   
    _calenDarArray = calenDarArray;
    
    float k = 0.0;
    float zn = 0.0;
    float fe = 0.0;
    float ca = 0.0;
    float mg = 0.0;
    float ve = 0.0;
    float vc = 0.0;
    float va = 0.0;
    float protein = 0.0;
    float fiber = 0.0;
     float calorie = 0.0;
    
    for (int i=0; i<_calenDarArray.count; i++)
    {
        
        CalFoodModel *cfModel = [[CalFoodModel alloc]init];
        
        NSDictionary *dic = _calenDarArray[i];
        
        cfModel.num = dic[@"num"];
        
        NSDictionary *commodityDic = dic[@"commodity"];
        NSDictionary *gridDic = dic[@"kakaFoodGrid"];
        
//        NSLog(@"%@",commodityDic);
//        NSLog(@"%@",gridDic);
        
        if (![dic[@"commodity"] isEqual:[NSNull null]])
        {
          
            cfModel.k = commodityDic[@"k"];
            cfModel.zn = commodityDic[@"zn"];
            cfModel.fe = commodityDic[@"fe"];
            cfModel.ca = commodityDic[@"ca"];
            cfModel.mg = commodityDic[@"mg"];
            cfModel.ve = commodityDic[@"ve"];
            cfModel.vc = commodityDic[@"vc"];
            cfModel.va = commodityDic[@"va"];
            cfModel.protein = commodityDic[@"protein"];
            cfModel.fiber = commodityDic[@"fiber"];
            cfModel.heat = commodityDic[@"heat"];
            cfModel.foodName = commodityDic[@"commodityName"];
            cfModel.Id = commodityDic[@"id"];
            
            k += [cfModel.k floatValue]*[dic[@"num"] intValue];
            zn += [cfModel.zn floatValue]*[dic[@"num"] intValue];
            fe += [cfModel.fe floatValue]*[dic[@"num"] intValue];
            ca += [cfModel.ca floatValue]*[dic[@"num"] intValue];
            mg += [cfModel.mg floatValue]*[dic[@"num"] intValue];
            ve += [cfModel.ve floatValue]*[dic[@"num"] intValue];
            vc += [cfModel.vc floatValue]*[dic[@"num"] intValue];
            va += [cfModel.va floatValue]*[dic[@"num"] intValue];
            protein += [cfModel.protein floatValue]*[dic[@"num"] intValue];
            fiber += [cfModel.fiber floatValue]*[dic[@"num"] intValue];
            
            calorie = [cfModel.heat floatValue]*[dic[@"num"] intValue] +calorie;
            [foodArr addObject:cfModel];
            
            
            
        }
        
        else
        {
        
        
            cfModel.k = gridDic[@"k"];
            cfModel.zn = gridDic[@"zn"];
            cfModel.fe = gridDic[@"fe"];
            cfModel.ca = gridDic[@"ca"];
            cfModel.mg = gridDic[@"mg"];
            cfModel.ve = gridDic[@"ve"];
            cfModel.vc = gridDic[@"vc"];
            cfModel.va = gridDic[@"va"];
            cfModel.protein = gridDic[@"protein"];
            cfModel.fiber = gridDic[@"fiber"];
            cfModel.heat = gridDic[@"heat"];
            cfModel.foodName = gridDic[@"foodName"];
            cfModel.Id = gridDic[@"id"];
        
        
            k += [cfModel.k floatValue]*[dic[@"num"] intValue];
            zn += [cfModel.zn floatValue]*[dic[@"num"] intValue];
            fe += [cfModel.fe floatValue]*[dic[@"num"] intValue];
            ca += [cfModel.ca floatValue]*[dic[@"num"] intValue];
            mg += [cfModel.mg floatValue]*[dic[@"num"] intValue];
            ve += [cfModel.ve floatValue]*[dic[@"num"] intValue];
            vc += [cfModel.vc floatValue]*[dic[@"num"] intValue];
            va += [cfModel.va floatValue]*[dic[@"num"] intValue];
            protein += [cfModel.protein floatValue]*[dic[@"num"] intValue];
            fiber += [cfModel.fiber floatValue]*[dic[@"num"] intValue];
        calorie = [cfModel.heat floatValue]*[dic[@"num"] intValue] +calorie;
            [foodArr addObject:cfModel];
        }
        
        
    }
    
    
    totalCalorie1 = calorie;
    
//    NSLog(@"totalHeat %.1f",totalCalorie);
    NSNumber *number1 = [NSNumber numberWithFloat:k];
    [_properyArray addObject:number1];
    
    NSNumber *number2 = [NSNumber numberWithFloat:zn];
    [_properyArray addObject:number2];
    
    
    NSNumber *number3 = [NSNumber numberWithFloat:fe];
    [_properyArray addObject:number3];
    
    NSNumber *number4 = [NSNumber numberWithFloat:ca];
    [_properyArray addObject:number4];
    NSNumber *number5 = [NSNumber numberWithFloat:mg];
    [_properyArray addObject:number5];
    NSNumber *number6 = [NSNumber numberWithFloat:ve];
    [_properyArray addObject:number6];
    NSNumber *number7 = [NSNumber numberWithFloat:vc];
    [_properyArray addObject:number7];
    
    NSNumber *number8 = [NSNumber numberWithFloat:va];
    [_properyArray addObject:number8];
    NSNumber *number9 = [NSNumber numberWithFloat:protein];
    [_properyArray addObject:number9];
    NSNumber *number10 = [NSNumber numberWithFloat:fiber];
    [_properyArray addObject:number10];



//    NSLog(@"foodarr num is %lu",(unsigned long)foodArr.count);


}


- (void)setOrderArray:(NSMutableArray *)orderArray
{

    _orderArray = orderArray;
    float calorie = 0.0;
    
    float k = 0.0;
    float zn = 0.0;
    float fe = 0.0;
    float ca = 0.0;
    float mg = 0.0;
    float ve = 0.0;
    float vc = 0.0;
    float va = 0.0;
    float protein = 0.0;
    float fiber = 0.0;
 
    for (int i=0; i<_orderArray.count; i++)
    {
        OrderInfoModel *model = _orderArray[i];
        
        calorie += [model.heat floatValue]*[model.num intValue];
        
        k += [model.k floatValue]*[model.num intValue];
        zn += [model.zn floatValue]*[model.num intValue];
        fe += [model.fe floatValue] *[model.num intValue];
        ca += [model.ca floatValue] *[model.num intValue];
        mg += [model.mg floatValue]*[model.num intValue];
        ve += [model.ve floatValue]*[model.num intValue];
        vc += [model.vc floatValue]*[model.num intValue];
        va += [model.va floatValue] *[model.num intValue];
        protein += [model.protein floatValue] *[model.num intValue];
        fiber += [model.fiber floatValue] *[model.num intValue];
        
    }
    totalCalorie3 = calorie;
    NSNumber *number1 = [NSNumber numberWithFloat:k];
    [_properyArray addObject:number1];
    
    NSNumber *number2 = [NSNumber numberWithFloat:zn];
    [_properyArray addObject:number2];
    
    
    NSNumber *number3 = [NSNumber numberWithFloat:fe];
    [_properyArray addObject:number3];
    
    NSNumber *number4 = [NSNumber numberWithFloat:ca];
    [_properyArray addObject:number4];
    NSNumber *number5 = [NSNumber numberWithFloat:mg];
    [_properyArray addObject:number5];
    NSNumber *number6 = [NSNumber numberWithFloat:ve];
    [_properyArray addObject:number6];
    NSNumber *number7 = [NSNumber numberWithFloat:vc];
    [_properyArray addObject:number7];
    
    NSNumber *number8 = [NSNumber numberWithFloat:va];
    [_properyArray addObject:number8];
    NSNumber *number9 = [NSNumber numberWithFloat:protein];
    [_properyArray addObject:number9];
    NSNumber *number10 = [NSNumber numberWithFloat:fiber];
    [_properyArray addObject:number10];


}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{


    return 1;

}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    switch (_numberOfStyle)
    {
        case 1:
             return 13+_infoArray.count;
             break;
            
        case 2:
             return 13+_calenDarArray.count;
             break;
            
        case 3:
             return 13+_TodayArray.count;
             break;
            
        case 5:
            return 13+_orderArray.count;
            break;
            
        case 4:
            return 13+[TodayFoodViewController ShareMultArr].count;
            break;
            
        default:
            return 13;
            break;
    }

}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{



  static NSString *str = @"identifer";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    
    if (cell==nil)
    {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        
    }
    
    cell.backgroundColor = [UIColor colorWithRed:204/255.0 green:235/255.0 blue:168/255.0 alpha:1.0];
    cell.layer.borderWidth = 0.3;
    cell.layer.borderColor =[[UIColor colorWithRed:93/255.0 green:179/255.0 blue:88/255.0 alpha:1.0] CGColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
  
    for (UIView *view in cell.contentView.subviews)
    {
        
        [view removeFromSuperview];
        
    }
    
//   查看总卡路里
    if (indexPath.row==0)
    {
        if (_numberOfStyle==1)
        {
            UILabel *calorie = [[UILabel alloc]initWithFrame:CGRectMake(xWidth*0.35-20, 10, 60, 20)];
            calorie.text = @"卡路里";
            [calorie setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
            [cell.contentView addSubview:calorie];
            
            UILabel *calorieCount = [[UILabel alloc]initWithFrame:CGRectMake(0.35*xWidth+100, 10, 120, 20)];
            calorieCount.textColor = [UIColor redColor];
            calorieCount.text = [NSString stringWithFormat:@"%.1f卡",totalCalorie];
            
            
            [cell.contentView addSubview:calorieCount];

        }
        
        else if (_numberOfStyle==2)
        {
        
        
            UILabel *calorie = [[UILabel alloc]initWithFrame:CGRectMake(xWidth*0.35-20, 10, 60, 20)];
            calorie.text = @"卡路里";
            [calorie setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
            [cell.contentView addSubview:calorie];
            
            UILabel *calorieCount = [[UILabel alloc]initWithFrame:CGRectMake(0.35*xWidth+100, 10, 120, 20)];
            calorieCount.textColor = [UIColor redColor];
            calorieCount.text = [NSString stringWithFormat:@"%.1f卡",totalCalorie1];
           
            [cell.contentView addSubview:calorieCount];

        }
        
        else if (_numberOfStyle==3)
        {
            UIButton *addBtn = [[UIButton alloc]initWithFrame:CGRectMake(xWidth/3.00-20, 10, 60, 30)];
            [addBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
            [addBtn setTitle:@"添加" forState:UIControlStateNormal];
            [addBtn addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
            
            addBtn.backgroundColor = [UIColor colorWithRed:93/255.0 green:179/255.0 blue:88/255.0 alpha:1.0];
            
            [cell.contentView addSubview:addBtn];
        
            UIButton *saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.35*xWidth+80, 10, 60, 30)];
            saveBtn.backgroundColor = [UIColor colorWithRed:217/255.0 green:80/255.0 blue:78/255.0 alpha:1.0];
            [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
            
            [saveBtn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
            saveBtn.tag=11;
            [cell.contentView addSubview:saveBtn];
            
            UILabel *calorie = [[UILabel alloc]initWithFrame:CGRectMake(xWidth*0.35-20, 50, 60, 20)];
            calorie.text = @"卡路里";
            [calorie setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
            [cell.contentView addSubview:calorie];
            
            UILabel *calorieCount = [[UILabel alloc]initWithFrame:CGRectMake(0.35*xWidth+90, 50, 120, 20)];
            calorieCount.textColor = [UIColor redColor];
            calorieCount.text = [NSString stringWithFormat:@"%.1f卡",totalCalorie2];
            
            [cell.contentView addSubview:calorieCount];

        }
        
        else if (_numberOfStyle==4)
        {
        
            UIButton *saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(xWidth/2.0-30, 10, 60, 30)];
            saveBtn.backgroundColor = [UIColor colorWithRed:217/255.0 green:80/255.0 blue:78/255.0 alpha:1.0];
            [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
            [saveBtn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
            saveBtn.tag=12;
            [cell.contentView addSubview:saveBtn];
            
            UILabel *calorie = [[UILabel alloc]initWithFrame:CGRectMake(xWidth*0.35-20, 50, 60, 20)];
            calorie.text = @"卡路里";
            [calorie setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
            [cell.contentView addSubview:calorie];
            
            UILabel *calorieCount = [[UILabel alloc]initWithFrame:CGRectMake(0.35*xWidth+90, 50, 120, 20)];
            calorieCount.textColor = [UIColor redColor];
            calorieCount.text = [NSString stringWithFormat:@"%.1f卡",totalCalorie4];
            
            [cell.contentView addSubview:calorieCount];
        
        
        }
        else if (_numberOfStyle==5)
        {
        
            UILabel *calorie = [[UILabel alloc]initWithFrame:CGRectMake(xWidth*0.35-20, 10, 60, 20)];
            calorie.text = @"卡路里";
            [calorie setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
            [cell.contentView addSubview:calorie];
            
            UILabel *calorieCount = [[UILabel alloc]initWithFrame:CGRectMake(0.35*xWidth+100, 10, 120, 20)];
            calorieCount.textColor = [UIColor redColor];
            calorieCount.text = [NSString stringWithFormat:@"%.1f卡",totalCalorie3];
            
            
            [cell.contentView addSubview:calorieCount];
        
        }
        
           }
    
  
//    图表绘制
     else if (indexPath.row==1)
    {
      
        UILabel *kakaLabel = [[UILabel alloc]initWithFrame:CGRectMake(xWidth/2-25, 10, 50, 20)];
        kakaLabel.font = [UIFont systemFontOfSize:14];
        kakaLabel.text = @"KaKa分";
//        kakaLabel.backgroundColor = [UIColor redColor];
        [cell.contentView addSubview:kakaLabel];
//        [cell.contentView addSubview:_chart];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(40, 50, xWidth-60, 310)];
        view.layer.borderWidth = 1;
//        view.alpha = 0.6;
        view.layer.borderColor = [UIColor grayColor].CGColor;
        [cell.contentView addSubview:view];
        
        for (int j=0; j<11; j++)
        {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40+((xWidth-70)/10.0)*j, 30, (xWidth-60)/10.0, 20)];
            label.font = [UIFont systemFontOfSize:12];
            [label setTextAlignment:NSTextAlignmentJustified];
            
            label.text = [NSString stringWithFormat:@"%i",j*10];
            
            [cell.contentView addSubview:label];
        }
       
        
        for (int i=0; i<10; i++)
        {
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 60+30*i, 40, 20)];
//            label.backgroundColor = [UIColor redColor];
            label.font = [UIFont systemFontOfSize:12];
            [label setTextAlignment:NSTextAlignmentCenter];
            label.text = _labels[i];
            [cell.contentView addSubview:label];
           
            NSNumber *number = _properyArray[i];
            
            if ([number floatValue]>100.0)
            {
                
                number = [NSNumber numberWithFloat:100.0];
                
                
            }
            
            UILabel *countLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 60+30*i, [number floatValue]/100.0*(xWidth-60), 20)];
            countLabel.backgroundColor = [UIColor colorWithRed:63.0/255.0 green:133.0/255.0 blue:0/255.0 alpha:1.0];
            
            [cell.contentView addSubview:countLabel];
            
        }
    }
    
    
    
    else if (indexPath.row==2)
    {
    
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, xWidth-20, 20)];
        label1.text = @"自测成绩单:(100分为摄入得分标准)";
        //加粗字体
        [label1 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
        [cell.contentView addSubview:label1];
    
      
        UILabel *element = [[UILabel alloc]initWithFrame:CGRectMake(35, 25, 30, 20)];
        element.text = @"元素";
        [element setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
        [cell.contentView addSubview:element];
    
        
        UILabel *score = [[UILabel alloc]initWithFrame:CGRectMake(100, 25, 30, 20)];
        score.text = @"得分";
        [score setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
        [cell.contentView addSubview:score];
    
        
        UILabel *grade = [[UILabel alloc]initWithFrame:CGRectMake(130+xWidth*0.3, 25, 30, 20)];
        grade.text = @"成绩";
        [grade setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
        [cell.contentView addSubview:grade];
        
    }
    
    
    else if (indexPath.row >=3 && indexPath.row <13)
    {
      
        UILabel *elementLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 40, 50, 20)];
        elementLabel.font = [UIFont systemFontOfSize:15];
        elementLabel.textAlignment = NSTextAlignmentCenter;
        elementLabel.text = _nameLabels[indexPath.row-3];
        [cell.contentView addSubview:elementLabel];
       
    
        
        UILabel *scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(105, 40, 30, 20)];
        scoreLabel.font = [UIFont systemFontOfSize:15];
        NSNumber *number = _properyArray[indexPath.row-3];
        
        if ([number intValue]>100)
        {
            scoreLabel.text = [NSString stringWithFormat:@"100"];
        }
        else
        {
            scoreLabel.text = [NSString stringWithFormat:@"%i",[number intValue]];
        }
        
        [cell.contentView addSubview:scoreLabel];
        
        
        UILabel *gradeLabel = [[UILabel alloc]initWithFrame:CGRectMake(145, 0, xWidth-145, 100)];
        gradeLabel.numberOfLines = 0;
        gradeLabel.lineBreakMode = NSLineBreakByWordWrapping;
        gradeLabel.textAlignment = NSTextAlignmentJustified;
        gradeLabel.font = [UIFont systemFontOfSize:12];
//        gradeLabel.backgroundColor = [UIColor redColor];
        if ([number intValue]>=0 && [number intValue]<75)
        {
            
            gradeLabel.text = _faileArr[indexPath.row-3];
            
        }
        
        else if ([number intValue]>=75 &&[number intValue]<95)
        {
        
            gradeLabel.text = _passArr[indexPath.row-3];
        
        }
        else
        {
        
            gradeLabel.text = _goodArr[indexPath.row-3];
        
        }
        [cell.contentView addSubview:gradeLabel];
        
    }
    
    
    
    else
    {
        
        
        if (_numberOfStyle==1)
        {
            BuyInfo *info = _infoArray[indexPath.row-13];
            
            
            FoodModel *fmodel = info.fmodel;
            commodityModel *cmodel = info.cmodel;
        
        //自定义代码实现cell上的控件
        UILabel *mainDishLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, xWidth/2+20, 40)];
        mainDishLabel.tag = 1;
        mainDishLabel.numberOfLines = 0;
        mainDishLabel.lineBreakMode = NSLineBreakByWordWrapping;
        mainDishLabel.textAlignment = NSTextAlignmentJustified;
        mainDishLabel.font = [UIFont systemFontOfSize:15];
        //        mainDishLabel.textColor = [UIColor darkGrayColor];
        //        mainDishLabel.backgroundColor = [UIColor redColor];
        
        
        mainDishLabel.text = fmodel.commodityName;
        
        [cell.contentView addSubview:mainDishLabel];
        
        UILabel *heatLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(xWidth/2+30, 20, 60, 20)];
        heatLabel1.tag = 2;
        heatLabel1.font = [UIFont systemFontOfSize:15];
        heatLabel1.textColor = [UIColor redColor];
        heatLabel1.textAlignment = NSTextAlignmentCenter;
        heatLabel1.text = [NSString stringWithFormat:@"%.1f卡",[fmodel.heat floatValue]];
        
        
        [cell.contentView addSubview:heatLabel1];
        
        
        UILabel *countLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(xWidth-30, 20, 30, 20)];
        countLabel1.text = [NSString stringWithFormat:@"%i份",fmodel.number];
        countLabel1.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:countLabel1];
        
        UILabel *commodityLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, xWidth-40, 20)];
        commodityLabel.tag = 3;
        //        commodityLabel.textColor = [UIColor darkGrayColor];
        commodityLabel.font = [UIFont systemFontOfSize:14];
        commodityLabel.text = [NSString stringWithFormat:@"底料:%@",cmodel.commodityName];
        
        [cell.contentView addSubview:commodityLabel];
        
        
        
        UILabel *heatLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(xWidth/2+30, 60, 60, 20)];
        heatLabel2.tag = 4;
        heatLabel2.font = [UIFont systemFontOfSize:14];
        heatLabel2.textColor = [UIColor redColor];
        heatLabel2.textAlignment = NSTextAlignmentCenter;
        heatLabel2.text = [NSString stringWithFormat:@"%.1f卡",[cmodel.heat floatValue]];
        [cell.contentView addSubview:heatLabel2];
        
        
        UILabel *countLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(xWidth-30, 60, 30, 20)];
        countLabel2.text = [NSString stringWithFormat:@"%i份",cmodel.number];
        countLabel2.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:countLabel2];
        
        
        if (fmodel.commodityArray.count==0)
        {
            
            commodityLabel.hidden = YES;
            heatLabel2.hidden = YES;
            countLabel2.hidden = YES;
        }
    
            
    }
        
        if (_numberOfStyle==2)
        {
            CalFoodModel *cfmodel = foodArr[indexPath.row-13];
        
            
            
            UILabel *mainDishLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, xWidth/2+20, 40)];
            mainDishLabel.tag = 1;
            mainDishLabel.numberOfLines = 0;
            mainDishLabel.lineBreakMode = NSLineBreakByWordWrapping;
            mainDishLabel.textAlignment = NSTextAlignmentJustified;
            mainDishLabel.font = [UIFont systemFontOfSize:15];
            //        mainDishLabel.textColor = [UIColor darkGrayColor];
            //        mainDishLabel.backgroundColor = [UIColor redColor];
            
            
            mainDishLabel.text = cfmodel.foodName;
            
            [cell.contentView addSubview:mainDishLabel];
            
            UILabel *heatLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(xWidth/2+30, 20, 80, 20)];
            heatLabel1.tag = 2;
            heatLabel1.font = [UIFont systemFontOfSize:15];
            heatLabel1.textColor = [UIColor redColor];
            heatLabel1.textAlignment = NSTextAlignmentCenter;
            heatLabel1.text = [NSString stringWithFormat:@"%.1f卡",[cfmodel.heat floatValue]*[cfmodel.num intValue]];
            
            
            
            [cell.contentView addSubview:heatLabel1];
            
            
            UILabel *countLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(xWidth-30, 20, 30, 20)];
            countLabel1.text = [NSString stringWithFormat:@"%i份",[cfmodel.num intValue]];
            countLabel1.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:countLabel1];

        }
        
        if (_numberOfStyle==3)
        {
            CalFoodModel *cfmodel = _TodayArray[indexPath.row-13];
            
            
            
            UILabel *mainDishLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, xWidth/2+20, 40)];
            mainDishLabel.tag = 1;
            mainDishLabel.numberOfLines = 0;
            mainDishLabel.lineBreakMode = NSLineBreakByWordWrapping;
            mainDishLabel.textAlignment = NSTextAlignmentJustified;
            mainDishLabel.font = [UIFont systemFontOfSize:15];
            
            
            mainDishLabel.text = cfmodel.foodName;
            
            [cell.contentView addSubview:mainDishLabel];
            
            UILabel *heatLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(xWidth/2+30, 20, 80, 20)];
            heatLabel1.tag = 2;
            heatLabel1.font = [UIFont systemFontOfSize:15];
            heatLabel1.textColor = [UIColor redColor];
            heatLabel1.textAlignment = NSTextAlignmentCenter;
            heatLabel1.text = [NSString stringWithFormat:@"%.1f卡",[cfmodel.heat floatValue]*[cfmodel.num intValue]];
            
            
            
            [cell.contentView addSubview:heatLabel1];
            
            
            UILabel *countLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(xWidth-30, 20, 30, 20)];
            countLabel1.text = [NSString stringWithFormat:@"%i份",[cfmodel.num intValue]];
            countLabel1.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:countLabel1];
            
        }
        
        if (_numberOfStyle==4)
        {
            GridFoodModel *gmodel = [TodayFoodViewController ShareMultArr][indexPath.row-13];
            UILabel *mainDishLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, xWidth/2+20, 40)];
            mainDishLabel.tag = 1;
            mainDishLabel.numberOfLines = 0;
            mainDishLabel.lineBreakMode = NSLineBreakByWordWrapping;
            mainDishLabel.textAlignment = NSTextAlignmentJustified;
            mainDishLabel.font = [UIFont systemFontOfSize:15];
            
            
            mainDishLabel.text = gmodel.foodName;
            
            [cell.contentView addSubview:mainDishLabel];
            
            UILabel *heatLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(xWidth/2+30, 20, 80, 20)];
            heatLabel1.tag = 2;
            heatLabel1.font = [UIFont systemFontOfSize:15];
            heatLabel1.textColor = [UIColor redColor];
            heatLabel1.textAlignment = NSTextAlignmentCenter;
            heatLabel1.text = [NSString stringWithFormat:@"%.1f卡",[gmodel.heat floatValue]*gmodel.number];
            
            
            
            [cell.contentView addSubview:heatLabel1];
            
            
            UILabel *countLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(xWidth-30, 20, 30, 20)];
            countLabel1.text = [NSString stringWithFormat:@"%i份",gmodel.number];
            countLabel1.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:countLabel1];
            
            
        }
        if (_numberOfStyle==5)
        {
            
            OrderInfoModel *model = _orderArray[indexPath.row-13];
            
            UILabel *mainDishLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, xWidth/2+20, 40)];
            mainDishLabel.tag = 1;
            mainDishLabel.numberOfLines = 0;
            mainDishLabel.lineBreakMode = NSLineBreakByWordWrapping;
            mainDishLabel.textAlignment = NSTextAlignmentJustified;
            mainDishLabel.font = [UIFont systemFontOfSize:15];
            
            
            mainDishLabel.text = model.commodityName;
            
            [cell.contentView addSubview:mainDishLabel];
            
            UILabel *heatLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(xWidth/2+30, 20, 80, 20)];
            heatLabel1.tag = 2;
            heatLabel1.font = [UIFont systemFontOfSize:15];
            heatLabel1.textColor = [UIColor redColor];
            heatLabel1.textAlignment = NSTextAlignmentCenter;
            heatLabel1.text = [NSString stringWithFormat:@"%.1f卡",[model.heat floatValue]*[model.num intValue]];
            
            
            
            [cell.contentView addSubview:heatLabel1];
            
            
            UILabel *countLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(xWidth-30, 20, 30, 20)];
            countLabel1.text = [NSString stringWithFormat:@"%i份",[model.num intValue]];
            countLabel1.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:countLabel1];

            
        }

    }
    
    
    
    return cell;

}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row==0)
   {
     
       if (_numberOfStyle==1||_numberOfStyle==2||_numberOfStyle==5)
       {
           return 34;
       }
       else
           return 80;
    }
   else if (indexPath.row == 1)
   {
   
   
       return 370;
   
   }
    else if (indexPath.row == 2)
    {
    
        return 45;
    
    }
    else if (indexPath.row >=3 && indexPath.row <13)
    {
    
        return 100;
    
    }
    else
    {
        BuyInfo *info = _infoArray[indexPath.row-13];
        
        
        FoodModel *fmodel = info.fmodel;
//        commodityModel *cmodel = info.cmodel;
        if (fmodel.commodityArray.count==0)
        {
            return 44;
        }
       else
           return 80;
    
    
    }
        



}


- (void)save:(UIButton *)bt
{
    
   
    
//保存之前判断是否为空 为空alert提示
    if (bt.tag==11)
    {
//        todayArr的数据
        
        
   alert1 = [[UIAlertView alloc]initWithTitle:@"保存" message:@"您确定要保存今日卡卡分么？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert1 show];
        
   
        NSLog(@"添加之前保存");
        
        
        
    }
    else
    {
        
//        [TodayViewController SharemultArray];
        alert2 = [[UIAlertView alloc]initWithTitle:@"保存" message:@"您确定要保存今日卡卡分么？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert2 show];
        
    NSLog(@"添加之后保存");
    

    }

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
  
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    if (buttonIndex==1 && alertView==alert1)
    {
        
        if (_TodayArray.count==0)
        {
            alert.message = @"未获取到您的菜谱信息";
            
            
            [alert show];
            
        }
        else
        {
          KaKaFoodParames = @"";
            for (int i=0; i<ParamesArr.count; i++)
            {
                
                KaKaFoodParames = [KaKaFoodParames stringByAppendingFormat:@"%@|",ParamesArr[i]];
   
            }
            NSLog(@"%@",KaKaFoodParames);
            NSLog(@"%@",_memberId);
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            
            hud.labelText = @"正在保存...";
            
            [manager POST:SAVETODAYKAKA parameters:@{@"memberId":_memberId,@"kakaFoodParames":KaKaFoodParames} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                
                NSLog(@"dic is %@",dic);
                
                [hud hide:YES];
                
                if ([dic[@"success"] intValue]==1) {
//                    返回的Id作用？
                    alert.message = @"保存成功";
                    [alert show];
    
                    
                       }
                else
                {
                    alert.message = dic[@"errors"];
                    [alert show];
                   
                
                }
                }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                      
                NSLog(@"save faile");
                
            }];
            
        
        }
        
    }
    
    
    if (buttonIndex==1 && alertView==alert2)
    {
        
        if ([TodayFoodViewController ShareMultArr].count==0)
        {
            
            alert.message = @"未获取到您的菜谱信息";
            
            
            [alert show];
            
        }
        else
        {
            
            KaKaFoodParames = @"";
            for (int i=0; i<ParamesArr.count; i++)
            {
                
                KaKaFoodParames = [KaKaFoodParames stringByAppendingFormat:@"%@|",ParamesArr[i]];
                
            }
            NSLog(@"%@",KaKaFoodParames);
            NSLog(@"%@",_memberId);
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            hud.labelText = @"正在保存...";
            
            [manager POST:SAVETODAYKAKA parameters:@{@"memberId":_memberId,@"kakaFoodParames":KaKaFoodParames} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                
                NSLog(@"dic is %@",dic);
                
                
                [hud hide:YES];
                if ([dic[@"success"] intValue]==1) {
                    //                    返回的Id作用？
                    alert.message = @"保存成功";
                    [alert show];
                    
                    
                }
                else
                {
                    alert.message = dic[@"errors"];
                    [alert show];
                    
                    
                }
            }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      
                      
                      [hud hide:YES];
                      NSLog(@"AFTER save faile");
                      
                  }];

            
            
        }
        
        
    }
    



}
- (void)add:(UIButton *)bt
{

    TodayFoodViewController *today = [[TodayFoodViewController alloc]init];
    

     
    today.todayArray = _TodayArray;
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:today];
    
    [self.navigationController presentViewController:nav animated:YES completion:^{
        
    }];

    
    


}


- (void)viewWillAppear:(BOOL)animated
{

  
    
   
    
    self.tabBarController.tabBar.hidden = YES;
    
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNumberStyle:) name:@"styleNotif" object:nil];
    if (_numberOfStyle==4)
    {
         [_properyArray removeAllObjects];
        [self initShareTodayArr:[TodayFoodViewController ShareMultArr]];
        
        [_tbView reloadData];

       
    }
    
    
//    NSLog(@"NUMBER OF STYLE == %i",_numberOfStyle);

    
}

- (void)checkNumberStyle:(NSNotification *)n
{

    _numberOfStyle = [[n object] intValue];
    
    



}


- (void)initShareTodayArr:(NSMutableArray *)array
{


    
    
    float k = 0.0;
    float zn = 0.0;
    float fe = 0.0;
    float ca = 0.0;
    float mg = 0.0;
    float ve = 0.0;
    float vc = 0.0;
    float va = 0.0;
    float protein = 0.0;
    float fiber = 0.0;
    float calorie = 0.0;
    for (int i=0; i<array.count; i++)
    {
        
        GridFoodModel *gmodel = array[i];
        
        int num = gmodel.number;
        k += [gmodel.k floatValue]*num;
        zn += [gmodel.zn floatValue]*num;
        fe += [gmodel.fe floatValue]*num;
        ca += [gmodel.ca floatValue]*num;
        mg += [gmodel.mg floatValue]*num;
        ve += [gmodel.ve floatValue]*num;
        vc += [gmodel.vc floatValue]*num;
        va += [gmodel.va floatValue]*num;
        protein += [gmodel.protein floatValue]*num;
        fiber += [gmodel.fiber floatValue]*num;
        
        calorie = [gmodel.heat floatValue]*num +calorie;
        
//        NSLog(@"%@",gmodel.fulltypeName);
        if (gmodel.fulltypeName.length==0)
        {
            
            NSLog(@"卡卡餐");
             [ParamesArr addObject:[NSString stringWithFormat:@"%@-%i-0",gmodel.Id,gmodel.number]];
        }
     else
        {
  

            NSLog(@"日常餐");
    [ParamesArr addObject:[NSString stringWithFormat:@"%@-%i-1",gmodel.Id,gmodel.number]];
       }
      
       
        
    }
    totalCalorie4 = calorie;
    NSNumber *number1 = [NSNumber numberWithFloat:k];
    [_properyArray addObject:number1];
    
    NSNumber *number2 = [NSNumber numberWithFloat:zn];
    [_properyArray addObject:number2];
    
    
    NSNumber *number3 = [NSNumber numberWithFloat:fe];
    [_properyArray addObject:number3];
    
    NSNumber *number4 = [NSNumber numberWithFloat:ca];
    [_properyArray addObject:number4];
    NSNumber *number5 = [NSNumber numberWithFloat:mg];
    [_properyArray addObject:number5];
    NSNumber *number6 = [NSNumber numberWithFloat:ve];
    [_properyArray addObject:number6];
    NSNumber *number7 = [NSNumber numberWithFloat:vc];
    [_properyArray addObject:number7];
    
    NSNumber *number8 = [NSNumber numberWithFloat:va];
    [_properyArray addObject:number8];
    NSNumber *number9 = [NSNumber numberWithFloat:protein];
    [_properyArray addObject:number9];
    NSNumber *number10 = [NSNumber numberWithFloat:fiber];
    [_properyArray addObject:number10];

   

    
    
}

- (void)viewWillDisappear:(BOOL)animated
{

    
//    NSLog(@"view will disappear");
    [ParamesArr removeAllObjects];
    self.tabBarController.tabBar.hidden = NO;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    
//    NSLog(@"view did appear");
//    [super viewDidAppear:animated];
//      NSLog(@"==========%lu",(unsigned long)foodArr.count);
//    [_chart reloadData];


}


- (void)viewDidDisappear:(BOOL)animated
{

//    NSLog(@"view did disappear");
    [[TodayFoodViewController ShareMultArr]removeAllObjects];
    
    


}
- (void)free
{
    
    // removeObserver ,该方法为取消监听，释放内存
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"styleNotif" object:nil];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
