//
//  ParishMapViewController.m
//  Catholic Diocese
//
//  Created by Jeff Geerling on 2/3/11.
//

#import "ParishMapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "Parish.h"
#import "Catholic_DioceseAppDelegate.h"
#import "ParishSearchViewController.h"
#import "ParishDetailViewController.h"


@implementation parishAnnotation

@synthesize coordinate, title, subtitle, parishTitle, number;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coords {
    
    if (self = [super init])
		coordinate = coords;
    
    return self;
}


@end


@implementation ParishMapViewController

@synthesize mainAppDelegate, parishMap, segmentedControlMapType, zoomToUserLocation;


#pragma mark Regular controller methods

- (void)viewDidLoad {
    /**
     * Implement viewDidLoad to do additional setup after loading the view,
     * typically from a nib.
     */
    [super viewDidLoad];
	
	mainAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	
	// Set the initial map display for the St. Louis, MO metro area.
	// @config - Initial map display location coordinates.
	CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(38.631355,-90.396881);
	// @config - Map's initial zoom level.
	float zoomLevel = 0.5;
	MKCoordinateRegion region = MKCoordinateRegionMake(coords, MKCoordinateSpanMake(zoomLevel, zoomLevel));
	[parishMap setRegion:[parishMap regionThatFits:region] animated:YES];
	
	// Add in pins for all the parishes
	[self performSelectorInBackground:@selector(createAnnotationsOfParishes) withObject:nil];
	
	// Subscribe to parish map update events in the notification center (for re-centering map).
	NSNotificationCenter *note = [NSNotificationCenter defaultCenter];
	[note addObserver:self selector:@selector(updateParishMapCenter:) name:@"ParishMapUpdateEvent" object:nil];
	
	zoomToUserLocation = [NSNumber numberWithBool:YES];
}


#pragma mark Notification method to update map center

- (void)updateParishMapCenter:(NSNotification *)note {
    /**
     * Update parish map to new coordinates / range if we have a new parish map
     * update event.
     *
	 * Array index key:
	 *
	 *   0 = parish name (NSString)
	 *   1 = latitude (NSString)
	 *   2 = longitude (NSString)
	 *   3 = whether to drop pin (NSString)
	 *   4 = whether to open the annotation at a given point (NSString)
	 */
	
	id newCoordinates = [note object];
	
	// Set up map region and span.
	MKCoordinateRegion region;
	MKCoordinateSpan span;
	
	span.latitudeDelta=0.04;
	span.longitudeDelta=0.04;
	
	CLLocationCoordinate2D location = CLLocationCoordinate2DMake([[newCoordinates objectAtIndex:1] doubleValue], [[newCoordinates objectAtIndex:2] doubleValue]);
	
	region.span=span;
	region.center=location;
	
	// Re-center map on new location.
	[parishMap setRegion:region animated:TRUE];
	[parishMap regionThatFits:region];

	// Setup and add annotation for this dropped pin (if fourth item in array
    // says "dropPin").
	if ([newCoordinates objectAtIndex:3] == @"dropPin") {
		// Clear out previous user-entered dropped pin (so map doesn't get
        // cluttered).
        NSString *droppedPin = NSLocalizedString(@"DROPPED_PIN", nil);
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@", droppedPin];
		[parishMap removeAnnotations:[parishMap.annotations filteredArrayUsingPredicate:predicate]];
		
		parishAnnotation *userAddedAnnotation = [[parishAnnotation alloc] initWithCoordinate:location];
		userAddedAnnotation.title = droppedPin;
		userAddedAnnotation.subtitle = NSLocalizedString(@"ENTERED_LOCATION", nil);
		userAddedAnnotation.parishTitle = nil;
		userAddedAnnotation.number = nil;
		[parishMap addAnnotation:userAddedAnnotation]; // Just add one at a time.
		[parishMap selectAnnotation:userAddedAnnotation animated:YES]; // Select the annotation.
	}
	
	// Open the annotation view for the given location (if the last item in the
    // array says "openAnnotation").
	if ([newCoordinates objectAtIndex:4] == @"openAnnotation") {
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@", [newCoordinates objectAtIndex:0]];
		for (id myAnnotation in [parishMap.annotations filteredArrayUsingPredicate:predicate]) {
			[parishMap selectAnnotation:myAnnotation animated:YES];
		}
	}
}


