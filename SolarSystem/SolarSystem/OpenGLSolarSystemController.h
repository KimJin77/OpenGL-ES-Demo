//
//  OpenGLSolarSystemController.h
//  SolarSystem
//
//  Created by Sim Jin on 16/5/3.
//  Copyright © 2016年 UFun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "Planet.h"

@interface OpenGLSolarSystemController : NSObject {
  Planet *m_Earth;
}

- (void)excute;
- (instancetype)init;
- (void)initGeometry;

@end
