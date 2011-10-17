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

@property (nonatomic, retain) AppDelegate *mainAppDelegate;
@property (nonatomic, retain) NSNumber *zoomToUserLocation;
@property (nonatomic, retain) IBOutlet MKMapView *parishMap;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControlMapType;

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
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subtitle;
@property (nonatomic, retain) NSString *parishTitle;
@property (nonatomic, retain) NSNumber *number;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coords;

@end