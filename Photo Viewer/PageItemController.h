//
//  PageItemController.h
//  Photo Viewer
//
//  Created by Paras Gorasiya on 15/05/16.
//  Copyright © 2016 Paras Gorasiya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageItemController : UIViewController<UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UILabel *imageName;

@property (nonatomic) NSUInteger itemIndex;
@property (nonatomic) NSInteger count;

@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;

// IBOutlets
@property (nonatomic, weak) IBOutlet UIImageView *contentImageView;

- (IBAction)showSharingOptions:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnSharing;

- (IBAction)backButtonTapped:(id)sender;


@end
