//
//  LocationController.h
//  BarsOfLife
//
//  Created by Chase Holland on 4/22/11.
//  Copyright 2011 Chase Holland. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import "LocationDelegate.h"

@interface  LocationController : NSObject <CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    CLLocation *m_currentLocation;
    id<LocationDelegate> m_delegate;
    
    BOOL m_enabled;
}

@property(nonatomic, assign) id<LocationDelegate> delegate;

//
/// \brief Grabs a singleton instance of the location controller
//
+ (LocationController *)sharedInstance;

//
/// \brief starts the location controller listening for location updates / grabbing a location
//
-(void) start;

//
/// \brief stops the location controller from listening for location updates (call this definitely before the app terminates
//
-(void) stop;

//
/// \brief Determines whether or not a location is known
/// \return True if location is known else false -- also returns false if location is off
//
-(BOOL) locationKnown;

@property (nonatomic, retain) CLLocation *currentLocation;

@end
