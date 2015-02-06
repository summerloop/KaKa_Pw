//
//  RegisterViewController.m
//  KaKa_Pw
//
//  Created by Plizarwireless on 14/12/29.
//  Copyright (c) 2014年 Plizarwireless. All rights reserved.
//

#import "RegisterViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
@interface RegisterViewController ()<UIAlertViewDelegate>
{

  
   
    __weak IBOutlet UITextField *phone_number;

    __weak IBOutlet UITextField *check_number;
    __weak IBOutlet UITextField *pass_word;
    
    //注册按钮
    __weak IBOutlet UIButton *registerBtn;
    //返回按钮
    __weak IBOutlet UIButton *backBtn;
    
//    获取验证码按钮
    UIButton *getCode;
    int timeTotal;
    NSTimer *timer;
    
//    UIButton *getCodeBtn;
    
}
@end

@implementation RegisterViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    // Do any additional setup after loading the view from its nib.
  self.view.backgroundColor = [UIColor colorWithRed:204/255.0 green:235/255.0 blue:168/255.0 alpha:1.0];
    
    timeTotal = 60;
    
    registerBtn.backgroundColor = [UIColor colorWithRed:93/255.0 green:179/255.0 blue:88/255.0 alpha:1.0];
    registerBtn.layer.cornerRadius = 5;
    registerBtn.clipsToBounds = YES;
    backBtn.backgroundColor = [UIColor colorWithRed:93/255.0 green:179/255.0 blue:88/255.0 alpha:1.0];
    backBtn.layer.cornerRadius = 5;
    backBtn.clipsToBounds = YES;
    
    UIImageView *image1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"phone_number"]];
    image1.frame = CGRectMake(0, 0, 30, 30);
    getCode = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 28)];
    [getCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    getCode.backgroundColor = [UIColor colorWithRed:93/255.0 green:179/255.0 blue:88/255.0 alpha:1.0];
    getCode.layer.cornerRadius = 5;
    getCode.titleLabel.font = [UIFont systemFontOfSize:14];
    [getCode addTarget:self action:@selector(getcheckNumber:) forControlEvents:UIControlEventTouchUpInside];
    
    

    
    phone_number.leftView = image1;
    phone_number.rightView = getCode;
    phone_number.leftViewMode = UITextFieldViewModeAlways;
    phone_number.rightViewMode = UITextFieldViewModeAlways;
    phone_number.keyboardType = UIKeyboardTypeNumberPad;
    
   
    
    
    UIImageView *image2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check_number"]];
    image2.frame = CGRectMake(0, 0, 30, 30);
    check_number.leftView = image2;
    
    check_number.leftViewMode = UITextFieldViewModeAlways;

    
    
    UIImageView *image3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pass_word"]];
    image3.frame = CGRectMake(0, 0, 30, 30);
    pass_word.leftView = image3;
    pass_word.secureTextEntry = YES;
    pass_word.leftViewMode = UITextFieldViewModeAlways;
    
//    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
//    [self.view addGestureRecognizer:tap];
//    self.view.userInteractionEnabled = YES;
    
    
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

    [self.view endEditing:YES];

}

//- (void)tapClick:(UITapGestureRecognizer *)tap
//{
//
//
//    [phone_number resignFirstResponder];
//    [check_number resignFirstResponder];
//    [pass_word resignFirstResponder];
//    [self.view endEditing:YES];
//
//}
- (void)getcheckNumber:(UIButton *)bt
{
// http://wx.dearkaka.com/kaka/kaka-api!getCode.shtml
    
//    NSLog(@"获取验证码中");
    //获取验证码
    getCode.enabled = NO;
   NSString *phonestr = @"http://wx.dearkaka.com/kaka/kaka-api!getCode.shtml";
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"正在获取...";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:phonestr parameters:@{@"memberPhone":phone_number.text} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
//        NSLog(@"%@",dic);
        //手机号码错误
        if ([dic[@"success"] intValue]==0||phone_number.text.length!=11)
        {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请填写正确的手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            getCode.enabled = YES;
            [alert show];
        }
        //手机号码正确
        else
        {
            
            
            
            timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startTime) userInfo:nil repeats:YES];
            
              [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
            

        
        }
       
        [HUD hide:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [HUD hide:YES];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请填写网络不给力" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
      
        [alert show];
        
    }];
    
    


}




