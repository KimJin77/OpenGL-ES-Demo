//
//  ViewController.m
//  BouncySquare
//
//  Created by Sim Jin on 16/5/1.
//  Copyright © 2016年 UFun. All rights reserved.
//

#import "ViewController.h"
#import <OpenGLES/ES1/gl.h>

@interface ViewController ()

@property (nonatomic, strong) EAGLContext *context;
@property (nonatomic, strong) GLKBaseEffect *effect;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
  if (!self.context) {
    NSLog(@"Failed to create ES context");
  }
  
  GLKView *view = (GLKView *)self.view;
  view.context = self.context;
  view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
  
  [EAGLContext setCurrentContext:self.context];
  [self setClipping];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - GLKView and GLKViewController Delegate
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
  
  //2D
  
  static int counter = 0;
//  static const GLfloat squareVertices[] = {
//    -0.5, -0.33,
//    0.5, -0.33,
//    -0.5, -0.33,
//    0.5, 0.33,
//  };
//  static const GLubyte squareColors[] = {
//    255, 255, 0, 255,
//    0, 255, 255, 255,
//    0, 0, 0, 0,
//    255, 0, 255, 255,
//  };
//  
//  static float transY = 0.0;
//  
//  glClearColor(0.5, 0.5, 0.5, 1.0);
//  glClear(GL_COLOR_BUFFER_BIT);
//  
//  // 设置投射矩阵
//  glMatrixMode(GL_PROJECTION);
//  glLoadIdentity();
//  
//  // 设置模型矩阵
//  glMatrixMode(GL_MODELVIEW);
//  glLoadIdentity();
//  glTranslatef(0.0, (GLfloat)(sinf(transY/2.0)), 0.0);
//  
//  transY += 0.075f;
//  
//  // 让OpenGL知道数据的类型和位置
//  glVertexPointer(2, GL_FLOAT, 0, squareVertices); // 表示两个值一组
//  glEnableClientState(GL_VERTEX_ARRAY); // 通知系统使用数组数据
//  glColorPointer(4, GL_UNSIGNED_BYTE, 0, squareColors);
//  glEnableClientState(GL_COLOR_ARRAY);
//  
//  glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
//  
//  if (!(counter%100));
//    NSLog(@"FPS: %d \n", self.framesPerSecond);
//  counter++;
  
  // 3D
  static GLfloat spinX = 0;
  static GLfloat spinY = 0;
  
  spinY += .25;
  spinX += .25;
  
  static const GLfloat cubeVertices[] = {
    -0.5, 0.5, 0.5,   // vertex 0
    0.5, 0.5, 0.5,    // v1
    0.5, -0.5, 0.5,   // v2
    -0.5, -0.5, 0.5,  // v3
    -0.5, 0.5, -0.5,  // v4
    0.5, 0.5, -0.5,   // v5
    0.5, -0.5, -0.5,  // v6
    -0.5, -0.5, -0.5, // v7
  };
  
  static const GLubyte cubeColors[] = {
    255, 255, 0, 255,
    0, 255, 255, 255,
    0, 0, 0, 0,
    255, 0, 255, 255,
    
    255, 255, 0, 255,
    0, 255, 255, 255,
    0, 0, 0, 0,
    255, 0, 255, 255,
  };
  static const GLubyte tfan1[6 * 3] = {
    1, 0, 3,
    1, 3, 2,
    1, 2, 6,
    1, 6, 5,
    1, 5, 4,
    1, 4, 0
  };
  static const GLubyte tfan2[6 * 3] = {
    7, 4, 5,
    7, 5, 6,
    7, 6, 2,
    7, 2, 3,
    7, 3, 0,
    7, 0, 4
  };
  static GLfloat transY = 0.0;
  static GLfloat z = -20.0;
  glClearColor(0.5, 0.5, 0.5, 1.0);
  glClear(GL_COLOR_BUFFER_BIT);
  glEnable(GL_CULL_FACE); // 移除看不见的面
  glCullFace(GL_FRONT);
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();

  
  
  glTranslatef(0.0, (GLfloat)sinf(transY/2.0), z);
  glRotatef(spinX, 1.0, 0.0, 0.0);
  glRotatef(spinY, 0.0, 1.0, 0.0);
  transY += 0.075f;

  glVertexPointer(3, GL_FLOAT, 0, cubeVertices);
  glEnableClientState(GL_VERTEX_ARRAY);
  glColorPointer(4, GL_UNSIGNED_BYTE, 0, cubeColors);
  glEnableClientState(GL_COLOR_ARRAY);
  
  glDrawElements(GL_TRIANGLE_FAN, 6 * 3, GL_UNSIGNED_BYTE, tfan1); // 第二个参数表明绘制的数量
  glDrawElements(GL_TRIANGLE_FAN, 6 * 3, GL_UNSIGNED_BYTE, tfan2);
  
  if (!(counter%100))
    NSLog(@"FPS: %d\n", self.framesPerSecond);
  counter++;
}

// Creating the viewing frustum, added to the View Controller file
- (void)setClipping {
  float aspectRatio;
  
  // 指定平头椎体的视觉范围，从0.1-1000
  const float zNear = .1;
  const float zFar = 1000;
  // 将FOV设置为60度
  const float fieldOfView = 5.0;
  GLfloat size;
  
  CGRect frame = [[UIScreen mainScreen] bounds];
  
  // 高度和宽度值会固定住fov的高度，  进行旋转的话则是其宽度。
  // 所以如果我们想要获取60度角的视觉范围，类似广角镜头那样的效果，这将是基于window的高度而不是宽度。在渲染非正方形屏幕时需要注意这点。
  // 计算屏幕纵横比
  aspectRatio = (float)frame.size.width/(float)frame.size.height;
  
  // 设置OpenGL投影
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  
  // 计算上下左右查看的体积限制
  size = zNear * tanf(GLKMathDegreesToRadians(fieldOfView) / 2.0);
   // size除以纵横比以确保能够得到一个正方形
  glFrustumf(-size, size, -size/aspectRatio, size/aspectRatio, zNear, zFar);
  glViewport(0, 0, frame.size.width, frame.size.height);
  
  glMatrixMode(GL_MODELVIEW);
}

@end
