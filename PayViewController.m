//
//  PayViewController.m
//  KaKa_Pw
//
//  Created by Plizarwireless on 14/12/17.
//  Copyright (c) 2014年 Plizarwireless. All rights reserved.
//

#define COUPONURL @"http://wx.dearkaka.com/kaka/kaka-api!memberCoupon.shtml"
#define TestmemberId @"297e9e79478ba5c70149c5a16f0501e4"

#define CREATEORDERURL @"http://wx.dearkaka.com/kaka/kaka-api!createOrder.shtml"
#import "PayViewController.h"
#import "commodityModel.h"
#import "FoodModel.h"
#import "BuyInfo.h"
#import "AFNetworking.h"
#import "CouponModel.h"
#import "MBProgressHUD.h"

@interface PayViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    
    
    UITableView *tbView;
    
    float width;
    
    float height;
    
    float couponmoney;
    NSMutableArray *couponArr;
    
    
    NSString *memberReamrk;
    NSString *commodityParames;
    
    NSMutableArray *reamrkArr;
    NSMutableArray *commodityParamesArr;
    
    
    BOOL isVoiceTitle;
    
    NSArray *titleArr;
    
    UILabel *shipDateChoose;
    
    UILabel *cityChoose;
    
    UITextField *voiceField;
    
    UITextField *addressField;
    
    UITextField *contactField;
    
    UITextField *phoneField;
    
    
    UIPopoverListView *shipDatelistView;
    UIPopoverListView *citylistView;
    
    NSArray *shipDateArr;
    NSArray *cityArr;
    
}
@end

@implementation PayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    isVoiceTitle= NO;
    couponmoney = 0.00;
    couponArr = [NSMutableArray array];
    reamrkArr = [NSMutableArray array];
    commodityParamesArr = [NSMutableArray array];
    
    addressField = [[UITextField alloc]init];
    contactField = [[UITextField alloc]init];
    phoneField = [[UITextField alloc]init];
    
    cityChoose = [[UILabel alloc]init];
    shipDateChoose = [[UILabel alloc]init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *payInfoDic = [defaults objectForKey:@"payInfo"];
    
    addressField.text = payInfoDic[@"address"];
    contactField.text = payInfoDic[@"contact"];
    phoneField.text = payInfoDic[@"phone"];
    
    if (payInfoDic.count==0)
    {
        cityChoose.text = @"东城区";
        shipDateChoose.text = @"08:00-22:00";
    }
   else
   {
   
       cityChoose.text = payInfoDic[@"city"];
       shipDateChoose.text = payInfoDic[@"shipDate"];
   
   }
    
    titleArr = [NSArray arrayWithObjects:@"北京市:",@"详细地址:",@"联系人:",@"手机:", nil];
    
    shipDateArr = [NSArray arrayWithObjects:@"08:00-22:00",@"08:00-14:00",@"14:00-22:00", nil];
    
    cityArr = [NSArray arrayWithObjects:@"东城区",@"西城区",@"崇文区",@"宣武区",@"朝阳区",@"丰台区",@"石景山区",@"海淀区",@"门头沟区",@"房山区",@"通州区",@"顺义区",@"昌平区",@"大兴区",@"怀柔区",@"平谷区",@"延庆县",@"密云县", nil];
    
    
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    self.title = @"订单付款";
    self.navigationController.navigationBar.translucent = NO;
    
    
    
    for (int i = 0; i<_payArray.count; i++)
    {
        BuyInfo *buyInfo = _payArray[i];
        FoodModel *fmodel = buyInfo.fmodel;
        commodityModel *cmodel = buyInfo.cmodel;
        
        if (fmodel.commodityArray.count==0)
        {
//            NSLog(@"%@------",fmodel.commodityName);
//            NSLog(@"id is-------%@",fmodel.Id);
            
           [commodityParamesArr addObject:[NSString stringWithFormat:@"%@-%i",fmodel.Id,fmodel.number]];
        }
        else
        {
//            NSLog(@"%@------%@",fmodel.commodityName,cmodel.commodityName);
//            NSLog(@"id is-------%@ %@",fmodel.Id,cmodel.Id);
            
            [reamrkArr addObject:[NSString stringWithFormat:@"%@-%@",fmodel.commodityName,cmodel.commodityName]];
            
          [commodityParamesArr addObject:[NSString stringWithFormat:@"%@-%i|%@-%i",fmodel.Id,fmodel.number,cmodel.Id,cmodel.number]];
            
        }
  
    }

    
    
    //        self.view.backgroundColor = [UIColor colorWithRed:204/255.0 green:235/255.0 blue:168/255.0 alpha:1.0];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(CancelKeyBoard:)];
//    [tbView addGestureRecognizer:tap];
//    tbView.userInteractionEnabled = YES;

    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:tap];
    
    tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, width, height-64+49)];
    tbView.backgroundColor = [UIColor colorWithRed:204/255.0 green:235/255.0 blue:168/255.0 alpha:1.0];
    tbView.delegate = self;
    tbView.dataSource = self;
    
    

    
    UIButton *footerBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width, 40)];
    [footerBtn setTitle:@"下单" forState:UIControlStateNormal];
    [footerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    footerBtn.backgroundColor = [UIColor colorWithRed:93/255.0 green:179/255.0 blue:88/255.0 alpha:1.0];
//    加粗字体
    [footerBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];

    [footerBtn addTarget:self action:@selector(createOrder:) forControlEvents:UIControlEventTouchUpInside];
    
    tbView.tableFooterView = footerBtn;
    
    [self.view addSubview:tbView];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    
}

