//
//  OpenCVWrapper.h
//  CVTest
//
//  Created by Joseph Skimmons on 5/23/17.
//  Copyright © 2017 Joseph Skimmons. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OpenCVWrapper : NSObject

- (bool)checkColorImg:(UIImage *)type;

- (void) getCVScalar:(int)name;

- (UIImage*) testImg:( UIImage* )image;

@end
