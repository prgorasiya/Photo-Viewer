//
//  photosViewController.h
//  Photo Viewer
//
//  Created by Paras Gorasiya on 14/05/16.
//  Copyright © 2016 Paras Gorasiya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface photosViewController : UIViewController
{
    NSMutableArray * _albumsArray;
    
    ALAssetsLibrary * library;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)backButtonTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *bgView;

@end
