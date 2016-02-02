# XNQBannerView
# 无限轮播图

##可以自配图片类型：   

1）UIImage   

2）image name   

3）image url

##可以自配轮播时间    

1） 设置 scrollTimerDelay 属性  

2） default is 2.0s  

##加载网络图片使用的是SDWebImage库，如果不需要可以替换掉


##注意：加载网络图片需要配置默认的图片，等待下载，否则报错  

static NSString *const strBannerDefaultImageName = @"default.png";


