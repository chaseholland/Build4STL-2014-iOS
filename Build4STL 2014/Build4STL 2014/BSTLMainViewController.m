//
//  BSTLMainViewController.m
//  Build4STL 2014
//
//  Created by Chase Holland on 5/30/14.
//

#import "BSTLMainViewController.h"
#import "BSTLServerConnection.h"
#import "LocationController.h"

@interface BSTLMainViewController ()

@end

@implementation BSTLMainViewController

#pragma mark -
#pragma mark NSObject / UIView

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[LocationController sharedInstance] start];
}

#pragma mark -
#pragma mark BSTLMainViewController

- (IBAction)updateButtonPressed:(id)sender
{
    // First check if we are still updating
    if (m_updateIndicatorView.isAnimating)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Still getting an update..." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release]; alert = nil;
        
        // exit the function here
        return;
    }
    
    // check to make sure we have a location
    if (![[LocationController sharedInstance] locationKnown])
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Still getting your location..." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release]; alert = nil;
        
        return;
    }
    
    // start the update spinner
    [m_updateIndicatorView startAnimating];
    
    // Grab a shared connection to the server
    BSTLServerConnection* connection = [BSTLServerConnection connection];
    [connection getWeatherDataAtLocation:[[LocationController sharedInstance] currentLocation] withCompletetion:^(NSDictionary* weatherData, NSError* error){
        // We are now inside a "Block" -- this will not be called until the iPhone has the data we are looking for (or an error)
        
        if (error)
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release]; alert = nil;
            
            // stop the spinner from animating since it threw an error
            [m_updateIndicatorView stopAnimating];
            
            return;
        }
        
        NSLog(@"Updating the GUI!");
        
        // parse out what we want and update the GUI
        NSDictionary* forecastData = [[weatherData objectForKey:@"forecast"] objectForKey:@"simpleforecast"];
        NSDictionary* todayData = [[forecastData objectForKey:@"forecastday"] objectAtIndex:0];
        
        NSInteger high = [[[todayData objectForKey:@"high"] objectForKey:@"fahrenheit"] intValue];
        NSInteger low = [[[todayData objectForKey:@"low"] objectForKey:@"fahrenheit"] intValue];
        
        // determine pants or shorts
        if (high >= 80 && low >= 64)
            m_pantsOrShortsLabel.text = @"Shorts";
        else
            m_pantsOrShortsLabel.text = @"Pants";
        
        // update the high / low labels
        m_highTempLabel.text = [NSString stringWithFormat:@"%ld", (long)high];
        m_lowTempLabel.text = [NSString stringWithFormat:@"%ld", (long)low];
        
        // kill the update spinner
        [m_updateIndicatorView stopAnimating];
    }];
}

@end