- (void)keyboardWillShow:(NSNotification *)note
{
    // 通知中心中返回的字典中 UIKeyboardFrameEndUserInfoKey 该KEY对应的值就是键盘的Frame
//     NSLog(@"note is %@",note);
    CGRect rect = [[note userInfo][@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    [UIView animateWithDuration:0.25 animations:^{
        // 键盘UIView的纵坐标rect.origin.y
//        inputView.frame = CGRectMake(0, rect.origin.y-44, 320, 44);
//        [tbView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
        if (height>568) {
             tbView.frame = CGRectMake(0,-100, width, height-64+49);
        }
        else if (height<568)
        {
        
            tbView.frame = CGRectMake(0, -rect.origin.y+30, width, height-64+49);
        
        }
         else
             tbView.frame = CGRectMake(0, -180, width, height-64+49);
        
        
    }];
}

- (void)keyboardWillHidden:(NSNotification *)note
{
//
    [UIView animateWithDuration:0.25 animations:^{
//        inputView.frame = CGRectMake(0, 480-44, 320, 44);
        
        tbView.frame = CGRectMake(0, 0, width, height-64+49);
    }];
}


- (void)CancelKeyBoard:(UITapGestureRecognizer *)tap
{

//    NSLog(@"cancel keyboard");
    [addressField resignFirstResponder];
    [phoneField resignFirstResponder];
    [contactField resignFirstResponder];
    [voiceField resignFirstResponder];


}
- (void)createOrder:(UIButton *)bt
{

    
    
    
    
//    NSLog(@"createOrder");
    
    memberReamrk = @"";
    commodityParames = @"";
    for (int i=0; i<reamrkArr.count; i++)
    {
        
        memberReamrk = [memberReamrk stringByAppendingFormat:@"%@,",reamrkArr[i]];

    }
    
    for (int j=0; j<commodityParamesArr.count; j++)
    {
        
        commodityParames = [commodityParames stringByAppendingFormat:@"%@|",commodityParamesArr[j]];
    }
    
//    NSLog(@"%@",reamrkArr);
    
    NSLog(@"%@",commodityParames);
    
    if ([addressField.text isEqualToString:@""]||[contactField.text isEqualToString:@""]||[phoneField.text isEqualToString:@""]||phoneField.text.length<11||phoneField.text.length>11)
    {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        if ([addressField.text isEqualToString:@""]) {
           alert.message = @"请填写您的联系地址";
        }
        
        else if ([contactField.text isEqualToString:@""])
        {
            
            alert.message = @"请填写联系人";
        }
        
        else if ([phoneField.text isEqualToString:@""])
        {
           
                alert.message = @"请填写您的联系电话";
        
        }
        
        else
        {
          alert.message = @"您的手机号格式填写错误";
        
        }
        [alert show];
        
        
    }
    
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"亲,请保证信息填写无误,以便工作人员和您及时联系后配送~" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        alert.tag=1;
        [alert show];
  }

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    
    if (alertView.tag==1)
    {
       
        if (buttonIndex==0)
        {
            
             NSLog(@"确认下单");
            [self confirmCreateOrder];
            
        }
        else
            NSLog(@"取消下单");
    }
    
     if (alertView.tag==2)
    {
    
        if (buttonIndex==0)
        {
            
            
            [self.navigationController popViewControllerAnimated:YES];
        }

        
    
    
    }
        


}

//- (void)setPayArray:(NSMutableArray *)payArray
//{
//  
//    
//
//}

- (void)confirmCreateOrder
{

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在下单...";
    AFHTTPRequestOperationManager *manager= [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    if (couponArr.count!=0)
    {
        
        CouponModel *couponmodel = couponArr[0];
        
        
        [manager POST:CREATEORDERURL parameters:@{@"memberName":contactField.text,@"memberId":_memberId,@"memberPhone":phoneField.text,@"address":addressField.text,@"invoiceTitle":voiceField.text,@"memberShipDate":shipDateChoose.text,@"couponId":couponmodel.couponId,@"memberReamrk":memberReamrk,@"commodityParames":commodityParames} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
//            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的订单已创建,我们会尽快给您送货的" delegate:self cancelButtonTitle:@"确认并继续购物" otherButtonTitles:nil, nil];
            
            alert.tag=2;
            [alert show];
            [hud hide:YES];
            //            下单成功，保存联系人信息
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSDictionary *payInfoDic = [NSDictionary dictionaryWithObjectsAndKeys:addressField.text,@"address",contactField.text,@"contact",phoneField.text,@"phone",shipDateChoose.text,@"shipDate",cityChoose.text,@"city",nil];
            [defaults setObject:payInfoDic forKey:@"payInfo"];
            
            [defaults synchronize];
            
            if (_payblock) {
                _payblock(YES);
                
            }
            //            NSLog(@"%@",addressField.text);
            //            NSLog(@"%@",cityChoose.text);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            
            
        }];
        
        
    }
    
    else
    {
        
        [manager POST:CREATEORDERURL parameters:@{@"memberName":contactField.text,@"memberId":_memberId,@"memberPhone":phoneField.text,@"address":addressField.text,@"invoiceTitle":voiceField.text,@"memberShipDate":shipDateChoose.text,@"couponId":@"",@"memberReamrk":memberReamrk,@"commodityParames":commodityParames} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            
//            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的订单已创建,我们会尽快给您送货的" delegate:self cancelButtonTitle:@"确认并继续购物" otherButtonTitles:nil, nil];
            
            alert.tag=2;
            [alert show];
            [hud hide:YES];
            
//            下单成功，保存联系人信息
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSDictionary *payInfoDic = [NSDictionary dictionaryWithObjectsAndKeys:addressField.text,@"address",contactField.text,@"contact",phoneField.text,@"phone",shipDateChoose.text,@"shipDate",cityChoose.text,@"city",nil];
            [defaults setObject:payInfoDic forKey:@"payInfo"];
            
            [defaults synchronize];
            
            if (_payblock) {
                _payblock(YES);
                
            }
//            NSLog(@"%@",addressField.text);
//            NSLog(@"%@",cityChoose.text);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            
            
            
        }];
        
        
        
    }

    




}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    return 7;
    
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    
    
    return 1;
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    static NSString *str = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    
    if (cell==nil)
        
    {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
        
        
    }
    cell.backgroundColor = [UIColor colorWithRed:204/255.0 green:235/255.0 blue:168/255.0 alpha:1.0];
    
  
        cell.layer.borderColor = [UIColor colorWithRed:32.0/255.0 green:121.0/255.0 blue:66.0/255.0 alpha:1.0].CGColor;
        
        cell.layer.borderWidth = 0.3;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    for (UIView *views in cell.contentView.subviews)
    {
        
        [views removeFromSuperview];
        
    }
    UILabel *countLabel = [[UILabel alloc]initWithFrame:CGRectMake(width/3, 12, 80, 20)];
    if (indexPath.row==0)
    {
        
        cell.textLabel.text = @"订单金额:";
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        
      
        countLabel.textColor = [UIColor redColor];
        countLabel.font = [UIFont systemFontOfSize:15];
        countLabel.text = [NSString stringWithFormat:@"￥%.2f元",_allMoney];
        
        [cell.contentView addSubview:countLabel];
    }
    
    if (indexPath.row==1)
    {
        if (couponArr.count==0)
        {
            cell.hidden=YES;
            
            
        }
        else
        cell.textLabel.text = @"优惠券:";
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        
        for (int i=0; i<couponArr.count; i++)
        {
            CouponModel *couponmodel = couponArr[i];
            
            UILabel *couponLabel = [[UILabel alloc]initWithFrame:CGRectMake(width/3, 12+i*20, 80, 20)];
            
            couponLabel.font = [UIFont systemFontOfSize:15];
            couponLabel.text = [NSString stringWithFormat:@"￥%.2f元",[couponmodel.couponMoney floatValue]];
            
            couponmoney += [couponmodel.couponMoney floatValue];
            
            [cell.contentView addSubview:couponLabel];
            
            
        }
        
       
        
    }
    
  if (indexPath.row==2)
    {
        cell.textLabel.text = @"运费:";
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        countLabel.textColor = [UIColor redColor];
        countLabel.font = [UIFont systemFontOfSize:15];
        countLabel.text = @"免费";
        
        [cell.contentView addSubview:countLabel];
    }


    if (indexPath.row==3)
    {
        cell.textLabel.text = @"实付金额:";
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        countLabel.textColor = [UIColor redColor];
        countLabel.font = [UIFont systemFontOfSize:15];
        countLabel.text = [NSString stringWithFormat:@"￥%.2f元",_allMoney-couponmoney];
        
        [cell.contentView addSubview:countLabel];

        
        
    }
    
    if (indexPath.row==4)
    {
        UIButton *NovoiceTitle = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width/2, 44)];
        NovoiceTitle.tag=10;
                NovoiceTitle.titleLabel.font = [UIFont systemFontOfSize:15];
        
        [NovoiceTitle setTitle:@"不需要发票" forState:UIControlStateNormal];
        
        [NovoiceTitle addTarget:self action:@selector(BtClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [cell.contentView addSubview:NovoiceTitle];
        
        
        UIButton *voiceTitle = [[UIButton alloc]initWithFrame:CGRectMake(width/2, 0, width/2, 44)];
        voiceTitle.tag=20;
        voiceTitle.titleLabel.font = [UIFont systemFontOfSize:15];
       
        [voiceTitle setTitle:@"需要发票" forState:UIControlStateNormal];
        
        [voiceTitle addTarget:self action:@selector(BtClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:voiceTitle];
        
        if (isVoiceTitle==YES)
        {
          
            voiceTitle.backgroundColor = [UIColor colorWithRed:93/255.0 green:179/255.0 blue:88/255.0 alpha:1.0];
            [voiceTitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            NovoiceTitle.backgroundColor = [UIColor colorWithRed:204/255.0 green:235/255.0 blue:168/255.0 alpha:1.0];
            [NovoiceTitle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

            
            
        }else
        {
        
            NovoiceTitle.backgroundColor = [UIColor colorWithRed:93/255.0 green:179/255.0 blue:88/255.0 alpha:1.0];
            [NovoiceTitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
         voiceTitle.backgroundColor = [UIColor colorWithRed:204/255.0 green:235/255.0 blue:168/255.0 alpha:1.0];
         [voiceTitle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        
        }
    }
    
    
    if (indexPath.row==5)
    {
      
        UILabel *shipDate = [[UILabel alloc]init];
        shipDate.text = @"送货时间:";
        shipDate.textAlignment = NSTextAlignmentRight;
        
        shipDateChoose.backgroundColor = [UIColor whiteColor];
        shipDateChoose.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shipDateChoose:)];
        [shipDateChoose addGestureRecognizer:tap];
//        shipDateChoose.layer.borderWidth = 1;
//        shipDateChoose.layer.cornerRadius = 5;
        shipDateChoose.clipsToBounds = YES;
        shipDateChoose.tag=30;
    
        shipDateChoose.font = [UIFont systemFontOfSize:14];
        shipDate.font = [UIFont systemFontOfSize:15];
        
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jiantou.png"]];
       
        [shipDateChoose addSubview:imageView];
        imageView.autoresizesSubviews = YES;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
          imageView.frame = CGRectMake(shipDateChoose.frame.size.width-20, 5, 20, 20);
        
        if (isVoiceTitle==NO)
        {
            shipDate.frame = CGRectMake(20, 10, 70, 30);
            [cell.contentView addSubview:shipDate];
            
            shipDateChoose.frame = CGRectMake(100, 10, width-130, 30);
            voiceField = [[UITextField alloc]init];
            
           
            [cell.contentView addSubview:shipDateChoose];
        }
    
       else
       {
       
           [shipDate removeFromSuperview];
           [shipDateChoose removeFromSuperview];
           
           voiceField = [[UITextField alloc]initWithFrame:CGRectMake(10, 5, width-20, 30)];
           voiceField.placeholder = @"发票抬头";
           voiceField.borderStyle = UITextBorderStyleRoundedRect;
//           voiceField.layer.cornerRadius = 5;
//           voiceField.layer.borderWidth = 1;
           voiceField.layer.borderColor = [UIColor blackColor].CGColor;
           voiceField.backgroundColor = [UIColor whiteColor];
           voiceField.font = [UIFont systemFontOfSize:15];
           
           [cell.contentView addSubview:voiceField];
       
           shipDate.frame = CGRectMake(20, 50, 70, 30);
           [cell.contentView addSubview:shipDate];
           
           shipDateChoose.frame = CGRectMake(100, 50, width-130, 30);
           
           
           [cell.contentView addSubview:shipDateChoose];
           
       
       }
    }
    
        if (indexPath.row==6)
        {
            
            

            
            for (int i=0; i<titleArr.count; i++)
            {
                
                UILabel *PayInfolabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10+40*i, 70, 30)];
                PayInfolabel.font = [UIFont systemFontOfSize:15];
                PayInfolabel.textAlignment = NSTextAlignmentRight;
                PayInfolabel.text = titleArr[i];
//                PayInfolabel.backgroundColor = [UIColor redColor];
                [cell.contentView addSubview:PayInfolabel];
         
            }
            
            cityChoose.frame = CGRectMake(100, 10, width-130, 30);
            cityChoose.font = [UIFont systemFontOfSize:14];
            cityChoose.backgroundColor = [UIColor whiteColor];
//            cityChoose.layer.cornerRadius = 5;
//            cityChoose.layer.borderWidth = 1;
            cityChoose.clipsToBounds = YES;
//            cityChoose.layer.borderColor = [UIColor blackColor].CGColor;
            
            UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jiantou.png"]];
            
            [cityChoose addSubview:imageView];
            imageView.autoresizesSubviews = YES;
            imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            imageView.frame = CGRectMake(cityChoose.frame.size.width-20, 5, 20, 20);
            cityChoose.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cityChoose:)];
            [cityChoose addGestureRecognizer:tap];
            
            [cell.contentView addSubview:cityChoose];
            
            

            addressField.frame=CGRectMake(100, 50, width-130, 30);
            addressField.backgroundColor = [UIColor whiteColor];
            addressField.borderStyle = UITextBorderStyleRoundedRect;
//            addressField.layer.cornerRadius = 5;
//            addressField.layer.borderColor = [UIColor blackColor].CGColor;
//            addressField.layer.borderWidth = 1;
            addressField.clearButtonMode =  UITextFieldViewModeWhileEditing;
            addressField.placeholder = @"请输入您的地址...";
            addressField.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:addressField];
            
            

            contactField.frame = CGRectMake(100, 90, width-130, 30);
            contactField.backgroundColor = [UIColor whiteColor];
