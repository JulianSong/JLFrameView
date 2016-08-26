//
//  JLFrameView.m
//  JLFrameView
//
//  Created by julian.song on 08/24/2016.
//  Copyright (c) 2016 julian.song. All rights reserved.
//

#import "JLFrameView.h"
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
static NSString * const FRAME_ANIMATION_KEY = @"imageFrame";
@interface JLFrameView()<JLFrameLayerDelegate>
@property (nonatomic,assign) NSInteger currrentIndex;
@property (nonatomic,strong) NSArray *imagePaths;
@property (nonatomic,strong) CABasicAnimation *frameAnim;
@property (nonatomic,strong) UIPanGestureRecognizer *panGestureRecognizer;
@end
@implementation JLFrameView

- (id)initWithFrame:(CGRect) frame imagePaths:(NSArray *) imagePaths
{
    self = [super initWithFrame:frame];
    if (self) {
        _imagePaths               = [imagePaths copy];
        _frameLayer               = [JLFrameLayer layer];
        _frameLayer.imagePaths    = _imagePaths;
        _frameLayer.frame         = self.bounds;
        _frameLayer.frameDelegate = self;
        [self.layer addSublayer:_frameLayer];
        [self showImage:0];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _frameLayer.frame = self.bounds;
}

- (void)setPanEnabled:(BOOL) panEnabled
{
    _panEnabled = panEnabled;
    if (panEnabled) {
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:_panGestureRecognizer];
    }else{
        if (_panGestureRecognizer != nil) {
            [self removeGestureRecognizer:_panGestureRecognizer];
        }
    }
}

- (void)handlePan:(UIPanGestureRecognizer *) pan
{
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        [_frameLayer removeAnimationForKey:FRAME_ANIMATION_KEY];
    }
    
    CGPoint point = [pan translationInView:self];
    
    float rang = self.bounds.size.width / [_imagePaths count];
    
    if (rang < 10.0) {
        rang = 10.0;
    }
    
    NSInteger interval = - floorf( point.x / rang);
    
    NSInteger index = _currrentIndex ;
    
    if (self.isRepeat) {
        index = fabsf(fmodf(interval + _currrentIndex + [_imagePaths count] ,[_imagePaths count]));
    }else{
        index = interval + _currrentIndex;
        
        if (index < 0) {
            index =0;
        }
        if (index > _imagePaths.count) {
            index = _imagePaths.count -1;
        }
        
    }
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:0];
    
    if (index > self.index) {
        if ((index - self.index) < _imagePaths.count /2 ) {
            for (NSInteger i = (self.index +1); i <=index; i++) {
                [self showImage:i];
            }
        }else{
            [self showImage:index];
        }
    }
    
    if (index < self.index) {
        if ((self.index - index) < _imagePaths.count /2) {
            for (NSInteger i = (self.index -1); i >= index; i--) {
                [self showImage:i];
            }
        }else{
            [self showImage: index];
        }
    }
    
    [CATransaction commit];
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (index >=0 && index < _imagePaths.count) {
            _currrentIndex = index;
        }
        
        if (index < 0) {
            _currrentIndex =0;
        }
        if (index > _imagePaths.count) {
            _currrentIndex = _imagePaths.count -1;
        }
    }
}

- (void)changeToIndex:(NSInteger) index
{
    [_frameLayer removeAnimationForKey:FRAME_ANIMATION_KEY];
    [self showImage:index];
}

- (void)showImage:(NSInteger) index
{
    if (index >= 0 && index < _imagePaths.count) {
        _frameLayer.imageFrame = index;
        [self willChangeValueForKey:@"index"];
        _index = index;
        [self didChangeValueForKey:@"index"];
        [_frameLayer setNeedsDisplay];
        [_frameLayer displayIfNeeded];
    }
}

- (void)play
{
    [_frameLayer removeAnimationForKey:FRAME_ANIMATION_KEY];
    _frameAnim    = [CABasicAnimation animationWithKeyPath:FRAME_ANIMATION_KEY];
    _frameAnim.fromValue            = @(0);
    _frameAnim.toValue              = @(_imagePaths.count);
    _frameAnim.duration             = self.animationDuration;
    _frameAnim.repeatCount          = self.isRepeat ? HUGE_VALF : 1;
    _frameAnim.autoreverses         = self.isRewind;
    if (!self.isRewind) {
        _frameAnim.fillMode=kCAFillModeForwards;
    }
    if (!self.isRepeat) {
        _frameAnim.removedOnCompletion = YES;
        _frameAnim.fillMode=kCAFillModeForwards;
    }
    _frameAnim.delegate             = self;
    [_frameLayer addAnimation:_frameAnim forKey:FRAME_ANIMATION_KEY];
}

- (void)pause
{
    CFTimeInterval pausedTime = [_frameLayer convertTime:CACurrentMediaTime() fromLayer:nil];
    _frameLayer.speed         = 0.0;
    _frameLayer.timeOffset    = pausedTime;
}

- (void)resume
{
    CFTimeInterval pausedTime     = [_frameLayer timeOffset];
    _frameLayer.speed             = 1.0;
    _frameLayer.timeOffset        = 0.0;
    _frameLayer.beginTime         = 0.0;
    CFTimeInterval timeSincePause = [_frameLayer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    _frameLayer.beginTime = timeSincePause;
}

- (void)animationDidStart:(CAAnimation *) anim
{
    
}

- (void)animationDidStop:(CAAnimation *) anim finished:(BOOL) flag
{
    if (flag) {
        if (self.isRewind) {
            [self showImage:0];
        }else{
            [self showImage:_imagePaths.count -1];
        }
    }
}

- (void)frameAnimaitonLayer:(JLFrameLayer *) layer didChangeToIndex:(NSInteger) index
{
    [self willChangeValueForKey:@"index"];
    _index = index;
    [self didChangeValueForKey:@"index"];
}

- (void)dealloc
{
    _frameAnim.delegate = nil;
    [_frameLayer removeAllAnimations];
}

@end
