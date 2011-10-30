//
//  JJGCLController.h
//  Catholic Diocese
//
//  Created by Jeff Geerling on 2/15/11.
//

#import <Foundation/Foundation.h>


@protocol JJGCLControllerDelegate

@required
- (void)locationUpdate:(CLLocation *)location;
- (void)locationError:(NSError *)error;

@end


@interface JJGCLController : NSObject <CLLocationManagerDelegate> {

	CLLocationManager *locationManager;
	id __unsafe_unretained delegate;
	
}

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, unsafe_unretained) id delegate;

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation;

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error;

@end
