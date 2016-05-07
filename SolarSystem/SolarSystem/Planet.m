//
//  Planet.m
//  SolarSystem
//
//  Created by Sim Jin on 16/5/2.
//  Copyright © 2016年 UFun. All rights reserved.
//

#import "Planet.h"

@implementation Planet

- (instancetype)init:(GLint)stacks slices:(GLint)slices radius:(GLfloat)radius squash:(GLfloat)squash {
  unsigned int colorIncrement = 0;
  unsigned int blue = 0;
  unsigned int red = 255;
  
  m_Scale = radius;
  m_Squash = squash;
  
  colorIncrement = 255/stacks;
  
  self = [super init];
  if (self) {
    m_Stacks = stacks;
    m_Slices = slices;
    m_VertexData = nil;
    
    // Vertices
    // 第一个是存储数据类型所占的大小
    // 第二个是坐标有x,y,z三个值标示。可类推顶点和法线数组都是3，颜色RGBA是4，纹理S,T是2
    // 最后一个(m_Slices*2+2)*m_Stacks是切割线的交点数目，一条纬度切割线和经度切割线相交得两个交点，加上南北极点。所以是+2
    GLfloat *vPtr = m_VertexData = (GLfloat*)malloc(sizeof(GLfloat) * 3 * ((m_Slices*2+2) * (m_Stacks)));
    
    // Color data
    GLubyte *cPtr = m_colorData = (GLubyte *)malloc(sizeof(GLubyte) * 4 * ((m_Slices*2+2) * (m_Stacks)));
    
    unsigned int phiIdx, thetaIdx;
    
    // latitude
    for (phiIdx = 0; phiIdx < m_Stacks; phiIdx++) {
      // 这里用的坐标系为球坐标系，标记方法为数学标记约定。即phi为天顶角，theta为方位角
      // Starts at -1.57 goes up to +1.57 radians (-90度到90度)
      
      // The first circle
      float phi0 = M_PI * ((float)(phiIdx+0) * (1.0/(float)(m_Stacks)) - 0.5);
      
      // The next or second one
      float phi1 = M_PI * ((float)(phiIdx+1) * (1.0/(float)(m_Stacks)) - 0.5);
      float cosPhi0 = cos(phi0);
      float sinPhi0 = sin(phi0);
      float cosPhi1 = cos(phi1);
      float sinPhi1 = sin(phi1);
      
      float cosTheta, sinTheta;
      
      // longitude
      for (thetaIdx = 0; thetaIdx < m_Slices; thetaIdx++) {
        // Increment along the longitude circle each "slice".
        float theta = 2.0*M_PI * ((float)thetaIdx) * (1.0/(float)(m_Slices-1));
        
        cosTheta = cos(theta);
        sinTheta = sin(theta);
        
        /*
         We are generating a vertical pair of points, such as the first point of stack
         1 above it. This is how TRIANGLE_STRIPS work, taking a set of 4 vertices
         and essentially drawing two triangles at a time. The first is v0-v1-v2 and 
         the next is v2-v1-v3, and so on.
         */
        
        // Get x-y-z for the first vertex of stack
        vPtr[0] = m_Scale * cosPhi0 * cosTheta;
        vPtr[1] = m_Scale * sinPhi0 * m_Squash;
        vPtr[2] = m_Scale * cosPhi0 * sinTheta;
        
        // The same but for the vertex immediately above the previous one
        vPtr[3] = m_Scale * cosPhi1 * cosTheta;
        vPtr[4] = m_Scale * sinPhi1 * m_Squash;
        vPtr[5] = m_Scale * cosPhi1 * sinTheta;
        
        cPtr[0] = red;
        cPtr[1] = 0;
        cPtr[2] = blue;
        cPtr[4] = red;
        cPtr[5] = 0;
        cPtr[6] = blue;
        cPtr[3] = cPtr[7] = 255;
        
        cPtr += 2*4;
        vPtr += 2*3;
      }
      blue += colorIncrement;
      red -= colorIncrement;
    }
  }
  return self;
}

- (bool)excute {
  glMatrixMode(GL_MODELVIEW);
  glEnable(GL_CULL_FACE);
  glCullFace(GL_BACK);
  
  glEnableClientState(GL_VERTEX_ARRAY);
  glEnableClientState(GL_COLOR_ARRAY);
  
  glVertexPointer(3, GL_FLOAT, 0, m_VertexData);
  
  glColorPointer(4, GL_UNSIGNED_BYTE, 0, m_colorData);
  glDrawArrays(GL_TRIANGLE_STRIP, 0, (m_Slices+1)*2*(m_Stacks-1)+2);
  
  return true;
}

@end
