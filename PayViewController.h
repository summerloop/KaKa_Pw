//
//  PayViewController.h
//  KaKa_Pw
//
//  Created by Plizarwireless on 14/12/25.
//  Copyright (c) 2014年 Plizarwireless. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPopoverListView.h"


typedef void (^payBlock)(BOOL isPay);
@interface PayViewController : UIViewController<UIPopoverListViewDataSource,UIPopoverListViewDelegate>


@property (nonatomic,copy)NSString *memberId;
@property (nonatomic,assign)float allMoney;
@property (nonatomic,strong)NSMutableArray *payArray;


@property (nonatomic,copy)payBlock payblock;
//- (void)setPayArray:(NSMutableArray *)payArray andMemberId:(NSString *)memberId;

@end
