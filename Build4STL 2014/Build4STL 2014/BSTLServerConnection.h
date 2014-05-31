//
//  BSTLServerConnection.h
//  Build4STL 2014
//
//  Created by Chase Holland on 5/31/14.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface BSTLServerConnection : NSObject

//
/// \brief Gets a connection to our singleton instance of the server connection
//
+ (BSTLServerConnection*) connection;

//
/// \brief Grabs the weather data as a dictionary at the specified location
/// \param location Location to get weather at
/// \return weatherData Returns a dictionary weather data from the weather underground api
//
- (void) getWeatherDataAtLocation:(CLLocation*)location withCompletetion:(void (^)(NSDictionary* weatherData, NSError* error))completionBlock;

@end
