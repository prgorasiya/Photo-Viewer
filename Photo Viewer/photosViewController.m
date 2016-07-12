//
//  photosViewController.m
//  Photo Viewer
//
//  Created by Paras Gorasiya on 14/05/16.
//  Copyright © 2016 Paras Gorasiya. All rights reserved.
//

#import "photosViewController.h"
#import "COAssetsController.h"


@interface photosViewController ()

@end

@implementation photosViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self navigationController] setNavigationBarHidden:YES animated:NO];

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    library = [[ALAssetsLibrary alloc] init];
    
    _albumsArray = [[NSMutableArray alloc] init];
    
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        
        if (group)
        {
            [_albumsArray addObject:group];
        }
        else
        {
            [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
    };
    
    [self.tableView setHidden:NO];
    [self.bgView setHidden:YES];
    
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error)
    {
        NSString *errorMessage = nil;
        switch ([error code])
        {
            case ALAssetsLibraryAccessUserDeniedError:
            case ALAssetsLibraryAccessGloballyDeniedError:
            {
                errorMessage = @"The user has declined access to it.";
                [self.tableView setHidden:YES];
                [self.bgView setHidden:NO];
            }
                break;
            default:
            {
                errorMessage = @"Reason unknown.";
                [self.tableView setHidden:YES];
                [self.bgView setHidden:NO];
            }
                break;
        }
        
        NSLog(@"errorMessage :%@", errorMessage);
    };
    
    [library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:listGroupBlock failureBlock:failureBlock];
    
    [self.tableView reloadData];
}



#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _albumsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![_albumsArray count])
    {
        static NSString * emptyCell = @"emptyCell";
        
        UITableViewCell * cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:emptyCell];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:emptyCell];
            
            cell.backgroundColor = [UIColor clearColor];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            
            cell.textLabel.textColor = [UIColor whiteColor];
            
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
            
            cell.textLabel.text = @"No albums.";
        }
        
        return cell;
    }
    
    NSString * CellIdentifier = [@"" stringByAppendingFormat:@"Cell"];
    
    UITableViewCell * cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.backgroundColor = [UIColor clearColor];
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    ALAssetsGroup * g = (ALAssetsGroup*)[_albumsArray objectAtIndex:indexPath.row];
        
    [g setAssetsFilter:[ALAssetsFilter allAssets]];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%ld)",[g valueForProperty:ALAssetsGroupPropertyName], (long)[g numberOfAssets]];
    
    [cell.imageView setImage:[UIImage imageWithCGImage:[g posterImage]]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self performSegueWithIdentifier:@"showPhotos" sender:self];
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
