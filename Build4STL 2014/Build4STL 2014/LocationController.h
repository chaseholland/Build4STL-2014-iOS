//
//  LocationController.h
//  BarsOfLife
//
//  Created by Chase Holland on 4/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
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

+ (LocationController *)sharedInstance;

-(void) start;
-(void) stop;
-(BOOL) locationKnown;

@property (nonatomic, retain) CLLocation *currentLocation;

@end
