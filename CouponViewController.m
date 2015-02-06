//
//  CouponViewController.m
//  KaKa_Pw
//
//  Created by Plizarwireless on 15/1/19.
//  Copyright (c) 2015年 Plizarwireless. All rights reserved.
//

#import "CouponViewController.h"
#import "CouponModel.h"
@interface CouponViewController ()
{

    float xWidth;
    float yHeight;

}
@end

@implementation CouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    xWidth = [UIScreen mainScreen].bounds.size.width;
    yHeight = [UIScreen mainScreen].bounds.size.height;
    
    self.view.backgroundColor = [UIColor colorWithRed:204/255.0 green:235/255.0 blue:168/255.0 alpha:1.0];
    
    self.title = @"我的优惠券";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.tableFooterView = [[UIView alloc]init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return _couponArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *str = @"Cell_ID";

   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        
    }
    
    for (UIView *views in cell.contentView.subviews)
    {
        
        [views removeFromSuperview];
        
    }
    
    CouponModel *model = _couponArray[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = model.couponName;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.backgroundColor = [UIColor colorWithRed:204/255.0 green:235/255.0 blue:168/255.0 alpha:1.0];
    
    UILabel *countLabel = [[UILabel alloc]initWithFrame:CGRectMake(xWidth/2+80, 10, 40, 20)];
    countLabel.font = [UIFont systemFontOfSize:15];
    countLabel.textColor = [UIColor redColor];
    countLabel.text = [NSString stringWithFormat:@"%i元",[model.couponMoney intValue]];
    [cell.contentView addSubview:countLabel];
    
    countLabel = [[UILabel alloc]initWithFrame:CGRectMake(xWidth/2+140, 10, 30, 20)];
    countLabel.font = [UIFont systemFontOfSize:15];
    countLabel.textColor = [UIColor grayColor];
    countLabel.text = [NSString stringWithFormat:@"%i份",[model.num intValue]];
    [cell.contentView addSubview:countLabel];
    
    // Configure the cell...
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
