//
//  GLProgram.m
//  TriangleExample
//
//  Created by Sim Jin on 16/5/7.
//  Copyright © 2016年 UFun. All rights reserved.


#import "GLProgram.h"

@interface GLProgram () {
  GLuint _vertexShader;
  GLuint _fragmentShader;
  NSMutableArray *_attributes;
}

@property (nonatomic, assign) GLuint program;

@end

@implementation GLProgram

- (instancetype)initWithVertexShaderString:(NSString *)vShaderString fragmentShaderString:(NSString *)fShaderString {
  self = [super init];
  if (self) {
    _attributes = [[NSMutableArray alloc] init];
    self.program = glCreateProgram();
    if (![self compileShader:&_vertexShader type:GL_VERTEX_SHADER string:vShaderString]) {
      NSLog(@"Failed to compile vertex shader");
    }
    
    if (![self compileShader:&_fragmentShader type:GL_FRAGMENT_SHADER string:fShaderString]) {
      NSLog(@"Failed to compile fragment shader");
    }
    
    glAttachShader(self.program, _vertexShader);
    glAttachShader(self.program, _fragmentShader);
  }
  return self;
}

- (instancetype)initWithVertexShaderFileName:(NSString *)vShaderFileName fragmentShaderFileName:(NSString *)fShaderFileName {
  NSString *fragmentShaderPathName = [[NSBundle mainBundle] pathForResource:fShaderFileName ofType:@"fsh"];
  NSString *fragmentShaderString = [NSString stringWithContentsOfFile:fragmentShaderPathName encoding:NSUTF8StringEncoding error:nil];
  
  NSString *vertexShaderPathName = [[NSBundle mainBundle] pathForResource:vShaderFileName ofType:@"vsh"];
  NSString *vertexShaderString = [NSString stringWithContentsOfFile:vertexShaderPathName encoding:NSUTF8StringEncoding error:nil];
  
  self = [self initWithVertexShaderString:vertexShaderString fragmentShaderString:fragmentShaderString];
  
  return self;
}

- (instancetype)initWithVertexShaderString:(NSString *)vShaderString fragmentShaderFileName:(NSString *)fShaderFileName {
  NSString *fragmentShaderPathName = [[NSBundle mainBundle] pathForResource:fShaderFileName ofType:@"fsh"];
  NSString *fragmentShaderString = [NSString stringWithContentsOfFile:fragmentShaderPathName encoding:NSUTF8StringEncoding error:nil];
  
  self = [self initWithVertexShaderString:vShaderString fragmentShaderString:fragmentShaderString];
  

  
  return self;
}
- (instancetype)initWithVertexShaderFileName:(NSString *)vShaderFileName fragmentShaderString:(NSString *)fShaderString {
  NSString *vertexShaderPathName = [[NSBundle mainBundle] pathForResource:vShaderFileName ofType:@"vsh"];
  NSString *vertexShaderString = [NSString stringWithContentsOfFile:vertexShaderPathName encoding:NSUTF8StringEncoding error:nil];
  
  self = [self initWithVertexShaderString:vertexShaderString fragmentShaderString:fShaderString];
  
  return self;
}

#pragma mark - Private
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type string:(NSString *)shaderString {
  GLint status;
  const GLchar *source;

  source = (GLchar *)[shaderString UTF8String];
  if (!source) {
    NSLog(@"Failed to load shader");
    return NO;
  }
  
  // 创建shader对象
  *shader = glCreateShader(type);
  if (shader == 0) return NO;
  // 加载shader source
  glShaderSource(*shader, 1, &source, NULL);
  // 编译
  glCompileShader(*shader);
  // 检查编译结果
  glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
  
  // 编译失败
  if (!status) {
    GLint infoLen = 0;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &infoLen);
    if (infoLen > 1) {
      // 进行失败信息输出
      char *infoLog = malloc(sizeof(char) * infoLen);
      glGetShaderInfoLog(*shader, infoLen, NULL, infoLog);
      NSLog(@"Error compiling shader: \n%s\n", infoLog);
      free(infoLog);
    }
    
    glDeleteShader(*shader);
    return NO;
  }
  return YES;
}

#pragma mark - Public
- (void)addAttribute:(NSString *)attributeName {
  if (![_attributes containsObject:attributeName]) {
    [_attributes addObject:attributeName];
    glBindAttribLocation(self.program, (GLuint)[_attributes indexOfObject:attributeName], [attributeName UTF8String]);
  }
}

- (BOOL)link {
  GLint status;
  glLinkProgram(self.program);
  glGetProgramiv(self.program, GL_LINK_STATUS, &status);
  if (!status) {
    GLint infoLen = 0;
    glGetProgramiv(self.program, GL_INFO_LOG_LENGTH, &infoLen);
    if (infoLen > 1) {
      char *infoLog = malloc(sizeof(char) * infoLen);
      glGetProgramInfoLog(self.program, infoLen, NULL, infoLog);
      NSLog(@"Error linking program: \n%s\n", infoLog);
      free(infoLog);
    }
    
    if (_vertexShader) {
      glDeleteShader(_vertexShader);
      _vertexShader = 0;
    }
    
    if (_fragmentShader) {
      glDeleteShader(_fragmentShader);
      _fragmentShader = 0;
    }
    return NO;
  }
  
  return YES;
}

- (void)use {
  glUseProgram(self.program);
}

@end
