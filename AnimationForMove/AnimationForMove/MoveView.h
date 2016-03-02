//
//  MoveView.h
//  AnimationForMove
//
//  Created by 余强 on 16/2/29.
//  Copyright © 2016年 bdcluster(上海大数聚科技有限公司). All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoveView : UIView


@property(nonatomic,strong)NSArray *dataArray;

- (void)pause;
- (void)resume;
- (instancetype)initWithFrame:(CGRect)frame dataArray:(NSArray *)array;

@end
