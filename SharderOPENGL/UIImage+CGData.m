//
//  UIImage+CGData.m
//  SharderOPENGL
//
//  Created by ChenYuanfu on 2018/11/19.
//  Copyright © 2018年 Zerozero. All rights reserved.
//

#import "UIImage+CGData.h"
#define kBitsPerComponent   8

#define kBytesPerPixels     4

@implementation UIImage (CGData)

- (NSData *)convertTotextureDatagetWidth:(GLuint *)width height:(GLuint *)height {
    
    CGImageRef cgimage = [self CGImage];
    GLuint glHeight = (GLuint)CGImageGetHeight(cgimage);
    GLuint glWidth = (GLuint)CGImageGetWidth(cgimage);
    CGRect imageRect = CGRectMake(0, 0, glWidth, glHeight);
    *width = glWidth;
    *height = glHeight;
    
    NSMutableData *mTempData = [NSMutableData dataWithLength:glHeight * glWidth * kBytesPerPixels];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef cgContext = CGBitmapContextCreate([mTempData mutableBytes], glWidth, glHeight, kBitsPerComponent, glWidth * kBytesPerPixels, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGContextTranslateCTM(cgContext, 0, glHeight);
    CGContextScaleCTM(cgContext, 1.0f, -1.0f);
    
    CGContextClearRect(cgContext, imageRect);
    CGContextDrawImage(cgContext, imageRect, cgimage);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(cgContext);
    
    //test
    //CGImageRelease(cgimage);
    return mTempData;
}

@end
