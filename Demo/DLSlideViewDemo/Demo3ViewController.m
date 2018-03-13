//
//  Demo3ViewController.m
//  DLSlideViewDemo
//
//  Created by 苏东乐 on 16/6/27.
//  Copyright © 2016年 dongle. All rights reserved.
//

#import "Demo3ViewController.h"
#import "DLSlideView.h"
#import "DLTabbarView.h"
#import "DLTitleBarItemView.h"
#import "DLBottomTrackerView.h"
#import "PageNViewController.h"
#import "DLTwoLevelCache.h"

@interface Demo3ViewController ()<DLTabbarDelegate, DLSlideViewDelegate, DLSlideViewDataSource>
@property (weak, nonatomic) IBOutlet DLTabbarView *slideBarView;
@property (weak, nonatomic) IBOutlet DLSlideView *slideView;

@end

@implementation Demo3ViewController{
    DLTwoLevelCache *_cache;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _cache = [[DLTwoLevelCache alloc] initWithVCCacheSize:4 dataCacheSize:100000];
    
    self.slideView.delegate = self;
    self.slideView.dataSource = self;
    self.slideView.basedViewController = self;
    
    self.slideBarView.delegate = self;

    DLTitleBarItemConfiguration *config = [DLTitleBarItemConfiguration new];
    config.itemNormalFont = [UIFont systemFontOfSize:12];
    config.itemNormalColor = [UIColor blackColor];
    config.itemSelectedColor = [UIColor redColor];
    NSMutableArray *itemArray = [NSMutableArray array];
    for (int i=0; i<10; i++) {
        DLTitleBarItemView *itemView = [[DLTitleBarItemView alloc] initWithFrame:CGRectMake(0, 0, 50, 30) title:[NSString stringWithFormat:@"title%d", i] configuration:config];
        [itemArray addObject:itemView];
    }
    self.slideBarView.barItemViewArray = itemArray;
    
    DLBottomTrackerView *tracker = [[DLBottomTrackerView alloc] initWithFrame:CGRectMake(0, 0, 10, 2)];
    tracker.bottomPadding = 2;
    tracker.backgroundColor = [UIColor redColor];
    self.slideBarView.trackerView = tracker;
    
    [self.slideBarView rebuildTabbar];
    self.slideView.selectedIndex = 0;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark DLSlideBarDelegate
- (void)DLTabbar:(id)sender selectedAt:(NSInteger)index{
    self.slideView.selectedIndex = index;
}

#pragma mark DLSlideView
- (NSInteger)numberOfControllersInDLSlideView:(DLSlideView *)sender{
    return 10;
}

- (UIViewController *)DLSlideView:(DLSlideView *)sender controllerAt:(NSInteger)index{
    NSString *key = [NSString stringWithFormat:@"%ld", (long)index];
    PageNViewController *ret = nil;
    ret = (PageNViewController *)[_cache objectForKey:key];
                                 
    if (!ret) {
        PageNViewController *ctrl = [[PageNViewController alloc] init];
        id cacheData = [_cache dataForKey:key];
        if (cacheData) {
            [ctrl setDLCacheData:cacheData];
        }
        else{
            int32_t rgbValue = rand();
            ctrl.view.backgroundColor = [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
            ctrl.pageLabel.text = [NSString stringWithFormat:@"%ld", (long)index];
        }
        
        [_cache setObject:ctrl forKey:key];

        ret = ctrl;
    }

    return ret;
}

- (void)DLSlideView:(DLSlideView *)slide switchingFrom:(NSInteger)oldIndex to:(NSInteger)toIndex percent:(float)percent{
    [self.slideBarView switchingFromIndex:oldIndex toIndex:toIndex percent:percent];
}
- (void)DLSlideView:(DLSlideView *)slide didSwitchTo:(NSInteger)index{
    [self.slideBarView setSelectedIndex:index];
}
- (void)DLSlideView:(DLSlideView *)slide switchCanceled:(NSInteger)oldIndex{
    [self.slideBarView setSelectedIndex:oldIndex];
}

@end
