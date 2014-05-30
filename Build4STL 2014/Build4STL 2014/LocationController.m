//
//  LocationController.m
//  BarsOfLife
//
//  Created by Chase Holland on 4/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LocationController.h"

@implementation LocationController

@synthesize currentLocation = m_currentLocation;
@synthesize delegate = m_delegate;

static LocationController *sharedInstance;

+ (LocationController *)sharedInstance {
    @synchronized(self) {
        if (!sharedInstance)
            sharedInstance=[[LocationController alloc] init];       
    }
    return sharedInstance;
}

+(id)alloc {
    @synchronized(self) {
        NSAssert(sharedInstance == nil, @"Attempted to allocate a second instance of a singleton LocationController.");
        sharedInstance = [super alloc];
    }
    return sharedInstance;
}

-(id) init {
    if ((self = [super init]))
    {
        self.currentLocation = [[[CLLocation alloc] init] autorelease];
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.purpose = @"Enable location services to see advertisements about places near you.";
        m_enabled = YES;
        [self start];
    }
    return self;
}

- (void) dealloc
{
	[locationManager release];
	locationManager = nil;
	[super dealloc];
}

-(void) start {
    [locationManager startUpdatingLocation];
}

-(void) stop {
    [locationManager stopUpdatingLocation];
}

-(BOOL) locationKnown
{ 
    if (m_enabled == NO)
    {
        return NO;
    }
    if (m_currentLocation.horizontalAccuracy <= 300.f)
        return YES;

    else
        NSLog(@"horizontalAccuracy: %f", m_currentLocation.horizontalAccuracy);
        return NO; 
}

- (void) locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status != kCLAuthorizationStatusAuthorized)
    {
        m_enabled = NO;
    }
    else // location authorized
    {
        m_enabled = YES;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    //if the time interval returned from core location is more than two minutes we ignore it because it might be from an old session
    if ( abs([newLocation.timestamp timeIntervalSinceDate: [NSDate date]]) < 120)
    {
        self.currentLocation = newLocation;
		if (!self.delegate || m_enabled == NO)
		{
			return;
		}
		if ([self.delegate respondsToSelector:@selector(locationAquired)])
		{
			[self.delegate locationAquired];
		}
		else
		{
			NSLog(@"%@ does not respond to locationAquired!", self.delegate);
		}
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Location failed");
}
@end
