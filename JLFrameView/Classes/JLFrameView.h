//
//  JLFrameView.h
//  JLFrameView
//
//  Created by julian.song on 08/24/2016.
//  Copyright (c) 2016 julian.song. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLFrameLayer.h"

@interface JLFrameView : UIView
@property (nonatomic,strong,readonly) JLFrameLayer *frameLayer;
@property (nonatomic,assign,readonly) NSInteger index;
@property (nonatomic,assign,getter=isRepeat) BOOL repeat;
@property (nonatomic,assign,getter=isRewind) BOOL rewind;
@property (nonatomic,assign,getter=isPanEnabled) BOOL panEnabled;
@property (nonatomic,assign) CFTimeInterval animationDuration;

- (id)initWithFrame:(CGRect) frame imagePaths:(NSArray *) imagePaths;
- (void)play;
- (void)pause;
- (void)resume;
- (void)changeToIndex:(NSInteger) index;
@end