//            contactField.layer.cornerRadius = 5;
            contactField.clearButtonMode =  UITextFieldViewModeWhileEditing;
            contactField.borderStyle = UITextBorderStyleRoundedRect;
            contactField.layer.borderColor = [UIColor blackColor].CGColor;
//            contactField.layer.borderWidth = 1;
            contactField.placeholder = @"请输入送货联系人...";
            contactField.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:contactField];
            
            
            

           phoneField.frame = CGRectMake(100, 130, width-130, 30);
            phoneField.backgroundColor = [UIColor whiteColor];
//            phoneField.layer.cornerRadius = 5;
            phoneField.layer.borderColor = [UIColor blackColor].CGColor;
//           phoneField.layer.borderWidth = 1;
          phoneField.clearButtonMode =  UITextFieldViewModeWhileEditing;
            phoneField.borderStyle = UITextBorderStyleRoundedRect;
            phoneField.keyboardType = UIKeyboardTypeNumberPad;
            phoneField.placeholder = @"请输入您的手机号...";
            phoneField.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:phoneField];
            
        }
    
    
    return cell;
    
}



- (void)shipDateChoose:(UITapGestureRecognizer *)tap
{


   

    CGFloat yHeight;
    CGFloat xWidth = self.view.frame.size.width-40;
    
    if (shipDateArr.count*44>272.0)
    {
        yHeight = 272.0f;
    }
   else
   {
   
       yHeight = shipDateArr.count*44+30;
   
   }
    CGFloat yOffset = (height-yHeight)/2.0f;
    
    shipDatelistView = [[UIPopoverListView alloc]initWithFrame:CGRectMake(10, yOffset, xWidth, yHeight)];
    shipDatelistView.delegate = self;
    shipDatelistView.datasource  =self;
    shipDatelistView.listView.scrollEnabled = YES;
    shipDatelistView.listView.bounces = NO;
    [shipDatelistView setTitle:@"送货时间"];
    
    
    [shipDatelistView show];
}



