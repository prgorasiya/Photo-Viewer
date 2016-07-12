//
//  PageItemController.m
//  Photo Viewer
//
//  Created by Paras Gorasiya on 15/05/16.
//  Copyright © 2016 Paras Gorasiya. All rights reserved.
//

#import "PageItemController.h"
#import "AppDelegate.h"
#import <Social/Social.h>

#define SharedAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])


@interface PageItemController ()
{
    NSTimer *myTimer;
    BOOL isSlideShowOn;
}

@end

@implementation PageItemController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mainScrollView.maximumZoomScale = 3.0f;
    
    // Add doubleTap recognizer to the scrollView
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [self.mainScrollView addGestureRecognizer:doubleTapRecognizer];
    
    // Add two finger recognizer to the scrollView
    UITapGestureRecognizer *twoFingerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTwoFingerTapped:)];
    twoFingerTapRecognizer.numberOfTapsRequired = 1;
    twoFingerTapRecognizer.numberOfTouchesRequired = 2;
    [self.mainScrollView addGestureRecognizer:twoFingerTapRecognizer];
    
    self.contentImageView.image = [SharedAppDelegate.photosArray objectAtIndex:self.itemIndex];
    self.imageName.text = [SharedAppDelegate.namesArray objectAtIndex:self.itemIndex];
    self.countLabel.text = [NSString stringWithFormat:@"%lu of %ld", (unsigned long)self.itemIndex + 1, (long)self.count];
    
    SharedAppDelegate.curIndex = self.itemIndex;
}


-(void)turnOnSlideShow
{
    [myTimer invalidate];
    myTimer = nil;
    
    myTimer = [NSTimer scheduledTimerWithTimeInterval:3.0
                                               target:self
                                             selector:@selector(scrollToNext)
                                             userInfo:nil
                                              repeats:YES];
    
    for (UIScrollView *view in self.parentViewController.view.subviews)
    {
        if ([view isKindOfClass:[UIScrollView class]])
        {
            view.scrollEnabled = NO;
        }
    }
}



-(void)turnOffSlideShow
{
    [myTimer invalidate];
    myTimer = nil;

    for (UIScrollView *view in self.parentViewController.view.subviews)
    {
        if ([view isKindOfClass:[UIScrollView class]])
        {
            view.scrollEnabled = YES;
        }
    }
}


- (void)scrollToNext
{
    if ((SharedAppDelegate.curIndex + 1) >= [SharedAppDelegate.photosArray count])
    {
        SharedAppDelegate.curIndex = -1;
    }
    
    if ((SharedAppDelegate.curIndex+1) < [SharedAppDelegate.photosArray count])
    {
        self.itemIndex = SharedAppDelegate.curIndex+1;
        
        [UIView transitionWithView:self.contentImageView
                          duration:0.2f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            
                            self.contentImageView.image = [SharedAppDelegate.photosArray objectAtIndex:self.itemIndex];
                            self.imageName.text = [SharedAppDelegate.namesArray objectAtIndex:self.itemIndex];
                            self.countLabel.text = [NSString stringWithFormat:@"%lu of %ld", (unsigned long)self.itemIndex + 1, (long)self.count];
                            
                        } completion:NULL];
        
        SharedAppDelegate.curIndex++;
    }
}


-(void)shareOnTwitter
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [tweetSheet setInitialText:@"Sharing this cool picture from my app!"];
        [tweetSheet addImage:self.contentImageView.image];
        
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Seems like your device has no twitter account configured.\nPlease setup atleast one account into settings." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}


- (IBAction)backButtonTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    [myTimer invalidate];
    myTimer = nil;
}


- (IBAction)showSharingOptions:(id)sender
{
    if(!self.contentImageView.image)
    {
        return;
    }
    
    if (isSlideShowOn)
    {
        UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Please Select" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                                @"Turn Off Slideshow",
                                @"Share on Twitter",
                                nil];
        popup.tag = 2;
        [popup showInView:self.view];
    }
    else
    {
        UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Please Select" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                                @"Turn On Slideshow",
                                @"Share on Twitter",
                                nil];
        popup.tag = 1;
        [popup showInView:self.view];
    }
    
}


#pragma mark UIActionSheet delegate method
- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (popup.tag)
    {
            //Turn on slideshow
        case 1:
        {
            switch (buttonIndex)
            {
                case 0:
                {
                    [self turnOnSlideShow];
                    isSlideShowOn = TRUE;
                    
                }
                    break;
                    
                case 1:
                {
                    [self shareOnTwitter];
                }
                    break;
                    
                default:
                    break;
            }
            break;
        }
        
            //Turn off slideshow
        case 2:
        {
            switch (buttonIndex)
            {
                case 0:
                {
                    [self turnOffSlideShow];
                    isSlideShowOn = FALSE;
                }
                    break;
                    
                case 1:
                {
                    [self shareOnTwitter];
                }
                    break;
                    
                default:
                    break;
            }
        }
            
        default:
            break;
    }
}


#pragma mark - ScrollView gesture methods

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    // Return the view that we want to zoom
    return self.contentImageView;
}


- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer
{
    if (isSlideShowOn)
    {
        return;
    }
    
    if(self.mainScrollView.zoomScale > self.mainScrollView.minimumZoomScale)
        [self.mainScrollView setZoomScale:self.mainScrollView.minimumZoomScale animated:YES];
    else
        [self.mainScrollView setZoomScale:self.mainScrollView.maximumZoomScale animated:YES];
}


- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer
{
    if (isSlideShowOn)
    {
        return;
    }
    // Zoom out slightly, capping at the minimum zoom scale specified by the scroll view
    CGFloat newZoomScale = self.mainScrollView.zoomScale / 1.5f;
    newZoomScale = MAX(newZoomScale, self.mainScrollView.minimumZoomScale);
    [self.mainScrollView setZoomScale:newZoomScale animated:YES];
}


- (void)scrollViewDidZoom:(UIScrollView *)aScrollView
{
    if(aScrollView.zoomScale == 1.0)
    {
        [aScrollView setContentSize:aScrollView.frame.size];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
