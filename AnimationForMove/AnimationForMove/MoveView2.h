//
//  MoveView2.h
//  AnimationForMove
//
//  Created by 余强 on 16/3/1.
//  Copyright © 2016年 bdcluster(上海大数聚科技有限公司). All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoveView2 : UIView


- (instancetype)initWithFrame:(CGRect)frame dataArray:(NSArray *)array tapBlock:(void(^)(NSInteger))tapBlock;


- (void)startTimer;

- (void)pauseTimer;
@end