- (void)cityChoose:(UITapGestureRecognizer *)tap
{

       CGFloat yHeight;
    CGFloat xWidth = self.view.frame.size.width-40;
    
    if (cityArr.count*44>272.0)
    {
        yHeight = 272.0f;
    }
    else
    {
        
        yHeight = cityArr.count*44+30;
        
    }
    CGFloat yOffset = (height-yHeight)/2.0f;
    
    citylistView = [[UIPopoverListView alloc]initWithFrame:CGRectMake(10, yOffset, xWidth, yHeight)];
    citylistView.delegate = self;
    citylistView.datasource  =self;
    citylistView.listView.scrollEnabled = YES;
    citylistView.listView.bounces = NO;
    [citylistView setTitle:@"地区选择"];
    
    
    [citylistView show];



}



- (void)BtClicked:(UIButton *)bt
{

    if (bt.tag==10)
    {
        
        isVoiceTitle=NO;
        [tbView reloadData];
    }
    else
        
    {
        
        isVoiceTitle=YES;
        
        [tbView reloadData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row==1)
    {
        
        if (couponArr.count==0)
        {
            return 0.0;
        }
        else
            return couponArr.count*44;
    }
   if (indexPath.row==5)
   {
   
       if (isVoiceTitle)
       {
           
           return 90.0;
       }
       else
           return 44.0;
   
   }
   
    if (indexPath.row==6)
    {
        return 180.0;
    }
    return 44.0;

}
//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
//{
//    
//}


#pragma mark - UIPopoverListViewDataSource
- (UITableViewCell *)popoverListView:(UIPopoverListView *)popoverListView cellForIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    //    UITableViewCell *cell1 = [popoverListView ]
    //    if (!cell) {
    //        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    //    }
    
    if (popoverListView==shipDatelistView)
    {
        cell.textLabel.text = shipDateArr[indexPath.row];
    }
    else
        cell.textLabel.text = cityArr[indexPath.row];
    
//    cell.backgroundColor = [UIColor colorWithRed:204/255.0 green:235/255.0 blue:168/255.0 alpha:1.0];
    return cell;
}