#pragma mark Parish annotation creation

- (void)createAnnotationWithCoords:(CLLocationCoordinate2D)coords
						  andTitle:(NSString *)title
					   andSubtitle:(NSString *)subtitle
						 andNumber:(NSNumber *)number {
    /**
     * Function to create an annotation.
     */

    parishAnnotation *annotation = [[parishAnnotation alloc] initWithCoordinate:coords];
    annotation.title = title;
    annotation.subtitle = subtitle;
	annotation.parishTitle = title;
	annotation.number = number;
    [parishMap addAnnotation:annotation]; // Just add one at a time.
}

- (void)createAnnotationsOfParishes {
    /**
     * Function to create an annotation for each parish.
     */

	@autoreleasepool {
        // Set up variables for adding map annotations (later)
		CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(0,0);
		NSString *pName = NSLocalizedString(@"PARISH_NAME", nil);
		NSString *pSubtitle = NSLocalizedString(@"PARISH_DESCRIPTION", nil);
		NSNumber *pNumber = 0;
		
		for (NSMutableDictionary *currentParishDictionary in mainAppDelegate.parishData) {
			coords = CLLocationCoordinate2DMake((CLLocationDegrees)[[currentParishDictionary objectForKey: @"parishLatitude"] doubleValue],(CLLocationDegrees)[[currentParishDictionary objectForKey: @"parishLongitude"] doubleValue]);
			pName = [currentParishDictionary objectForKey: @"parishName"];
			pSubtitle = [currentParishDictionary objectForKey: @"parishStreetAddress"];
			pNumber = [currentParishDictionary objectForKey:@"parishNumber"]; // Used as a reference point for other parish data.
			
			[self createAnnotationWithCoords:coords andTitle:pName andSubtitle:pSubtitle andNumber:pNumber];
		}
	}
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
	// If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
	
	NSString *identifier = @"number"; // We identify the type of annotation by number...
	
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[parishMap dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (pinView == nil)
		pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotation.title];
    else
		pinView.annotation = annotation;
	
	// @see - http://www.iphonedevsdk.com/forum/iphone-sdk-development/64418-how-display-annotations-different-pin-colors.html#post265340
	NSNumber* thisParishNumber = ((parishAnnotation*)annotation).number;
	
	if (thisParishNumber == nil) {
		// If there's no parish number, this is a user-added annotation.
		pinView.animatesDrop = YES;
		// @config - Color of pin for parish map.
		pinView.pinColor = MKPinAnnotationColorGreen;
	}
    else {
		// If there's a parish number, this is a parish annotation.
		pinView.animatesDrop = NO; // For parishes - But it's fun to watch 200+ pins dropping :-)
		pinView.rightCalloutAccessoryView=[UIButton buttonWithType:UIButtonTypeDetailDisclosure]; // Show detail disclosure button (blue arrow)
	}
	
	pinView.canShowCallout = YES;
    
    return pinView;
}

- (void)mapView:(MKMapView *)parishMap annotationView:(MKAnnotationView *)pinView calloutAccessoryControlTapped:(UIControl *)control {
	parishAnnotation* annotation;
	annotation = (parishAnnotation *) pinView.annotation;
	ParishDetailViewController *parishDetailViewController = [[ParishDetailViewController alloc] initWithNibName:@"ParishDetailView" bundle:nil];
	parishDetailViewController.title = NSLocalizedString(@"PARISH_INFO", nil);
	parishDetailViewController.parishTitle = annotation.parishTitle;
	parishDetailViewController.number = annotation.number;
	
	[self.navigationController pushViewController:parishDetailViewController animated:YES];
}


