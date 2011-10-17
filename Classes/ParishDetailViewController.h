//
//  ParishDetailViewController.h
//  Catholic Diocese
//
//  Created by Jeff Geerling on 2/8/11.
//

#import <UIKit/UIKit.h>
#import "JJGCLController.h"

@class AppDelegate;

@interface ParishDetailViewController : UIViewController <JJGCLControllerDelegate> {

	AppDelegate *mainAppDelegate;
	
	JJGCLController *locationController;
	
	NSString *title;
	NSString *parishTitle;
	NSNumber *number;
	NSString *pAddress;
	NSString *pCity;
	NSString *pState;
	NSString *pZip;
	NSString *pURL;
	NSNumber *pLatitude;
	NSNumber *pLongitude;
	NSNumber *userLatitude;
	NSNumber *userLongitude;
	NSMutableArray *parishMassTimes;
	NSMutableArray *parishReconciliationTimes;
	NSMutableArray *parishAdorationTimes;

}

@property (nonatomic, retain) AppDelegate *mainAppDelegate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, retain) NSString *parishTitle;
@property (nonatomic, retain) NSNumber *number;
@property (nonatomic, retain) NSString *pAddress;
@property (nonatomic, retain) NSString *pCity;
@property (nonatomic, retain) NSString *pState;
@property (nonatomic, retain) NSString *pZip;
@property (nonatomic, retain) NSString *pURL;
@property (nonatomic, retain) NSNumber *pLatitude;
@property (nonatomic, retain) NSNumber *pLongitude;
@property (nonatomic, retain) NSNumber *userLatitude;
@property (nonatomic, retain) NSNumber *userLongitude;
@property (nonatomic, retain) NSMutableArray *parishMassTimes;
@property (nonatomic, retain) NSMutableArray *parishReconciliationTimes;
@property (nonatomic, retain) NSMutableArray *parishAdorationTimes;

- (void)getParishInformationFromNumber;
- (void)getParishEventTimeInformation;
- (void)locationUpdate:(CLLocation *)location;
- (void)locationError:(NSError *)error;

@end
