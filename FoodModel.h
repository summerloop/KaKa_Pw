//
//  FoodModel.h
//  KaKa
//
//  Created by Plizarwireless on 14/12/10.
//  Copyright (c) 2014年 Plizarwireless. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface FoodModel : NSObject

@property (nonatomic,copy)NSString *bewrite;   //详细描述
@property (nonatomic,copy)NSString *ca;     //钙
@property (nonatomic,copy)NSString *combination;   //套餐组成
@property (nonatomic,copy)NSString *commodityName;

@property (nonatomic,strong)NSArray *commodityArray;  //底料选择
@property (nonatomic,copy)NSString *creatData;
@property (nonatomic,copy)NSString *fe;  //铁
@property (nonatomic,copy)NSString *fiber;   //纤维素
@property (nonatomic,copy)NSString *heat;  //卡路里
@property (nonatomic,copy)NSString *Id;
//@property (nonatomic,copy)NSString *image1;
//@property (nonatomic,copy)NSString *image2;
//@property (nonatomic,copy)NSString *image3;
//@property (nonatomic,copy)NSString *integral;
@property (nonatomic,copy)NSString *isCheap;
@property (nonatomic,copy)NSString *isDel;
@property (nonatomic,copy)NSString *isPackage;
//@property (nonatomic,copy)NSString *isSell;
@property (nonatomic,copy)NSString *isShare;
//@property (nonatomic,copy)NSString *isSupporting;
@property (nonatomic,copy)NSString *k;     //钾
@property (nonatomic,copy)NSString *mg;  //镁
@property (nonatomic,copy)NSString *minPrice;

@property (nonatomic,copy)NSString *price;    //价格
@property (nonatomic,copy)NSString *protein;   //蛋白质
@property (nonatomic,copy)NSString *showImg;   //菜品图片
@property (nonatomic,copy)NSString *sort;
@property (nonatomic,copy)NSString *status;
@property (nonatomic,copy)NSString *stock;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *va;
@property (nonatomic,copy)NSString *vc;
@property (nonatomic,copy)NSString *ve;
@property (nonatomic,copy)NSString *zn;  //锌

//描述内容文本高度
@property (nonatomic,readonly,assign) CGFloat bewriteHeight;



@property (nonatomic,assign)int number;


@end
