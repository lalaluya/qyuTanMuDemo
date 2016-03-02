//
//  MoveView.m
//  AnimationForMove
//
//  Created by 余强 on 16/2/29.
//  Copyright © 2016年 bdcluster(上海大数聚科技有限公司). All rights reserved.
//

#import "MoveView.h"
#import "AnimationLayer.h"

#define KMoveViewTag 300
#define KMoveKey @"key"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@interface MoveView ()

@property(nonatomic,copy) void(^tapBlock)(NSInteger index);

@end
@implementation MoveView


- (instancetype)initWithFrame:(CGRect)frame dataArray:(NSArray *)array
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.dataArray = array;
        
        [self setUpView];
        
    
    }
    return self;
}




#pragma mark --- UIView的block动画,不能进行暂停，继续

static NSInteger tag = KMoveViewTag;
-(void)startMove
{
    UIView* sub = [self viewWithTag:tag];
    CGRect rect = sub.frame;
    rect.origin.x = SCREEN_WIDTH;
    rect.origin.y = arc4random_uniform(80)+40;
    sub.frame = rect;
    
    [UIView animateWithDuration:6 animations:^{
        
        CGRect rect = sub.frame;
        rect.origin.x =  - MAXFLOAT;;
        sub.frame = rect;
        
    } completion:^(BOOL finished) {
        CGRect rect = sub.frame;
        rect.origin.x =  SCREEN_WIDTH;;
        sub.frame = rect;
        
    }];
    
    if (tag-300 == self.dataArray.count-1) {
        tag = KMoveViewTag-1;
    }
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        tag++;
        [self startMove];
        
    });
    
}


#pragma mark ---CoreAnimation动画,可进行暂停，继续,但无法交互

- (void)startMove2
{
    
    UIView* sub = [self viewWithTag:tag];
    [sub.layer removeAllAnimations];
    CGRect rect = sub.frame;
    rect.origin.x = SCREEN_WIDTH;
    rect.origin.y = arc4random_uniform(80)+40;
    sub.frame = rect;
    CABasicAnimation *moveLayer = [AnimationLayer positionWithDuration:6 from:CGPointMake(CGRectGetMinX(sub.frame)+30, CGRectGetMinY(sub.frame)) to:CGPointMake(-CGRectGetWidth(sub.frame), CGRectGetMinY(sub.frame)) delegate:self];
    moveLayer.delegate = self;
    [sub.layer addAnimation:(CABasicAnimation *)moveLayer forKey:KMoveKey];
    
    
    //    CABasicAnimation *rotateLayer = [AnimationLayer shakeAnimationWithDuration:0.3 angle:M_PI_4/2];
    //    rotateLayer.delegate = self;
    //  [sub.layer addAnimation:(CABasicAnimation *)rotateLayer forKey:KMoveKey];
    
    
    
    
    //    CAAnimationGroup *group = [[CAAnimationGroup alloc]init];
    //
    //    group.animations = @[moveLayer,rotateLayer];
    //    group.duration = 6;
    //
    //    [sub.layer addAnimation:group forKey:nil];
    

    
    if (tag-KMoveViewTag == self.dataArray.count-1) {
        tag = KMoveViewTag-1;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        tag++;
        [self startMove2];
        
    });
    
}


- (void)pause
{
    for ( int i = 0; i<self.dataArray.count; i++) {
        UIView *moveView = [self viewWithTag:KMoveViewTag+i];
    
        
        if (moveView.layer.speed == 1.0)
        {
              [self pauseAnimation:moveView];
        }

    }
}




- (void)resume
{
    for ( int i = 0; i<self.dataArray.count; i++) {
        UIView *moveView = [self viewWithTag:KMoveViewTag+i];
        
        
        if (moveView.layer.speed == 0.0)
        {
            [self resumeAnimation:moveView];
        }
        
    }
}



- (void)pauseAnimation:(UIView *)aniView
{
    CFTimeInterval pauseTime = [aniView.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    aniView.layer.timeOffset = pauseTime;
    
    aniView.layer.speed = 0.0f;
}

- (void)resumeAnimation:(UIView *)aniView
{
    CFTimeInterval pauseTime = aniView.layer.timeOffset;
    CFTimeInterval beginTime = CACurrentMediaTime() - pauseTime;
    
    aniView.layer.timeOffset = 0.0;
    aniView.layer.beginTime = beginTime;
    
    aniView.layer.speed = 1.0;
}





-(void)setUpView
{
    
    for (int i = 0; i<self.dataArray.count; i++) {
        UILabel* moveLabel = [[UILabel alloc]initWithFrame:CGRectMake(-MAXFLOAT, 0, 60, 30)];
        moveLabel.backgroundColor = [UIColor colorWithRed:0.1*arc4random_uniform(10) green:0.1*arc4random_uniform(10) blue:0.1*arc4random_uniform(10) alpha:1];
        moveLabel.textAlignment = NSTextAlignmentLeft;
        moveLabel.text = self.dataArray[i];
        moveLabel.clipsToBounds = YES;
        moveLabel.textAlignment = NSTextAlignmentCenter;
        moveLabel.alpha = 1.0;
        moveLabel.layer.cornerRadius = 15;
        moveLabel.tag = KMoveViewTag + i;
        
        [self addSubview:moveLabel];
    }
    
    
    [self startMove2];
}




@end
