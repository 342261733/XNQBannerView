//
//  XNQBannerView.h
//  XNQBannerView
//
//  Created by QFPayShadowMan on 16/2/2.
//  Copyright © 2016年 xnq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XNQBannerView : UIScrollView

@property (nonatomic,strong) NSArray *arrImages;//** UIImage Array,support: UIImage type,Image name type,Image url type
@property (nonatomic,strong) UIColor *pageIndicatorTintColor;//** control other cicle color
@property (nonatomic,strong) UIColor *currentPageIndicatorTintColor;//** control select cicle color
@property (nonatomic,copy) void(^clickIndex)(NSInteger index);//** banner click block
@property (nonatomic,assign) CGFloat scrollTimerDelay;//** scroll delay time

@end
