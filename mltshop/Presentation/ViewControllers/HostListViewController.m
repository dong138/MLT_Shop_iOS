//
//  HostListViewController.m
//  merchant
//
//  Created by mactive.meng on 13/6/14.
//  Copyright (c) 2014 kkche. All rights reserved.
//

#import "HostListViewController.h"
#import "AppRequestManager.h"
#import "SGActionView.h"
#import "GoodsDetailViewController.h"
#import "UIViewController+ImageBackButton.h"

@interface HostListViewController ()<UITableViewDataSource, UITableViewDelegate, PullListViewDelegate, PassValueDelegate>

@end

@implementation HostListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setUpDownButton:(NSInteger)position
{
    [self setUpImageDownButton:0];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.commonListDelegate = self;
    self.dataSourceType = ListDataSourceTwoInLine;
    
    //self.tableView.pagingEnabled = YES;

    [self initDataSource];
    
}

- (void)initDataSource
{
    [super initDataSource];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////////////////////////////////////////////////////////////
#pragma mark - Network Actions
////////////////////////////////////////////////////////////

/**
 *  初始化文章 two goods one line
 */
- (void)setupDataSource {
    self.start = 1;
    [[AppRequestManager sharedManager]searchWithKeywords:self.search.keywords
                                                  cateId:self.search.catId
                                                 brandId:self.search.brandId
                                                   intro:self.search.intro
                                                    page:self.start
                                                    size:DEFAULT_PAGE_SIZE
                                                andBlock:^(id responseObject, NSError *error) {
                                                    if (responseObject != nil) {
                                                        // 集中处理所有的数据
                                                        NSInteger step = 2;
                                                        NSMutableArray *goodsArray = [[NSMutableArray alloc]init];
                                                        double countDouble = ceil([responseObject count]/ (float)step );
                                                        NSUInteger count = [[NSNumber numberWithDouble:countDouble] integerValue];
                                                        for (int i = 0 ; i < count; i++) {
                                                            if ( i*step+1 <  [responseObject count]) {
                                                                NSDictionary *oneDict = @{@"left":[[GoodsModel alloc]initWithDict:responseObject[i*step]],
                                                                                          @"right":[[GoodsModel alloc]initWithDict:responseObject[i*step+1]]
                                                                                          };
                                                                [goodsArray addObject:oneDict];
                                                            }else{
                                                                NSDictionary *oneDict = @{@"left":[[GoodsModel alloc]initWithDict:responseObject[i*step]],
                                                                                          @"right":[[GoodsModel alloc]init]
                                                                                          };
                                                                [goodsArray addObject:oneDict];
                                                                
                                                            }
                                                        }
                                                        NSLog(@"Online setupDataSource ======== ");
                                                        [self showSetupDataSource:goodsArray andError:nil];
                                                        self.start = self.start + 1;
                                                        NSLog(@"start %ld",(long)self.start);
                                                    }
                                                    if (error != nil) {
                                                        [DataTrans showWariningTitle:T(@"获取商品列表有误") andCheatsheet:ICON_TIMES andDuration:1.5f];
                                                    }
                                                    
                                                }];
}


/**
 *  推荐新的文章
 */
- (void)recomendNewItems
{
    [self setupDataSource];
}


/**
 *  推荐旧的文章
 */
- (void)recomendOldItems
{
        
    NSLog(@"start %ld",(long)self.start);
    [[AppRequestManager sharedManager]searchWithKeywords:self.search.keywords
                                                  cateId:self.search.catId
                                                 brandId:self.search.brandId
                                                   intro:self.search.intro
                                                    page:self.start
                                                    size:DEFAULT_PAGE_SIZE
                                                andBlock:^(id responseObject, NSError *error) {
                                                    if (responseObject != nil) {
                                                        // 集中处理所有的数据
                                                        NSInteger step = 2;
                                                        NSMutableArray *goodsArray = [[NSMutableArray alloc]init];
                                                        double countDouble = ceil([responseObject count]/ (float)step );
                                                        NSUInteger count = [[NSNumber numberWithDouble:countDouble] integerValue];
                                                        for (int i = 0 ; i < count; i++) {
                                                            if ( i*step+1 <  [responseObject count]) {
                                                                NSDictionary *oneDict = @{@"left":[[GoodsModel alloc]initWithDict:responseObject[i*step]],
                                                                                          @"right":[[GoodsModel alloc]initWithDict:responseObject[i*step+1]]
                                                                                          };
                                                                [goodsArray addObject:oneDict];
                                                            }else{
                                                                NSDictionary *oneDict = @{@"left":[[GoodsModel alloc]initWithDict:responseObject[i*step]],
                                                                                          @"right":[[GoodsModel alloc]init]
                                                                                          };
                                                                [goodsArray addObject:oneDict];
                                                                
                                                            }
                                                        }
                                                        NSLog(@"Online setupDataSource ======== ");
                                                        [self showRecomendOldItems:goodsArray andError:nil];
                                                        self.start = self.start + 1;
                                                        NSLog(@"start %ld",(long)self.start);
                                                    }
                                                    if (error != nil) {
                                                        [DataTrans showWariningTitle:T(@"获取商品列表有误") andCheatsheet:ICON_TIMES andDuration:1.5f];
                                                    }
                                                    
                                                }];
    
}


- (void)passSignalValue:(NSString *)value andData:(id)data
{
    GoodsModel *theOne = data;
    
    if ([value isEqualToString:SIGNAL_TAP_VEHICLE]) {
        
        GoodsDetailViewController *vc = [[GoodsDetailViewController alloc]initWithNibName:nil bundle:nil];
        vc.passDelegate = self;
        [vc setGoodsData:theOne];
        
        
        [self.navigationController presentViewController:vc animated:YES completion:nil];
    }
}

//- (void)createRefresh {
//    
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

@end
