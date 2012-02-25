//
//  JJGCLController.m
//  Catholic Diocese
//
//  Created by Jeff Geerling on 2/15/11.
//

#import "JJGCLController.h"


@implementation JJGCLController

@synthesize locationManager, delegate;


#pragma mark Location Manager methods

- (id) init {
    self = [super init];
    if (self != nil) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self; // send loc updates to myself
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
	[self.delegate locationUpdate:newLocation];
}

- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error {
	[self.delegate locationError:error];
}


#pragma mark Memory management

- (void)dealloc {
    [self locationManager];
}


@end
