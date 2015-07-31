//
//  @Author : MakeZL
//  @Desc   : 放大缩小浏览
//
//  MLPhotoBrowser
//
//  Created by 张磊 on 15/4/27.
//  Copyright (c) 2015年 www.weibo.com/makezl. All rights reserved.
//

#import "Example4ViewController.h"
#import "MLPhotoBrowserAssets.h"
#import "MLPhotoBrowserViewController.h"
#import <UIButton+WebCache.h>

@interface Example4ViewController () <MLPhotoBrowserViewControllerDelegate,MLPhotoBrowserViewControllerDataSource>

@property (weak,nonatomic) UIScrollView *scrollView;
@property (strong,nonatomic) NSMutableArray *photos;
@end

@implementation Example4ViewController

- (NSMutableArray *)photos{
    if (!_photos) {
        
        // 注意：
        // 如果是用数据源的方式传 self.photos = @[@"http://url1",@"http://url2"] 就好了
        // 下面是直接传photo模型
        
        self.photos = [NSMutableArray arrayWithArray:@[
                                                       @"http://imgsrc.baidu.com/forum/pic/item/3f7dacaf2edda3cc7d2289ab01e93901233f92c5.jpg",
                                                       @"http://123.57.17.222:8000/school/web/upload/20150316093117407_6246_9.jpg",@"http://imgsrc.baidu.com/forum/pic/item/3f7dacaf2edda3cc7d2289ab01e93901233f92c5.jpg",
                                                       @"http://123.57.17.222:8000/school/web/upload/20150316093117407_6246_9.jpg"]];
    }
    return _photos;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 这个属性不能少
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
    [self.view addSubview:scrollView];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.scrollView = scrollView;
    
    // 创建九宫格View
    [self reloadScrollView];
}

- (void)reloadScrollView{
    // 先移除，后添加
    [[self.scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSUInteger column = 3;
    CGFloat width = self.view.frame.size.width / column;
    for (NSInteger i = 0; i < self.photos.count; i++) {
        
        NSInteger row = i / column;
        NSInteger col = i % column;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        btn.frame = CGRectMake(width * col, row * width, width, width);
        btn.tag = i;
        [btn addTarget:self action:@selector(tapBrowser:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:btn];
        
        // 如果是本地ZLPhotoAssets就从本地取，否则从网络取
        if ([[self.photos objectAtIndex:i] isKindOfClass:[MLPhotoBrowserPhoto class]]) {
            if ([[self.photos objectAtIndex:i] thumbImage] == nil) {
                [btn sd_setImageWithURL:[self.photos[i] photoURL] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"pc_circle_placeholder"]];
            }else{
                [btn setImage:[self.photos[i] thumbImage] forState:UIControlStateNormal];
            }
        }else if([[self.photos objectAtIndex:i] isKindOfClass:[NSString class]]){
            [btn sd_setImageWithURL:self.photos[i] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"pc_circle_placeholder"]];
        }
        
    }
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY([[self.scrollView.subviews lastObject] frame]));
}


- (void)tapBrowser:(UIButton *)btn{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:btn.tag inSection:0];
    // 图片游览器
    MLPhotoBrowserViewController *photoBrowser = [[MLPhotoBrowserViewController alloc] init];
    // 缩放动画
    photoBrowser.status = UIViewAnimationAnimationStatusZoom;
    // 可以删除
    photoBrowser.editing = YES;
    // 数据源/delegate
    photoBrowser.delegate = self;
    photoBrowser.dataSource = self;
    // 当前选中的值
    photoBrowser.currentIndexPath = [NSIndexPath indexPathForItem:indexPath.row inSection:0];
    // 展示控制器
    [photoBrowser showPickerVc:self];
}

 #pragma mark - <MLPhotoBrowserViewControllerDataSource>
 - (NSInteger)photoBrowser:(MLPhotoBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
 return self.photos.count;
 }
 
 #pragma mark - 每个组展示什么图片,需要包装下MLPhotoBrowserPhoto
 - (MLPhotoBrowserPhoto *) photoBrowser:(MLPhotoBrowserViewController *)browser photoAtIndexPath:(NSIndexPath *)indexPath{
     // 包装下imageObj 成 ZLPhotoPickerBrowserPhoto 传给数据源
     MLPhotoBrowserPhoto *photo = [[MLPhotoBrowserPhoto alloc] init];
     photo.photoObj = [self.photos objectAtIndex:indexPath.row];
     // 缩略图
     UIButton *btn = self.scrollView.subviews[indexPath.row];
     photo.toView = btn.imageView;
     photo.thumbImage = btn.imageView.image;
     return photo;
 }
 
#pragma mark - <MLPhotoBrowserViewControllerDelegate>
- (void)photoBrowser:(MLPhotoBrowserViewController *)photoBrowser removePhotoAtIndexPath:(NSIndexPath *)indexPath{
    [self.photos removeObjectAtIndex:indexPath.row];
    [self reloadScrollView];
}
@end
