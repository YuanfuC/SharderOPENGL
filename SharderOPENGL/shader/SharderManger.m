//
//  SharderManger.m
//  SharderOPENGL
//
//  Created by ChenYuanfu on 2018/11/18.
//  Copyright © 2018年 Zerozero. All rights reserved.
//

#import "SharderManger.h"

@interface SharderManger()
@property (assign, nonatomic) GLuint vertexShaderID;
@property (assign, nonatomic) GLuint fragmentShaderID;
@end

@implementation SharderManger

+ (instancetype)sharedManager {
    static SharderManger * instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [SharderManger new];
    });
    return instance;
}

- (void)useProgram {
    glUseProgram(self.shaderProgramID);
}

- (void)attachVertexShader:(NSString *)vertexName fragmentSharder:(NSString *)fragmentName {
    
    self.vertexShaderID = [self loadAndCreatShader:vertexName type:ShaderTypeVertex];
    self.fragmentShaderID = [self loadAndCreatShader:fragmentName type:ShaderTypeFragment];
    
    [self compileSharderWithSharderID:self.vertexShaderID];
    [self compileSharderWithSharderID:self.fragmentShaderID];
    
    self.shaderProgramID = [self createProgram];
    
    glAttachShader(self.shaderProgramID, self.vertexShaderID);
    glAttachShader(self.shaderProgramID, self.fragmentShaderID);
    
   [self linkSharderWithProgramID:self.shaderProgramID];
}

- (GLuint)loadAndCreatShader:(NSString *)fileName type:(SharderType)type {
    
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"glsl"];
    NSError *error;
    
    NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    
    if (error != nil) {
        NSLog(@"Error: Load Fail, %@", error.localizedDescription);
        return -1;
    }
    
    NSLog(@"Shader:%@", content);
    
    const GLchar * stringData = [content UTF8String];
    GLint length = (GLint)content.length;
    
    //创建shader
    GLuint shaderID = glCreateShader(type);
    glShaderSource(shaderID, 1, &stringData, &length);
    
    return shaderID;
    
}

- (BOOL)compileSharderWithSharderID:(GLuint)sharderID {
    glCompileShader(sharderID);
    
    GLint compileSuccess;
    
    glGetShaderiv(sharderID, GL_COMPILE_STATUS, &compileSuccess);
    
    if (compileSuccess ==GL_FALSE) {
        GLint infoLenght;
        glGetShaderiv(sharderID, GL_INFO_LOG_LENGTH, &infoLenght);
        if (infoLenght > 0) {
            GLchar *message = malloc(sizeof(GLchar *) * infoLenght);
            glGetShaderInfoLog(sharderID, infoLenght, NULL, message);
            NSString *nsmessage = [NSString stringWithUTF8String:message];
            NSLog(@"Compile error:%@", nsmessage);
            free(message);
        }
        return NO;
    }
    return YES;
}

- (GLuint)createProgram {
    return glCreateProgram();
}

- (BOOL)linkSharderWithProgramID:(GLuint)programID {
    glLinkProgram(programID);
    
    // 获取 Link 信息
    GLint linkSuccess;
    glGetProgramiv(programID, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE) {
        GLint infoLength;
        glGetProgramiv(programID, GL_INFO_LOG_LENGTH, &infoLength);
        if (infoLength > 0) {
            GLchar *messages = malloc(sizeof(GLchar *) * infoLength);
            glGetProgramInfoLog(programID, infoLength, NULL, messages);
            NSString *messageString = [NSString stringWithUTF8String:messages];
            NSLog(@"Error: Link Failed %@ !", messageString);
            free(messages);
        }
        return NO;
    }
    return YES;
}

@end
