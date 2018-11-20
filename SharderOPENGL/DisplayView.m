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
#import "UIImage+CGData.h"

typedef struct {
    GLKVector3 positionCoords;
} SceneVertex;

//const GLfloat vertices[] = {
//    -0.5, -0.5, // lower left corner
//    -0.5,  0.5, // lower right corner
//    0.5, -0.5 // upper left corner
//
//};

//const GLfloat vertices[] = {
//    -1, -1,
//    1, -1,
//    1, 1,
//    -1, 1
//};

//const GLfloat texVertices[] = {
//    0, 0,
//    1, 0,
//    1, 1,
//    0, 1
//};


const GLfloat vertices[] = {
    -1, 1,
    -1, -1,
    1, 1,
    1, -1
};

const GLfloat texVertices[] = {
    0, 1,
    0, 0,
    1, 1,
    1, 0
};

@interface DisplayView()

@property (nonatomic, assign) GLuint renderBufferID;
@property (nonatomic, assign) GLuint frameBufferID;
@property (nonatomic, assign) GLuint vertexBufferID;

@property (strong, nonatomic) GLKBaseEffect *baseEffect;
@property (assign, nonatomic) GLuint textureID;

@property (assign, nonatomic) GLuint textureSlot;
@property (assign, nonatomic) GLuint textureCoordsSlot;
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
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

 //   glDrawElements(GL_TRIANGLES, sizeof(indices)/sizeof(indices[0]), GL_UNSIGNED_BYTE, 0);
    [self.currentContext presentRenderbuffer:GL_RENDERBUFFER];
    GLenum erro2 = glGetError();
    if (erro2 != GL_NO_ERROR) {
        NSLog(@"display Error3:0x%x", erro2);
    }

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
    [self setupImagetexture];
    [self setupViewPort];
    [self setupVertexBuffer];
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
 //   glGenBuffers(1, &_vertexBufferID);
   // glBindBuffer(GL_ARRAY_BUFFER, _vertexBufferID);
    //glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    glVertexAttribPointer(_positionSlot, 2, GL_FLOAT, GL_FALSE, 0, vertices);
    glEnableVertexAttribArray(_positionSlot);
//    glBindBuffer(GL_ARRAY_BUFFER, 0);
    
    
    //GLuint indexBuffer;
    //glGenBuffers(1, &indexBuffer);
    //glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
    //???
//    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(texVertices), texVertices, GL_STATIC_DRAW);
    //glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
    glVertexAttribPointer(_textureCoordsSlot, 2, GL_FLOAT, GL_FALSE, 0, texVertices);
    glEnableVertexAttribArray(_textureCoordsSlot);
}


- (void)setupSharder{
    [[SharderManger sharedManager] attachVertexShader:@"vertexsharder" fragmentSharder:@"fragmentsharder"];
    [[SharderManger sharedManager] useProgram];
    GLuint programID = [SharderManger sharedManager].shaderProgramID;
    
    _positionSlot = glGetAttribLocation(programID, "v_Position");
    _textureSlot = glGetUniformLocation(programID, "Texture");
    _textureCoordsSlot = glGetAttribLocation(programID, "TextureCoords");

}

- (void)setupImagetexture{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"1436321700534" ofType:@"jpg"];
    GLuint height;
    GLuint witdh;
    NSData *imageData = [[UIImage imageWithContentsOfFile:imagePath] convertTotextureDatagetWidth:&witdh height:&height];
    GLenum erro1 = glGetError();
    if (erro1 != GL_NO_ERROR) {
        NSLog(@"Error1:0x%x", erro1);
    }
    glGenTextures(1, &_textureID);
    glBindTexture(GL_TEXTURE_2D, _textureID);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);


    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, _textureID);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, witdh, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, [imageData bytes]);
    glUniform1i(_textureSlot, 0);
    GLenum erro2 = glGetError();
    if (erro2 != GL_NO_ERROR) {
        NSLog(@"Error2:0x%x", erro2);
    }
    NSLog(@"");

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
