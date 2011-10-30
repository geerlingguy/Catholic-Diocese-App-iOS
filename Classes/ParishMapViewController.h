//
//  ParishMapViewController.h
//  Catholic Diocese
//
//  Created by Jeff Geerling on 2/3/11.
//

#import <UIKit/UIKit.h>
#import <Mapkit/MapKit.h>

@class AppDelegate;

@interface ParishMapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate> {

	AppDelegate *mainAppDelegate;
	NSNumber *zoomToUserLocation;
	
	IBOutlet MKMapView *parishMap;
	IBOutlet UISegmentedControl *segmentedControlMapType;

}

@property (nonatomic, strong) AppDelegate *mainAppDelegate;
@property (nonatomic, strong) NSNumber *zoomToUserLocation;
@property (nonatomic, strong) IBOutlet MKMapView *parishMap;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentedControlMapType;

- (void)updateParishMapCenter:(NSNotification *)note;
- (IBAction)btnSearch:(id)sender;
- (IBAction)btnLocateMe:(id)sender;
- (IBAction)changeMapType: (id)sender;
- (void)createAnnotationWithCoords:(CLLocationCoordinate2D)coords andTitle:(NSString *)title andSubtitle:(NSString *)subtitle andNumber:(NSNumber *)number;
- (void)createAnnotationsOfParishes;

@end

@interface parishAnnotation: NSObject <MKAnnotation> {
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
	NSString *parishTitle;
	NSNumber *number;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSString *parishTitle;
@property (nonatomic, strong) NSNumber *number;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coords;

@end