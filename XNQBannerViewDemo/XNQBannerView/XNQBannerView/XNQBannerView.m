//
//  XNQBannerView.m
//  XNQBannerView
//
//  Created by QFPayShadowMan on 16/2/2.
//  Copyright © 2016年 xnq. All rights reserved.
//

#import "XNQBannerView.h"
#import "SDWebImageManager.h"

#define kBannerWidth self.bounds.size.width
#define kBannerHeight self.bounds.size.height

static NSString *const strBannerDefaultImageName = @"default";

@interface XNQBannerView () <
UIGestureRecognizerDelegate,
UIScrollViewDelegate > {
    UIImageView     * _leftImageView;
    UIImageView     * _centerImageView;
    UIImageView     * _rightImageView;
    UIPageControl   * _pageControl;
    NSTimer         * _timer;
    NSInteger         _imageIndex;
    NSInteger         _initFlag;
    CGFloat           _autoScrollDelay;
    NSMutableArray  * _arrImage;
}

@end


@implementation XNQBannerView

#pragma mark - ViewLifeCycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
        [self addTapGesture];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_initFlag == 0) {
        [self.superview addSubview:_pageControl];
        [self setupTimer];
        _initFlag = 1;
    }
}

#pragma mark - Private Method

- (void)setupViews {
    _initFlag = 0;
    _autoScrollDelay = 5.0;
    self.delegate = self;
    self.bounces = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.pagingEnabled = YES;
    self.contentSize = CGSizeMake(kBannerWidth * 3, kBannerHeight);
    self.contentOffset = CGPointMake(kBannerWidth, 0);//** 默认在中间位置
    _imageIndex = 0;
    _leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kBannerWidth, kBannerHeight)];
    _centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kBannerWidth, 0, kBannerWidth, kBannerHeight)];
    _rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kBannerWidth*2, 0, kBannerWidth, kBannerHeight)];
    [self addSubview:_centerImageView];
    [self addSubview:_leftImageView];
    [self addSubview:_rightImageView];
}

- (void)setupPageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.currentPage = 0;
        _pageControl.frame = CGRectMake(kBannerWidth, 0, 20*_pageControl.numberOfPages, 20);
        _pageControl.center = CGPointMake(kBannerWidth/2, kBannerHeight - 10 + self.frame.origin.y);
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.currentPageIndicatorTintColor =  [UIColor whiteColor];
        _pageControl.enabled = NO;
        _pageControl.hidesForSinglePage = YES;
    }
    _pageControl.numberOfPages = _arrImage.count;
    //[_pageControl addTarget:self action:@selector(pageControlValueChange) forControlEvents:UIControlEventValueChanged];
}

/*
 // ** 对pageControl的点击处理 需要的可以打开
 - (void)pageControlValueChange {
 if (_pageControl.currentPage == 0) {
 _leftImageView.image = _arrImage[_arrImage.count - 1];
 _centerImageView.image = _arrImage[0];
 _rightImageView.image = _arrImage[1];
 }
 else if (_pageControl.currentPage == _arrImage.count - 1) {
 _leftImageView.image = _arrImage[_pageControl.currentPage-1];
 _centerImageView.image = _arrImage[_pageControl.currentPage];
 _rightImageView.image = _arrImage[0];
 }
 else {
 _leftImageView.image = _arrImage[_pageControl.currentPage-1];
 _centerImageView.image = _arrImage[_pageControl.currentPage];
 _rightImageView.image = _arrImage[_pageControl.currentPage+1];
 }
 }
 */

- (void)setupTimer {
    if (_arrImage.count <= 1) {
        return;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:_autoScrollDelay
                                              target:self
                                            selector:@selector(scrollTimer)
                                            userInfo:nil
                                             repeats:YES];
}

- (void)scrollTimer {
    [self setContentOffset:CGPointMake(self.contentOffset.x + kBannerWidth, 0) animated:YES];
    [self performSelector:@selector(scrollViewDidEndDecelerating:) withObject:nil afterDelay:0.4f];
}

#pragma mark -- set method

- (void)setArrImages:(NSArray *)arrImages {
    _arrImage = [self getImageFromArray:arrImages];
    [self setupPageControl];
    if (_arrImage.count >=3) {
        _leftImageView.image = _arrImage[_arrImage.count - 1];
        _centerImageView.image = _arrImage[0];
        _rightImageView.image = _arrImage[1];
    } else if (_arrImage.count == 2) {
        _leftImageView.image = _arrImage[1];
        _centerImageView.image = _arrImage[0];
        _rightImageView.image = _arrImage[1];
    } else {
        _leftImageView.image = _arrImage[0];
        _centerImageView.image = _arrImage[0];
        _rightImageView.image = _arrImage[0];
        [self setScrollEnabled:NO];
    }
}

