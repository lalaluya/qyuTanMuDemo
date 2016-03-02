//
//  MoveView2.m
//  AnimationForMove
//
//  Created by 余强 on 16/3/1.
//  Copyright © 2016年 bdcluster(上海大数聚科技有限公司). All rights reserved.
//

#import "MoveView2.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SPEED 40

#define BTNWIDTH 60
#define BTNHEIGHT 30

//步长，控制时间
static NSInteger timeSteps;


//控制btn的tile序数
static NSInteger moveStep; ;

@interface MoveView2 ()

@property (strong, nonatomic) CADisplayLink *moveTimer;

@property(nonatomic,copy) void(^tapBlock)(NSInteger index);



@property(nonatomic,strong) NSArray *dataArray;

@property(nonatomic,strong) NSMutableSet *set;

@end

@implementation MoveView2

- (instancetype)initWithFrame:(CGRect)frame dataArray:(NSArray *)array tapBlock:(void(^)(NSInteger))tapBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        
    
        timeSteps = 0;
        moveStep = -1;
        
        self.dataArray = array;
        
        self.tapBlock = tapBlock;

   
        
        //在viewViewAppear只调用，防止displayLink叠加
      //  [self startTimer];
        
    }
    return self;
}






- (void)step
{
    timeSteps++;
   

    if (timeSteps % 20 == 0) {
        
        [self updateMoveViewPosition];
        
        //一秒创建一个
        if (timeSteps%60 == 0) {
             ++moveStep;
            [self creatMoveView];
        }

        
    }
}




//保证视图在3-4个，完全不会有卡顿问题
- (void)creatMoveView
{
   // NSLog(@"CREATE");
    if (moveStep == self.dataArray.count) {
        moveStep = 0;
    }
    CGFloat randY = arc4random_uniform(CGRectGetHeight(self.frame)-BTNHEIGHT);
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, randY, BTNWIDTH, BTNHEIGHT)];
     btn.backgroundColor = [UIColor colorWithRed:0.1*arc4random_uniform(10) green:0.1*arc4random_uniform(10) blue:0.1*arc4random_uniform(10) alpha:1];

    [btn setTitle:self.dataArray[moveStep] forState:UIControlStateNormal];
    
    btn.layer.cornerRadius = 15;
    [btn addTarget:self action:@selector(moveViewClickAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = moveStep;
    [self addSubview:btn];
    [self.set addObject:btn];

}



- (void)updateMoveViewPosition
{
    
    for (UIButton *btn in self.set) {
        
        CGRect rect = btn.frame;
 
        rect.origin.x -= SPEED;
        btn.frame = rect;
        
    }
    
    
    NSMutableSet *tempSet = [NSMutableSet set];
    for (UIButton *btn in self.set) {
        if (CGRectGetMinX(btn.frame) < - CGRectGetWidth(btn.frame)) {
            
            [tempSet addObject:btn];
        
        }
        
    }
    
    
    [tempSet makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (UIButton *btn in tempSet) {
        [self.set removeObject:btn];
        [tempSet removeObject:btn];
        
    }
    
     [self setNeedsDisplay];
    
}




#pragma mark -- action
- (void)moveViewClickAction:(UIButton *)btn
{
   // [self pauseTimer];
    if (self.tapBlock) {
        self.tapBlock(btn.tag);
    }
    
    
    
}



- (void)startTimer
{
    self.moveTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(step)];
    [self.moveTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}


- (void)pauseTimer
{
    [self.moveTimer invalidate];
}




#pragma mark --- lazyloading

- (NSMutableSet *)set
{
    if (_set == nil) {
        _set = [[NSMutableSet alloc]init];
    }
    return _set;
}


@end
