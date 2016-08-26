//
//  JLFrameLayer.h
//  JLFrameView
//
//  Created by julian.song on 08/24/2016.
//  Copyright (c) 2016 julian.song. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
@class JLFrameLayer;
@protocol JLFrameLayerDelegate<NSObject>
-(void)frameAnimaitonLayer:(JLFrameLayer *) layer didChangeToIndex:(NSInteger)index;
@end

@interface JLFrameLayer : CALayer
@property (nonatomic,strong) NSArray *imagePaths;
@property (nonatomic,assign) NSInteger imageFrame;
@property (nonatomic,assign,readonly) NSInteger imageIndex;
@property (nonatomic,weak) id<JLFrameLayerDelegate> frameDelegate;
@property (nonatomic,assign) BOOL skipSendMsgToFrameDelegate;

@end
