//
//  JLViewController.m
//  JLFrameView
//
//  Created by julian.song on 08/24/2016.
//  Copyright (c) 2016 julian.song. All rights reserved.
//

#import "JLViewController.h"
#import <JLFrameView/JLFrameView.h>
@interface JLViewController ()
@property (nonatomic,strong) JLFrameView *framView;
@property (nonatomic,strong) UISlider *slider;
@property (nonatomic,strong) UIButton *animationBtn;
@property (nonatomic,strong) UIButton *panBtn;
@end

@implementation JLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *imagesPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"images"];
    NSArray *images =  [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:imagesPath error:nil];
    NSMutableArray *imp = [[NSMutableArray alloc] init];
    
    [images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [imp addObject:[imagesPath stringByAppendingPathComponent:obj]];
    }];
    
    _framView = [[JLFrameView alloc] initWithFrame:CGRectMake(0,0,286,222)
                                        imagePaths:imp];
    
    [self.view addSubview:_framView];
    
    _slider = [[UISlider alloc] init];
    [_slider setMinimumValue:0];
    [_slider setMaximumValue:images.count];
    [_slider addTarget:self action:@selector(sliderChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_slider];
    
    _animationBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_animationBtn setTitle:@"animation" forState:UIControlStateNormal];
    [_animationBtn addTarget:self action:@selector(animated) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_animationBtn];
    
    _panBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_panBtn setTitle:@"pan" forState:UIControlStateNormal];
    [_panBtn addTarget:self action:@selector(panEnabled) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_panBtn];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _framView.center = CGPointMake(self.view.center.x,_framView.center.y+20);
    _slider.frame = CGRectMake(10,self.view.bounds.size.height - 80,self.view.bounds.size.width-20,30);
    _animationBtn.frame = CGRectMake(0,self.view.bounds.size.height - 40,self.view.bounds.size.width / 2, 30);
    _panBtn.frame = CGRectMake(self.view.bounds.size.width / 2,self.view.bounds.size.height - 40,self.view.bounds.size.width / 2, 30);
}

- (void)sliderChange:(UISlider *) slider
{
    [_framView changeToIndex:slider.value];
}

- (void)animated
{
    _framView.animationDuration = 0.4;
    _framView.repeat = YES;
    [_framView play];
}
- (void)panEnabled
{
    [_framView setPanEnabled:!_framView.isPanEnabled];
}
@end