- (NSInteger)popoverListView:(UIPopoverListView *)popoverListView
       numberOfRowsInSection:(NSInteger)section
{
    
    if (popoverListView==shipDatelistView)
    {
        return shipDateArr.count;
    }
    else
        return cityArr.count;
    
}

#pragma mark - UIPopoverListViewDelegate
- (void)popoverListView:(UIPopoverListView *)popoverListView
     didSelectIndexPath:(NSIndexPath *)indexPath
{
    //        NSLog(@"%s : %ld", __func__, (long)indexPath.row);
    // your code here
    
    if (popoverListView==shipDatelistView)
    {
        
        shipDateChoose.text = shipDateArr[indexPath.row];
    }
    
    else
        cityChoose.text = cityArr[indexPath.row];
    
}



- (CGFloat)popoverListView:(UIPopoverListView *)popoverListView
   heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    return 44.0f;
}

- (void)viewWillAppear:(BOOL)animated
{
    

    self.tabBarController.tabBar.hidden = YES;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:COUPONURL parameters:@{@"memberId":_memberId,@"allMoney":[NSNumber numberWithFloat:_allMoney]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        //        NSLog(@"%@",array);
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
            
            
            
            [couponArr addObject:couponmodel];
            
        }
        
        
        
        //        NSLog(@"success");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        //        NSLog(@"fail");
        
    }];
    

    
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
