//
//  BSTLServerConnection.m
//  Build4STL 2014
//
//  Created by Chase Holland on 5/31/14.
//

#import "BSTLServerConnection.h"
#import "Config.h"

#define SERVER @"http://api.wunderground.com/api/"

// Declare some stuff so that these only appear once in memory
static BSTLServerConnection *shared = nil;
static dispatch_once_t once;
static NSOperationQueue *connectionQueue;

// Redeclare the interface in the implementation file so this method is not visible in the header
@interface BSTLServerConnection()

//
/// \brief Grabs the global connection queue for the fancy asychronous stuff
//
+ (NSOperationQueue *)connectionQueue;

@end

@implementation BSTLServerConnection

+ (BSTLServerConnection*) connection
{
    // If our singleton does not yet exist, we should create one
    if (!shared)
        shared = [[BSTLServerConnection alloc] init];
    
    return shared;
}

+ (NSOperationQueue *)connectionQueue
{
    dispatch_once(&once, ^{
        connectionQueue = [[NSOperationQueue alloc] init];
        [connectionQueue setMaxConcurrentOperationCount:2];
        [connectionQueue setName:@"org.buildforstl.connectionqueue"];
    });
    return connectionQueue;
}

- (void) getWeatherDataAtLocation:(CLLocation*)location withCompletetion:(void (^)(NSDictionary* weatherData, NSError* error))completionBlock
{
    // Define a URL Request that's going to the server we have defined (the weather underground server)
    // And then format the request so it looks like their example at
    //http://www.wunderground.com/weather/api/d/docs?d=data/geolookup&MR=1
    
    NSURLRequest* r = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/forecast/q/%f,%f.json", SERVER, WUNDERGROUND_API_KEY, location.coordinate.latitude, location.coordinate.longitude]]];
    
    NSLog(@"Request URL is %@", r.URL.absoluteString);
    
    // open the URL Connection with the queue we created earlier
    [NSURLConnection sendAsynchronousRequest:r queue:[BSTLServerConnection connectionQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         NSError* deserializerError = nil;
         
         // The url connection stuff returns a blob of encoded data, it's up to us to deserialize it and turn it into the type of object we are expecting
         NSDictionary* weatherData = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error:&deserializerError];
         
         NSLog(@"Weather data %@", weatherData);
         
         // always good to check if there was an error
         if (error)
             NSLog(@"%s -- Error: %@", __PRETTY_FUNCTION__, [error localizedDescription]);
         if (deserializerError)
             NSLog(@"%s -- Error: %@", __PRETTY_FUNCTION__, [deserializerError localizedDescription]);
         
         // if there is no regular error, but there is a deserialize error, return the deserialize error
         if (deserializerError && !error)
             error = deserializerError;
         
         if (completionBlock)
             completionBlock(weatherData, error);
     }];
}

- (void) dealloc
{
    // release all of our objects
    [connectionQueue release]; connectionQueue = nil;
    [shared release]; shared = nil;
    
    [super dealloc];
}

@end
