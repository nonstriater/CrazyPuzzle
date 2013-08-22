//
//  UIImageAddition.h
//  Social
//
//  Created by mobcent on 13-5-31.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (Additions)


typedef enum {
    ALPHA = 0,
    BLUE = 1,
    GREEN = 2,
    RED = 3
} PIXELS;

///--------------------------------
/// @name Instance method
///--------------------------------

/**
 将一张图片一分为二 
 */
+ (NSArray*)splitImageIntoTwoParts:(UIImage*)image;


// 0 代表左右分 1 代表上下分
+(NSArray *)splitImageIntoTwoParts:(UIImage *)image orientation:(int)orientation;
+(NSArray *)splitImageIntoTwoParts:(UIImage *)image orientations:(int)orientation;


/**
 @brief 将image尺寸变换为size
 
 @param image   the image to be rese
 @param size   the size you wanted
 @return  new image
 */
+ (UIImage *)scale:(UIImage *)image toSize:(CGSize)size;


/**
 按比例缩放图片
 */
+ (UIImage *)scaleAspect:(UIImage *)image toSize:(CGSize)size;



///---------------------------------
/// @name image resize
///---------------------------------


/**
 将image尺寸变换为size
 */
- (UIImage*)scaleToSize:(CGSize)size;


/**
 @brief 
 */
- (UIImage *)thumbnailImage:(NSInteger)thumbnailSize
          transparentBorder:(NSUInteger)borderSize
               cornerRadius:(NSUInteger)cornerRadius
       interpolationQuality:(CGInterpolationQuality)quality;

/**
 @brief  Returns a rescaled copy of the image, taking into account its orientation
 @discussion The image will be scaled disproportionately if necessary to fit the bounds specified by the parameter
 */
- (UIImage *)resizedImage:(CGSize)newSize
     interpolationQuality:(CGInterpolationQuality)quality;

/**
 @brief
 */
- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality;




///---------------------------------
/// @name alpha
///---------------------------------


/**
 @brief Returns true if the image has an alpha layer
 */
- (BOOL)hasAlpha;

/**
 @brief Returns a copy of the given image, adding an alpha channel if it doesn't already have one
 */
- (UIImage *)imageWithAlpha;

/**
 @brief Returns a copy of the image with a transparent border of the given size added around its edges.
 If the image has no alpha layer, one will be added to it.
 */
- (UIImage *)transparentBorderImage:(NSUInteger)borderSize;



///---------------------------------
/// @name image rounded corner
///---------------------------------

- (UIImage *)roundedCornerImage:(NSInteger)cornerSize borderSize:(NSInteger)borderSize;



///---------------------------------
/// @name image filter
///---------------------------------



/**
 @brief gray
 
 @discussion   使用下面算法计算灰度值，然后将该灰度值赋给每个rgb通道
        uint32_t gray = 0.3 * rgbaPixel[RED] + 0.59 * rgbaPixel[GREEN] + 0.11 * rgbaPixel[BLUE];
 
 @return Returns a gray image
 
 */
- (UIImage *)convertToGrayscale;


///---------------------------------
/// @name image frome view
///---------------------------------


+ (UIImage *)imageFromView:(UIView *)view;



@end
