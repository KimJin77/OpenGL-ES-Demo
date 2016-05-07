//
//  OpenGLSolarSystemController.m
//  SolarSystem
//
//  Created by Sim Jin on 16/5/3.
//  Copyright © 2016年 UFun. All rights reserved.
//

#import "OpenGLSolarSystemController.h"

@implementation OpenGLSolarSystemController

- (instancetype)init {
  [self initGeometry];
  
  return self;
}

- (void)initGeometry {
  m_Earth = [[Planet alloc] init:20 slices:20 radius:1.0 squash:1.0];
}

- (void)excute {
  static GLfloat angle = 0;
  
  glLoadIdentity();
//  glTranslatef(0.0, -0.0, -3.0);
  static GLfloat transY = 0.0;
  glTranslatef(0.0, (GLfloat)sinf(transY/2.0), -3.0);
  glRotatef(angle, 0.0, 1.0, 0.0);
  transY+=0.075;
  [m_Earth excute];
  
  angle+=.5;
}

@end
