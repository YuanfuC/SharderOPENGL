//
//  DisplayView.h
//  SharderOPENGL
//
//  Created by ChenYuanfu on 2018/11/18.
//  Copyright © 2018年 Zerozero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@interface DisplayView : UIView
- (void)display;

-(void)praperDisplay;

@property(nonatomic, strong) EAGLContext *currentContext;
@end
