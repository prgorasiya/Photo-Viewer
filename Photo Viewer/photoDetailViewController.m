//
//  photoDetailViewController.m
//  Photo Viewer
//
//  Created by Paras Gorasiya on 14/05/16.
//  Copyright © 2016 Paras Gorasiya. All rights reserved.
//

#import "photoDetailViewController.h"
#import "PageItemController.h"
#import "AppDelegate.h"


#define SharedAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])


@interface photoDetailViewController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, strong) UIPageViewController *pageViewController;

@end

@implementation photoDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createPageViewController];
    [self setupPageControl];
    
}


- (void) createPageViewController
{
    UIPageViewController *pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    
    if([SharedAppDelegate.photosArray count])
    {
        NSArray *startingViewControllers = @[[self itemControllerForIndex:SharedAppDelegate.curIndex]];
        [pageController setViewControllers: startingViewControllers
                                 direction: UIPageViewControllerNavigationDirectionForward
                                  animated: NO
                                completion: nil];
    }
    
    self.pageViewController = pageController;
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    [self addChildViewController: self.pageViewController];
    [self.view addSubview: self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}


- (void) setupPageControl
{
    [[UIPageControl appearance] setPageIndicatorTintColor: [UIColor clearColor]];
    [[UIPageControl appearance] setCurrentPageIndicatorTintColor: [UIColor whiteColor]];
    [[UIPageControl appearance] setBackgroundColor: [UIColor clearColor]];
}

#pragma mark -
#pragma mark UIPageViewControllerDataSource

- (UIViewController *) pageViewController: (UIPageViewController *) pageViewController viewControllerBeforeViewController:(UIViewController *) viewController
{
    PageItemController *itemController = (PageItemController *) viewController;
    
    if (itemController.itemIndex > 0)
    {
        return [self itemControllerForIndex: itemController.itemIndex-1];
    }
    
    return nil;
}


- (UIViewController *) pageViewController: (UIPageViewController *) pageViewController viewControllerAfterViewController:(UIViewController *) viewController
{
    PageItemController *itemController = (PageItemController *) viewController;
    
    if (itemController.itemIndex+1 < [SharedAppDelegate.photosArray count])
    {
        return [self itemControllerForIndex: itemController.itemIndex+1];
    }
    
    return nil;
}


- (PageItemController *) itemControllerForIndex:(NSUInteger)itemIndex
{
    if (itemIndex < [SharedAppDelegate.photosArray count])
    {
        PageItemController *pageItemController = [self.storyboard instantiateViewControllerWithIdentifier: @"ItemController"];
        pageItemController.itemIndex = itemIndex;
        pageItemController.count = [SharedAppDelegate.photosArray count];
        return pageItemController;
    }
    
    return nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backButtonTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
