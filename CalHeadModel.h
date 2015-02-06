//
//  CalHeadModel.h
//  KaKa_Pw
//
//  Created by Plizarwireless on 15/1/7.
//  Copyright (c) 2015年 Plizarwireless. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalHeadModel : NSObject

@property (nonatomic,copy)NSString *createDate;

@property (nonatomic,copy)NSString *totalHeat;

@property (nonatomic,copy)NSString *Id;

@property (nonatomic,strong)NSMutableArray *kakaFoods;
@end