#pragma mark User location interactions

//- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
//  /**
//   * Center map on user location (initially). This method works fine in iOS
//   * 4.3, and seems more elegant, but doesn't work with 4.2.x. See for more
//   * info: http://archstldev.com/node/845
//   */
//
//    for (MKAnnotationView *annotationView in views) {
//        if(annotationView.annotation == parishMap.userLocation) {
//            MKCoordinateRegion region;
//            MKCoordinateSpan span;
//			
//            span.latitudeDelta=0.03;
//            span.longitudeDelta=0.03;
//			
//            CLLocationCoordinate2D location=parishMap.userLocation.coordinate;
//			
//            location = parishMap.userLocation.location.coordinate;
//			
//            region.span=span;
//            region.center=location;
//			
//            [parishMap setRegion:region animated:TRUE];
//        }
//    }
//}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    /**
     * Center map on user location (initially).
     */

	MKCoordinateRegion region;
	
	if (zoomToUserLocation) {
        // @config - Initial zoom after user location found.
		region.span.latitudeDelta = 0.03;
		region.span.longitudeDelta = 0.03;
		region.center = userLocation.coordinate;

		// For debug / simulator:
		// CLLocationCoordinate2D usercoords = CLLocationCoordinate2DMake(38.579428,-90.335843);
		// region.center = usercoords;

		// Check if user's latitude and longitude are within the St. Louis region.
		// @config - Map will only zoom if userLoction within this range.
		if (userLocation.coordinate.latitude < 39.300 && userLocation.coordinate.latitude > 37.833 &&
			userLocation.coordinate.longitude < -89.567 && userLocation.coordinate.longitude > -91.333) {
			[parishMap setRegion:region animated:YES];
		}

        //changed from NO to 0 b/c of an ARC compatibility issue
		zoomToUserLocation = 0; 
	}
}


#pragma mark Interface Elements

- (IBAction)btnSearch:(id)sender {
    /**
     * Respond to search button test event.
     */

	ParishSearchViewController *parishSearchViewController = [[ParishSearchViewController alloc] initWithNibName:@"ParishSearchView" bundle:nil];
	parishSearchViewController.title = NSLocalizedString(@"PARISH_SEARCH", nil);
	
	[self.navigationController pushViewController:parishSearchViewController animated:YES];
}

- (IBAction)btnLocateMe:(id)sender {
    /**
     * Respond to locate me button.
     */

	if (parishMap.userLocation.location != nil) { // Check to see if there's a value for user location
		MKCoordinateRegion region;
		MKCoordinateSpan span;
		
		span.latitudeDelta=0.03;
		span.longitudeDelta=0.03;
		
		CLLocationCoordinate2D location=parishMap.userLocation.coordinate;
		
		location = parishMap.userLocation.location.coordinate;
		
		region.span=span;
		region.center=location;
		
		[parishMap setRegion:region animated:TRUE];
		[parishMap regionThatFits:region];
	}
    else { // If there's no user location, just show an alert.
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Location Found"
														 message:@"We can't find your location on the map. Please try to connect to the Internet or find better GPS coverage, and try again."
														delegate:self cancelButtonTitle:@"OK"
											   otherButtonTitles:nil];
		[alert show];
	}
}

- (IBAction)changeMapType: (id)sender{
    /**
     * Respond to Map View Type Segmented Controller.
     */

	if(segmentedControlMapType.selectedSegmentIndex == 0){
		parishMap.mapType = MKMapTypeStandard;
	}
	else if(segmentedControlMapType.selectedSegmentIndex == 1){
		parishMap.mapType = MKMapTypeSatellite;
	}
	else if(segmentedControlMapType.selectedSegmentIndex == 2){
		parishMap.mapType = MKMapTypeHybrid;
	}
	
}


#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


@end
