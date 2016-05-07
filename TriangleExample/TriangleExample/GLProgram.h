//
//  GLProgram.h
//  TriangleExample
//
//  Created by Sim Jin on 16/5/7.
//  Copyright © 2016年 UFun. All rights reserved.
//

// According to Hantan's HTY360Player: https://github.com/hanton/HTY360Player

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface GLProgram : NSObject

- (instancetype)initWithVertexShaderString:(NSString *)vShaderString fragmentShaderString:(NSString *)fShaderString;
- (instancetype)initWithVertexShaderFileName:(NSString *)vShaderFileName fragmentShaderFileName:(NSString *)fShaderFileName;
- (instancetype)initWithVertexShaderString:(NSString *)vShaderString fragmentShaderFileName:(NSString *)fShaderFileName;
- (instancetype)initWithVertexShaderFileName:(NSString *)vShaderFileName fragmentShaderString:(NSString *)fShaderString;

- (void)addAttribute:(NSString *)attributeName;
- (BOOL)link;
- (void)use;

@end
