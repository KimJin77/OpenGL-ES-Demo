//
//  ViewController.m
//  TriangleExample
//
//  Created by Sim Jin on 16/5/7.
//  Copyright © 2016年 UFun. All rights reserved.
//

#import "ViewController.h"
#import <OpenGLES/ES2/gl.h>
#import "GLProgram.h"

@interface ViewController () {
  GLProgram *_program;
}
@property (nonatomic, strong) EAGLContext *context;
@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
  
  GLKView *view = (GLKView *)self.view;
  view.context = self.context;
  view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
  
  [self setupGL];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)setupGL {
  [EAGLContext setCurrentContext:self.context];
  
  [self buildProgram];
  
  if (![_program link]) {
    _program = nil;
    NSAssert(NO, @"Falied to link HalfSpherical shaders");
  }
}

- (void)buildProgram {
  _program = [[GLProgram alloc] initWithVertexShaderFileName:@"Shader" fragmentShaderFileName:@"Shader"];
  [_program addAttribute:@"vPosition"];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
  GLfloat vVertices[] = {
    0.0f, 0.5f, 0.0f,
    -0.5f, -0.5f, 0.0f,
    0.5f, -0.5f, 0.0f
  };
  
  // 设置Viewport
  glViewport(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
  
  // 清空颜色缓存
  glClear(GL_COLOR_BUFFER_BIT);
  
  // 使用Program
  [_program use];
  
  // 加载顶点数据
  glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, vVertices);
  glEnableVertexAttribArray(0);
  
  glDrawArrays(GL_TRIANGLES, 0, 3);
}


@end
