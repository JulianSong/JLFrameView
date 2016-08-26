//
//  JLFrameLayer.m
//  JLFrameView
//
//  Created by julian.song on 08/24/2016.
//  Copyright (c) 2016 julian.song. All rights reserved.
//

#import "JLFrameLayer.h"
@interface JLFrameLayer()
@end;
@implementation JLFrameLayer

+ (BOOL)needsDisplayForKey:(NSString *) key
{
    return [key isEqualToString:@"imageFrame"];
}

+ (id < CAAction >)defaultActionForKey:(NSString *) aKey;
{
    if ([aKey isEqualToString:@"contentsRect"])
        return (id < CAAction >)[NSNull null];
    
    return [super defaultActionForKey:aKey];
}

- (void)display
{
    NSInteger currentSampleIndex = ((JLFrameLayer*)[self presentationLayer]).imageFrame;
    
    if (self.imageFrame !=0 && currentSampleIndex ==0) {
        currentSampleIndex = self.imageFrame;
    }
    
    _imageIndex = currentSampleIndex;
    
    if (self.frameDelegate && !self.skipSendMsgToFrameDelegate) {
        [self.frameDelegate frameAnimaitonLayer:self didChangeToIndex:_imageIndex];
    }
    self.skipSendMsgToFrameDelegate = NO;
    
    if (currentSampleIndex < self.imagePaths.count) {
        
        NSString   *path = [self.imagePaths objectAtIndex:currentSampleIndex];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            CGImageRef img = [UIImage imageWithContentsOfFile:path].CGImage;
            if (img) {
                self.contents = (__bridge id)(img);
            }
        }
    }
}

@end
