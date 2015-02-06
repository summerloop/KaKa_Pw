//
//  CalendarViewController.m
//  KaKa_Pw
//
//  Created by Plizarwireless on 15/1/6.
//  Copyright (c) 2015年 Plizarwireless. All rights reserved.
//

#import "CalendarViewController.h"
#import "CheckNutritionViewController.h"
#import "CalHeadModel.h"
@interface CalendarViewController ()
{

    BOOL isShow;
}
@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//去掉Nav返回键自带title
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
    isShow = NO;
    
    self.title = @"往日营养自测日记";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    VRGCalendarView *calendar = [[VRGCalendarView alloc]init];
    calendar.delegate = self;
    [self.view addSubview:calendar];
    
    
    if (_calHeadArr.count==0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"还没有任何营养记录哦!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
    }
    
}


//添加有时间日期的标记
-(void)calendarView:(VRGCalendarView *)calendarView switchedToYear:(int)year Month:(int)month targetHeight:(float)targetHeight animated:(BOOL)animated
{
    //
    
  
        for (int i=0; i<_calHeadArr.count; i++) 
        {
            CalHeadModel *hmodel = _calHeadArr[i];
            
       
//            NSLog(@"%@",hmodel.createDate);
            NSArray *array = [hmodel.createDate componentsSeparatedByString:@"-"];
//            NSLog(@"%i",[array[2] intValue]);
          
            
            if (year==[array[0] intValue] && month==[array[1] intValue]) {
                NSArray *dates = [NSArray arrayWithObjects:[NSNumber numberWithInt:[array[2] intValue]],nil];
//                NSLog(@"%i",i);
                [calendarView markDates:dates];
                
            }
            
        }

    
    
        
    
    

}



-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date {
    
    //NSDate是时间类型，年月日，时分秒，毫秒
    //默认NSDate的格式为格林威治格式
    //时间类型的格式转换
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    //格式转换成北京时间格式
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    
//    NSLog(@"选择的日期为%@",dateString);

    
 
    
       for (int i=0; i<_calHeadArr.count; i++)
    {
        
        CalHeadModel *model = _calHeadArr[i];
        if ([model.createDate isEqualToString:dateString])
        {
        
            
//            NSLog(@"有营养记录");
            
                CheckNutritionViewController *check = [[CheckNutritionViewController alloc]init];
            check.numberOfStyle = 2;   //不能修改
            
//            check.style = CheckViewStyleCalendarScore;
            
//            check.totalHeat = [model.totalHeat floatValue];
            check.calenDarArray = model.kakaFoods;
//            NSLog(@"%.1f",check.totalHeat);
//                check.infoArray = nil;
                [self.navigationController pushViewController:check animated:YES];
//                NSLog(@"Selected date = %@",date);
            isShow = NO;
            break;
        }
        
        else
        {
        
            
            isShow = YES;
            
        }
        
        
    }
    
    
    if (isShow==YES)
    {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该日期没有营养记录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
    }
    

    
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
