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

@property (nonatomic, strong) AppDelegate *mainAppDelegate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSString *parishTitle;
@property (nonatomic, strong) NSNumber *number;
@property (nonatomic, strong) NSString *pAddress;
@property (nonatomic, strong) NSString *pCity;
@property (nonatomic, strong) NSString *pState;
@property (nonatomic, strong) NSString *pZip;
@property (nonatomic, strong) NSString *pURL;
@property (nonatomic, strong) NSNumber *pLatitude;
@property (nonatomic, strong) NSNumber *pLongitude;
@property (nonatomic, strong) NSNumber *userLatitude;
@property (nonatomic, strong) NSNumber *userLongitude;
@property (nonatomic, strong) NSMutableArray *parishMassTimes;
@property (nonatomic, strong) NSMutableArray *parishReconciliationTimes;
@property (nonatomic, strong) NSMutableArray *parishAdorationTimes;

- (void)getParishInformationFromNumber;
- (void)getParishEventTimeInformation;
- (void)locationUpdate:(CLLocation *)location;
- (void)locationError:(NSError *)error;

@end
