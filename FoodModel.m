//
//  FoodModel.m
//  KaKa
//
//  Created by Plizarwireless on 14/12/10.
//  Copyright (c) 2014年 Plizarwireless. All rights reserved.
//

#import "FoodModel.h"

@implementation FoodModel

- (id)init
{

    self = [super init];
    
    if (self)
    {
        
//        _commodityArray = [NSArray array];
        
        
    }

    return self;

}


- (void)setBewrite:(NSString *)bewrite
{

    _bewrite = bewrite;
    
    

    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    /**
     * 版本判断
     */
    //获取当前屏幕尺寸
    UIScreen *currentScreen = [UIScreen mainScreen];
//    NSLog(@"bounds.width = %f",currentScreen.bounds.size.width);
    if (systemVersion < 7.0) {
        /**
         * 通过字体，在固定宽度的情况下计算字符串所占的高度
         * 传入的参数size的高度尽量写大点
         * 返回值为CGSize
         */
       _bewriteHeight  = [_bewrite sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(currentScreen.bounds.size.width, 3000)].height;
    }else {
        /**
         * 返回值为CGRect
         */
        _bewriteHeight = [_bewrite boundingRectWithSize:CGSizeMake(currentScreen.bounds.size.width, 3000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName] context:nil].size.height;
    }
    


    
  


}








@end
