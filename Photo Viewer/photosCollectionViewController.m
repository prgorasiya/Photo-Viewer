//
//  photosCollectionViewController.m
//  Photo Viewer
//
//  Created by Paras Gorasiya on 14/05/16.
//  Copyright © 2016 Paras Gorasiya. All rights reserved.
//

#import "photosCollectionViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "imageCollectionViewCell.h"
#import "AppDelegate.h"

#define SharedAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])


@interface photosCollectionViewController ()

@property (strong) NSMutableArray *thumbnails;
@property (strong) NSMutableArray *fullImages;
@property (strong) NSMutableArray *imageNames;

@end

@implementation photosCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    [self getFullScreenImages];
    
    ALAssetsLibrary *library = [ALAssetsLibrary new];
    
    self.thumbnails = [NSMutableArray new];
    self.imageNames = [NSMutableArray new];
    
    void (^enumerate)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop)
    {
        if ([[group valueForProperty:@"ALAssetsGroupPropertyType"] intValue] == ALAssetsGroupSavedPhotos)
        {
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                
                ALAssetRepresentation *rep = [result defaultRepresentation];
                
                if (result != NULL)
                {
                    [self.imageNames addObject:rep.filename];
                    
                    if (result.thumbnail == nil)
                    {
                        [self.thumbnails addObject:[UIImage imageWithCGImage:[[result defaultRepresentation] fullScreenImage]]];
                    }
                    else
                    {
                        [self.thumbnails addObject:[UIImage imageWithCGImage:result.thumbnail]];
                    }
                }
            }];
            
            [self updateUI];
//            [self getFullScreenImages];
        }
    };
    
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                           usingBlock:enumerate
                         failureBlock:nil];
}


- (void)updateUI
{
    [self.collectionView reloadData];
}



-(void)getFullScreenImages
{
    ALAssetsLibrary *library = [ALAssetsLibrary new];
    
    self.fullImages = [NSMutableArray new];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        void (^enumerate)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop)
        {
            if ([[group valueForProperty:@"ALAssetsGroupPropertyType"] intValue] == ALAssetsGroupSavedPhotos)
            {
                [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                    
                    if (result != NULL)
                    {
                        [self.fullImages addObject:[UIImage imageWithCGImage:[[result defaultRepresentation] fullScreenImage]]];
                    }
                }];
            }
        };
        
        [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                               usingBlock:enumerate
                             failureBlock:nil];
        
    });
}


#pragma Mark UICollectionView Delegates

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.thumbnails.count == 0)
    {
        [self.collectionView setHidden:YES];
        [self.noPhotoLabel setHidden:NO];
    }
    else
    {
        [self.collectionView setHidden:NO];
        [self.noPhotoLabel setHidden:YES];
    }
    return self.thumbnails.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float width = (self.view.frame.size.width/3) - 7;
    float height = width;
    
    CGSize viewSize = CGSizeMake(width, height);
    
    return viewSize;
}


- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    imageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.imageView.image = self.thumbnails[indexPath.row];
    
    cell.imageView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    cell.imageView.layer.shadowOffset = CGSizeMake(2, 2);
    cell.imageView.layer.shadowOpacity = 1.0;
    cell.imageView.layer.shadowRadius = 1.0;
    cell.imageView.clipsToBounds = NO;
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.fullImages count] > 0)
    {
        SharedAppDelegate.photosArray = self.fullImages;
        SharedAppDelegate.namesArray = self.imageNames;
    }
    
    SharedAppDelegate.curIndex = indexPath.item;
    
    [self performSegueWithIdentifier:@"showDetail" sender:self];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)backButtonTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
