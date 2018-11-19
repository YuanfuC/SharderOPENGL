//
//  SharderManger.h
//  SharderOPENGL
//
//  Created by ChenYuanfu on 2018/11/18.
//  Copyright © 2018年 Zerozero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

typedef NS_ENUM(NSInteger, SharderType) {
    ShaderTypeVertex = GL_VERTEX_SHADER,
    ShaderTypeFragment = GL_FRAGMENT_SHADER
};

@interface SharderManger : NSObject

@property (assign, nonatomic) GLuint shaderProgramID;


+ (instancetype)sharedManager;

- (void)attachVertexShader:(NSString *)vertexName fragmentSharder:(NSString *)fragmentName;

- (void)useProgram;
@end
