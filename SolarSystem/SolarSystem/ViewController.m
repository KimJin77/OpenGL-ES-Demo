//
//  ViewController.m
//  SolarSystem
//
//  Created by Sim Jin on 16/5/2.
//  Copyright © 2016年 UFun. All rights reserved.
//

#import "ViewController.h"
#import "OpenGLSolarSystemController.h"

@interface ViewController () {
  OpenGLSolarSystemController *m_SolarSystem;
}

@property (nonatomic, strong) EAGLContext *context;
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
  
  m_SolarSystem = [[OpenGLSolarSystemController alloc] init];
  
  [EAGLContext setCurrentContext:self.context];
  [self setClipping];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)setClipping {
  float aspectRatio;
  
  const float zNear = .1;
  const float zFar = 1000;
  
  const float fieldOfView = 60;
  
  GLfloat size;
  CGRect frame = [UIScreen mainScreen].bounds;
  aspectRatio = (float)frame.size.width/(float)frame.size.height;
  
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  
  size = zNear*tanf(GLKMathDegreesToRadians(fieldOfView)/2.0);
  
  glFrustumf(-size, size, -size/aspectRatio, size/aspectRatio, zNear, zFar);
  glViewport(0, 0, frame.size.width, frame.size.height);
  
  glMatrixMode(GL_MODELVIEW);
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
  glClearColor(0, 0, 0, 1.0);
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
  
  [m_SolarSystem excute];
}

@end
