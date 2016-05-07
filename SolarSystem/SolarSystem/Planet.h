//
//  Planet.h
//  SolarSystem
//
//  Created by Sim Jin on 16/5/2.
//  Copyright © 2016年 UFun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES1/gl.h>

@interface Planet : NSObject {
  GLfloat *m_VertexData;
  GLubyte *m_colorData;
  
  GLint m_Stacks, m_Slices;
  GLfloat m_Scale;
  GLfloat m_Squash;
}

- (bool)excute;
- (instancetype)init:(GLint)stacks slices:(GLint)slices radius:(GLfloat)radius squash:(GLfloat)squash;

@end
