//
//  RootViewController.m
//  KaKa_Pw
//
//  Created by Plizarwireless on 14/12/12.
//  Copyright (c) 2014年 Plizarwireless. All rights reserved.
//

#import "RootViewController.h"
#import "HomeViewController.h"
#import "NutritionViewController.h"
#import "ShopCarViewController.h"
#import "UserViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
        [[UITabBar appearance] setTintColor:[UIColor colorWithRed:93/255.0 green:179/255.0 blue:88/255.0 alpha:1.0]];
        
        //    设置导航栏背景颜色
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:93/255.0 green:179/255.0 blue:88/255.0 alpha:1.0]];
        
        //设置导航栏标题文字的颜色
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        
        //设置按钮字体颜色
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        
        //自定义返回按钮
        
            UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
            self.navigationItem.backBarButtonItem = item;

        NSMutableArray *array = [NSMutableArray array];
        
        UIViewController *controller= [[HomeViewController alloc]init];
        
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:controller];
        [array addObject:nav];
        
        controller = [[NutritionViewController alloc]init];
        nav = [[UINavigationController alloc]initWithRootViewController:controller];
        [array addObject:nav];
        
        controller = [[ShopCarViewController alloc]init];
        nav = [[UINavigationController alloc]initWithRootViewController:controller];
        [array addObject:nav];
        
        controller = [[UserViewController alloc]init];
        nav = [[UINavigationController alloc]initWithRootViewController:controller];
        [array addObject:nav];
        
        
        self.viewControllers = array;
    }
    return self;

}
- (void)viewDidLoad {
    [super viewDidLoad];

    
    
    
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
