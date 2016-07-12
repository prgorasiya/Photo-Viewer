//
//  photoDetailViewController.h
//  Photo Viewer
//
//  Created by Paras Gorasiya on 14/05/16.
//  Copyright © 2016 Paras Gorasiya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface photoDetailViewController : UIPageViewController

@property (nonatomic) NSUInteger *curIndex;

- (IBAction)backButtonTapped:(id)sender;

@end
