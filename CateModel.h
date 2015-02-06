//
//  CateModel.h
//  KaKa
//
//  Created by Plizarwireless on 14/12/9.
//  Copyright (c) 2014年 Plizarwireless. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CateModel : NSObject

@property (nonatomic,copy)NSString *Id;
@property (nonatomic,copy)NSString *isDel;
@property (nonatomic,copy)NSString *leaf;
@property (nonatomic,copy)NSString *menuName;


@property (nonatomic,copy)NSString *typeName;


@property (nonatomic,copy)NSString *type;

//纪录目录的收缩状态
@property (nonatomic,assign) BOOL isOpening;


@property (nonatomic,strong)NSMutableArray *Foodarray;


//记录三角形箭头图标指向
@property (nonatomic,strong)UIImageView *imageView;


@end
