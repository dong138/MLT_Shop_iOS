//
//  GoodsDetailViewController.h
//  mltshop
//
//  Created by mactive.meng on 14/12/14.
//  Copyright (c) 2014 manluotuo. All rights reserved.
//

#import "KKViewController.h"
#import "PassValueDelegate.h"
#import "PullListViewDelegate.h"
@interface GoodsDetailViewController : KKViewController

- (void)setGoodsData:(GoodsModel *)_goods;
@property(nonatomic,assign) NSObject<PassValueDelegate> *passDelegate;
@property(nonatomic, assign)NSObject<PullListViewDelegate> *commonListDelegate;
@end