- (NSMutableArray *)getImageFromArray:(NSArray *)arrImage {
    NSMutableArray *marrImage = [[NSMutableArray alloc] initWithCapacity:arrImage.count];
    for (int i=0; i<arrImage.count; i++) {
        [marrImage addObject:[UIImage imageNamed:strBannerDefaultImageName]];
    }
    if (arrImage) {
        for (int i=0; i<arrImage.count; i++) {
            id imageObj = [arrImage objectAtIndex:i];
            if ([imageObj isKindOfClass:[UIImage class]]) {
                [marrImage replaceObjectAtIndex:i withObject:imageObj];
            }
            else if ([imageObj isKindOfClass:[NSString class]]) {
                if ([imageObj hasPrefix:@"http://"] || [imageObj hasPrefix:@"https://"]) {
                    [[SDWebImageManager sharedManager] downloadImageWithURL:imageObj
                                                                    options:0
                                                                   progress:^(NSInteger receivedSize,
                                                                              NSInteger expectedSize) {
                                                                       
                                                                   } completed:^(UIImage *image,
                                                                                 NSError *error,
                                                                                 SDImageCacheType cacheType,
                                                                                 BOOL finished,
                                                                                 NSURL *imageURL) {
                                                                       //** 下载完成 更新图片
                                                                       if (image) {
                                                                           if (_arrImage == nil) {//**注意更新的时候网络请求如果很快，先执行这个。
                                                                               [marrImage replaceObjectAtIndex:i withObject:image];
                                                                           }
                                                                           else {
                                                                               [_arrImage replaceObjectAtIndex:i withObject:image];
                                                                           }
                                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                                               if (_imageIndex == i) {
                                                                                   _centerImageView.image = image;
                                                                               }
                                                                               else if (_imageIndex == i-1) {
                                                                                   _rightImageView.image = image;
                                                                               }
                                                                               else if (_imageIndex == i+1) {
                                                                                   _leftImageView.image = image;
                                                                               }
                                                                           });
                                                                       }
                                                                   }];
                }
                else {
                    [marrImage replaceObjectAtIndex:i withObject:[UIImage imageNamed:imageObj]];
                }
            }
        }
        return marrImage;
    }
    return nil;
}

- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {
    _pageControl.pageIndicatorTintColor = pageIndicatorTintColor;
}

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor {
    _pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
}

- (void)setScrollTimerDelay:(CGFloat)scrollTimerDelay {
    _autoScrollDelay = scrollTimerDelay;
}

#pragma mark - Gesture

- (void)addTapGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(touchCenterImageView:)];
    tap.delegate = self;
    [_centerImageView addGestureRecognizer:tap];
    _centerImageView.userInteractionEnabled = YES;
}

- (void)touchCenterImageView:(UITapGestureRecognizer *)tap {
    if (self.clickIndex) {
        self.clickIndex(tap.view.tag);
    }
}

#pragma mark - ScrollView Delegate
// ** 处理滚动效果
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (!_timer) {// ** 拖动处理
        if (scrollView.contentOffset.x == kBannerWidth) {//** 滚动回第二个图不做处理
            return;
        }
        if (scrollView.contentOffset.x == 0) {//** 滚动到第一个
            _imageIndex = _imageIndex == 0 ? _arrImage.count - 1 : _imageIndex - 1;
        }
        else if (scrollView.contentOffset.x == kBannerWidth * 2) {//** 滚动到第三个
            _imageIndex = _imageIndex == _arrImage.count - 1 ? 0 : _imageIndex + 1;
        }
        
        [self setupTimer];
    }
    else {// ** 自己滚动处理
        _imageIndex = _imageIndex = _imageIndex == _arrImage.count - 1 ? 0 : _imageIndex + 1;
    }
    
    if (_imageIndex == 0) {
        _leftImageView.image = _arrImage[_arrImage.count - 1];
        _centerImageView.image = _arrImage[0];
        _rightImageView.image = _arrImage[1];
    }
    else if (_imageIndex == _arrImage.count - 1) {
        _leftImageView.image = _arrImage[_imageIndex-1];
        _centerImageView.image = _arrImage[_imageIndex];
        _rightImageView.image = _arrImage[0];
    }
    else {
        _leftImageView.image = _arrImage[_imageIndex-1];
        _centerImageView.image = _arrImage[_imageIndex];
        _rightImageView.image = _arrImage[_imageIndex+1];
    }
    self.contentOffset = CGPointMake(kBannerWidth, 0);
    _centerImageView.tag = _imageIndex;
    _pageControl.currentPage = _imageIndex;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

@end
