//
//  CalendarViewController.h
//  KaKa_Pw
//
//  Created by Plizarwireless on 15/1/6.
//  Copyright (c) 2015年 Plizarwireless. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VRGCalendarView.h"
@interface CalendarViewController : UIViewController<VRGCalendarViewDelegate>


@property(nonatomic,strong)NSArray *calHeadArr;
@end
