//
//  BSTLMainViewController.h
//  Build4STL 2014
//
//  Created by Chase Holland on 5/30/14.
//

#import <UIKit/UIKit.h>

@interface BSTLMainViewController : UIViewController
{
    IBOutlet UIButton* m_updateButton;
    IBOutlet UILabel* m_pantsOrShortsLabel;
    IBOutlet UILabel* m_highTempLabel;
    IBOutlet UILabel* m_lowTempLabel;
    IBOutlet UIActivityIndicatorView* m_updateIndicatorView;
}

//
/// \brief This gets called when the update button was pressed
/// \param sender A generic reference to what object is sending the button press
/// \note IBAction specifies that this is an action that should appear in Interface Builder -- it has the same return type as void
//
- (IBAction)updateButtonPressed:(id)sender;

- (void) updateWeather:(NSDictionary*) weatherData;

@end