- (void)startTime
{

//    __block int timeout=60; //倒计时时间
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
//    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
//    dispatch_source_set_event_handler(_timer, ^{
//        if(timeout<=0){ //倒计时结束，关闭
//            dispatch_source_cancel(_timer);
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //设置界面的按钮显示 根据自己需求设置
//                [getCode setTitle:@"获取验证码" forState:UIControlStateNormal];
//                getCode.userInteractionEnabled = YES;
//            });
//        }else{
//            //            int minutes = timeout / 60;
//            int seconds = timeout % 60;
//            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //设置界面的按钮显示 根据自己需求设置
//                NSLog(@"____%@",strTime);
//                [getCode setTitle:[NSString stringWithFormat:@"%@秒后发送",strTime] forState:UIControlStateNormal];
//                getCode.userInteractionEnabled = NO;
//                
//            });
//            timeout--;
//            
//        }
//    });
//    dispatch_resume(_timer);
    
    
    
    timeTotal = timeTotal - 1;
    NSString *str = [NSString stringWithFormat:@"%i秒后重发",timeTotal];
    
    
    [getCode setTitle:str forState:UIControlStateDisabled];
    
//    NSLog(@"timerDecrease");
    if (timeTotal==0)
    {
        getCode.enabled = YES;
        
        [timer invalidate];

        
       
        
        timeTotal = 60;
         [getCode setTitle:[NSString stringWithFormat:@"获取验证码"] forState:UIControlStateNormal];
    }
  
    
    

}

- (IBAction)BtnClick:(UIButton *)sender {
    switch (sender.tag) {
        case 10:
        {
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"正在注册....";
          //发送注册HTTP请求
            NSLog(@"注册");
//        http://wx.dearkaka.com/kaka/kaka-api!browserRegister.shtml
            NSString *regisStr = @"http://wx.dearkaka.com/kaka/kaka-api!browserRegister.shtml";
            
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            [manager POST:regisStr parameters:@{@"nickName":phone_number.text,@"memberPhone":phone_number.text,@"pwd":pass_word.text,@"phoneCode":check_number.text} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                
//                NSLog(@"%@",dic[@"errors"]);
//                NSLog(@"%@",dic[@"messageInfo"]);
                
                //注册成功  拿到用户信息
                if ([dic[@"success"] intValue] == 1)
                {
                    
                    
//                    NSLog(@"%@",dic);
                    
                    
                    NSString *messageInfoStr = dic[@"messageInfo"];
            
                    
                    NSString *message = [messageInfoStr stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
                    
                    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
                    
                    NSDictionary*_dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    
//                    NSLog(@"%@",_dic);
                    
                    //                   NSLog(@"%@",_dic[@"memberId"]);
                    NSString *memberId = _dic[@"memberId"];
                    NSString *memberPhone = _dic[@"memberPhone"];
                    NSString *memberAddress = _dic[@"memberAddress"];
                    NSString *memberName = _dic[@"memberName"];
                    NSString *nickName = _dic[@"nickName"];
                    
                    
                    NSDictionary *userInfoDic = [NSDictionary dictionaryWithObjectsAndKeys:memberId,@"memberId",memberPhone,@"memberPhone",memberAddress,@"memberAddress",memberName,@"memberName",nickName,@"nickName", nil];
                    
                    
                    //可变字典删除所有元素的方法       [userInfoDic removeAllObjects];
//                    NSLog(@"字典中元素的个数为%lu",(unsigned long)userInfoDic.count);
                    
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    
                    [defaults setObject:userInfoDic forKey:@"Login"];
                    
                    [defaults synchronize];
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"message:_dic[@"message"]  delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
    
                    
                    
                }
                //注册失败
                else
                {
                    
//                    NSLog(@"failed%@",dic);
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"message:dic[@"errors"]  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                  
                    [alert show];
                    
                
                
                }
                
                [hud hide:YES];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [hud hide:YES];
                
                NSLog(@"FAILE");
            }];
            
            
            
        }
            break;
            
        default:
            
            [self.navigationController popViewControllerAnimated:YES];
            break;
    }
    
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    
    if (buttonIndex==0)
    {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
//         self.tabBarController.tabBar.hidden = NO;
    }
    
    
    
}
- (void)viewWillAppear:(BOOL)animated
{

    [timer invalidate];
    timer = nil;
    
    self.tabBarController.tabBar.hidden = YES;

}


- (void)viewWillDisappear:(BOOL)animated
{

    [timer invalidate];
    timer = nil;
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
