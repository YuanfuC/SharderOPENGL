//
//  DisplayView.m
//  SharderOPENGL
//
//  Created by ChenYuanfu on 2018/11/18.
//  Copyright © 2018年 Zerozero. All rights reserved.
//
// Base Triangle
#import "DisplayView.h"
#import "SharderManger.h"

typedef struct {
    GLKVector3 positionCoords;
} SceneVertex;

const SceneVertex vertices[] = {
    {{-0.5f, -0.5f, 0.0f}}, // lower left corner
    {{ 0.5f, -0.5f, 0.0f}}, // lower right corner
    {{-0.5f,  0.5f, 0.0f}}, // upper left corner
};


@interface DisplayView()
@property(nonatomic, strong) EAGLContext *currentContext;

@property (nonatomic, assign) GLuint renderBufferID;
@property (nonatomic, assign) GLuint frameBufferID;
@property (nonatomic, assign) GLuint vertexBufferID;

@property (strong, nonatomic) GLKBaseEffect *baseEffect;
@property (assign, nonatomic) GLuint positionSlot;
@end
@implementation DisplayView
+(Class)layerClass {
    return [CAEAGLLayer class];
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commit];
    }
    return self;
}

- (void)commit {
    CAEAGLLayer *layer =(CAEAGLLayer *)self.layer;
    layer.opaque = YES;

    layer.drawableProperties = @{
                                 kEAGLDrawablePropertyRetainedBacking:@(YES),
                                 kEAGLDrawablePropertyColorFormat:kEAGLColorFormatRGBA8
                                 };
    layer.contentsScale = [UIScreen mainScreen].scale;
}

- (void)display {
    [[SharderManger sharedManager] useProgram];
    glDrawArrays(GL_TRIANGLES, GLKVertexAttribPosition,3);
    [self.currentContext presentRenderbuffer:GL_RENDERBUFFER];

}

-(void)praperDisplay {
    //setup context
    self.currentContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:self.currentContext];
    
    [self setupRenderBuffer];
    [self setupFramBuffer];
    [self setupSharder];
    [self setupBackgroundClearColor];
    [self clearContent];
    [self setupViewPort];
    [self setupVertexBuffer];
    [self attachVertexArray];
}

- (void)setupRenderBuffer{
    glGenRenderbuffers(1, &_renderBufferID);
    glBindRenderbuffer(GL_RENDERBUFFER, _renderBufferID);
    [self.currentContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer *)self.layer];
}

- (void)setupFramBuffer{
    glGenFramebuffers(1, &_frameBufferID);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBufferID);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _renderBufferID);
}

- (void)setupVertexBuffer{
    glGenBuffers(1, &_vertexBufferID);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBufferID);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);

}

- (void)attachVertexArray {
    glEnableVertexAttribArray(_positionSlot);
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(SceneVertex), NULL);
}

- (void)setupSharder{
    [[SharderManger sharedManager] attachVertexShader:@"vertexsharder" fragmentSharder:@"fragmentsharder"];
    GLuint programID = [SharderManger sharedManager].shaderProgramID;
    _positionSlot = glGetAttribLocation(programID, "v_Position");
    NSLog(@"");
//    self.baseEffect = [[GLKBaseEffect alloc] init];
//    self.baseEffect.useConstantColor = GL_TRUE;
//    self.baseEffect.constantColor = GLKVector4Make(1.0, 0.5, 1.0,1.0);
//    [self.baseEffect prepareToDraw];
}

- (void)clearContent{
    glClear(GL_COLOR_BUFFER_BIT);
}

- (void)setupBackgroundClearColor{
    glClearColor(0.4, 0.7, 0.9, 1.0);
}

- (void)setupViewPort {
    GLint viewHeight;
    GLint viewWidth;
    
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &viewWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &viewHeight);
    
    glViewport(0, 0, viewWidth, viewHeight);
}
@end
