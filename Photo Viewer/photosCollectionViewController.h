//
//  photosCollectionViewController.h
//  Photo Viewer
//
//  Created by Paras Gorasiya on 14/05/16.
//  Copyright © 2016 Paras Gorasiya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface photosCollectionViewController : UIViewController<UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
- (IBAction)backButtonTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *noPhotoLabel;

@end
