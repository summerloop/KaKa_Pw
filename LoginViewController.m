//
//  LoginViewController.m
//  KaKa_Pw
//
//  Created by Plizarwireless on 14/12/29.
//  Copyright (c) 2014年 Plizarwireless. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "AFNetworking.h"    
#import "MBProgressHUD.h"

@interface LoginViewController ()
{

    __weak IBOutlet UIButton *LoginBtn;
  


    __weak IBOutlet UIButton *RegisterBtn;

    __weak IBOutlet UITextField *phone_number;
    
    __weak IBOutlet UITextField *pass_word;
    
    BOOL isRegister;
   
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isRegister = NO;
    
    self.title =@"登录卡卡";
//    自定义返回按钮
//        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(backHome:)];
//        self.navigationItem.backBarButtonItem = item;

    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(-60, -20, 30, 35)];
    
    [leftBtn addTarget:self action:@selector(backHome:) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    
    UIBarButtonItem *lefttem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem = lefttem;
    
//    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    
    // 去掉自带的返回title
      [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
    
    self.view.backgroundColor = [UIColor colorWithRed:204/255.0 green:235/255.0 blue:168/255.0 alpha:1.0];
    
    LoginBtn.backgroundColor = [UIColor colorWithRed:93/255.0 green:179/255.0 blue:88/255.0 alpha:1.0];
    LoginBtn.layer.cornerRadius = 5;
    LoginBtn.clipsToBounds = YES;
    
    RegisterBtn.layer.cornerRadius = 5;
    RegisterBtn.clipsToBounds = YES;
    
    RegisterBtn.backgroundColor = [UIColor colorWithRed:93/255.0 green:179/255.0 blue:88/255.0 alpha:1.0];
    
    
    UIImageView *image1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check_number"]];
    image1.frame = CGRectMake(0, 0, 30, 30);
    
    phone_number.leftView = image1;
    phone_number.leftViewMode = UITextFieldViewModeAlways;

    
    
    UIImageView *image2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pass_word"]];
    image2.frame = CGRectMake(0, 0, 30, 30);
    pass_word.leftView = image2;
    pass_word.secureTextEntry = YES;
    pass_word.leftViewMode = UITextFieldViewModeAlways;
    
    // Do any additional setup after loading the view from its nib.
    
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
//    [self.view addGestureRecognizer:tap];
//    self.view.userInteractionEnabled = YES;

}


- (void)backHome:(UIButton *)bt
{
    if (_ispopHome==YES)
    {
        
       self.tabBarController.selectedIndex = 0;
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    
    }

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
//   
//    [pass_word resignFirstResponder];
//    
//}


- (IBAction)button:(UIButton *)sender
{
    
    switch (sender.tag){
       case 10:
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"正在登陆....";
           //Login  发起登陆请求
//             http://wx.dearkaka.com/kaka/kaka-api!browserLogin.shtml
            NSLog(@"登陆");
        
            NSString *LoginStr = @"http://wx.dearkaka.com/kaka/kaka-api!browserLogin.shtml";
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//            POST请求
            [manager POST:LoginStr parameters:@{@"nickName":phone_number.text,@"pwd":pass_word.text} success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"%@",dic);
//                NSLog(@"%@",dic[@"errors"]);
//                NSLog(@"%@",dic[@"messageInfo"]);
                if ([dic[@"success"] intValue]==0)
                {
//                    登陆失败
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:dic[@"errors"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [alert show];
                    
                    
                }
                else
                {
//               登陆成功  获取返回的数据
                      hud.labelText = @"登陆成功";

                   NSString *messageInfoStr = dic[@"messageInfo"];
                    
                    NSLog(@"%@",messageInfoStr);


                    NSString *message = [messageInfoStr stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
                    
//                    NSLog(@"打印暗示都放假就是%@",message);
//                    NSLog(@"%i",[message length]);
                    
//                    NSRange range = NSMakeRange(134, 1);
//                    [message deleteCharactersInRange:range];
                    
//                    NSLog(@"%@",message);
                    
                   NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
                    
                    NSDictionary*_dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

                    NSLog(@"%@",_dic);
                   
//                   NSLog(@"%@",_dic[@"memberId"]);
                    NSString *memberId = _dic[@"memberId"];
                    NSString *memberPhone = _dic[@"memberPhone"];
                    NSString *memberAddress = _dic[@"memberAddress"];
                    NSString *memberName = _dic[@"memberName"];
                    NSString *nickName = _dic[@"nickName"];

                    
                   NSDictionary *userInfoDic = [NSDictionary dictionaryWithObjectsAndKeys:memberId,@"memberId",memberPhone,@"memberPhone",memberAddress,@"memberAddress",memberName,@"memberName",nickName,@"nickName", nil];
                    
                   
//             可变字典删除所有元素的方法       [userInfoDic removeAllObjects];
                    NSLog(@"字典中元素的个数为%lu",(unsigned long)userInfoDic.count);
                    
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    
                    [defaults setObject:userInfoDic forKey:@"Login"];
                    
                    [defaults synchronize];
                    
                    
                    
          //此类延时执行的方法必须在主线程中执行
            [self performSelector:@selector(popViewCtl) withObject:nil afterDelay:1.0];
                    
                    
//
                
                
                
                }
    
    
           } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
               NSLog(@"faile");
    
               
           }];
            
            
        }
            break;
            
       case 11:
        {
        //跳转到注册页面
            
            isRegister = YES;
            RegisterViewController *regis = [[RegisterViewController alloc]init];
            
            [self.navigationController pushViewController:regis animated:YES];
        
            regis.title = @"新用户注册";
        }
    
    }
    
}


- (void)popViewCtl
{

  [self.navigationController popViewControllerAnimated:YES];

    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{

    self.tabBarController.tabBar.hidden = YES;

   

}


- (void)viewWillDisappear:(BOOL)animated
{


    self.tabBarController.tabBar.hidden = NO;
    
    if (isRegister) {
        

        
        
    }
    else
    {
    [self.navigationController popViewControllerAnimated:YES];
        
    }
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
