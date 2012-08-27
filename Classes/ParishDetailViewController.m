//
//  ParishDetailViewController.m
//  Catholic Diocese
//
//  Created by Jeff Geerling on 2/8/11.
//

#import "ParishDetailViewController.h"
#import "Parish.h"
#import "ParishEvents.h"
#import "Catholic_DioceseAppDelegate.h"
#import "WebViewController.h"
#import "ParishMapViewController.h"


@implementation ParishDetailViewController

@synthesize mainAppDelegate, title, parishTitle, number, pAddress, pCity, pState, pZip, pURL, pLatitude, pLongitude;
@synthesize userLatitude, userLongitude, parishMassTimes, parishReconciliationTimes, parishAdorationTimes;


#pragma mark Regular controller methods

- (void)viewDidLoad {
    [super viewDidLoad];
	
	mainAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	
	// Initialize the location manager, to get user location.
	locationController = [[JJGCLController alloc] init];
	locationController.delegate = self;
	[locationController.locationManager startUpdatingLocation];
	
	// Set up arrays for parish event information.
	parishMassTimes = [[NSMutableArray alloc] init];
	parishReconciliationTimes = [[NSMutableArray alloc] init];
	parishAdorationTimes = [[NSMutableArray alloc] init];
	
	// Get parish event information.
	[self getParishEventTimeInformation];
	
	// Get the parish data in an array.
	[self getParishInformationFromNumber];
}


#pragma mark Get parish information - meta + sacrament times

- (void)getParishInformationFromNumber {
	
	NSPredicate *finder = [NSPredicate predicateWithFormat:@"parishNumber = %@", number];
	NSDictionary *currentParishDictionary = [[mainAppDelegate.parishData filteredArrayUsingPredicate:finder] lastObject];
	
	pAddress = [currentParishDictionary objectForKey:@"parishStreetAddress"];
	pCity = [currentParishDictionary objectForKey:@"parishCity"];
	pState = [currentParishDictionary objectForKey:@"parishState"];
	pZip = [currentParishDictionary objectForKey:@"parishZipCode"];
	pURL = [currentParishDictionary objectForKey:@"parishArchdiocesanURL"];
	pLatitude = [currentParishDictionary objectForKey:@"parishLatitude"];
	pLongitude = [currentParishDictionary objectForKey:@"parishLongitude"];
}

- (void)getParishEventTimeInformation {
	
	// Get parish data from Core Data store.
	NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
	NSError *error;
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription 
								   entityForName:@"ParishEvents" inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
	// @todo - THIS HERE>
	NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"(parishNumber = %@)", number];
	[fetchRequest setPredicate:searchPredicate];
	// @todo - Set up NSPredicate to find only event times for a given parish... based on number
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	for (ParishEvents *info in fetchedObjects) {
		// Set up dictionary to store parish name and parish number inside...
		NSDictionary *record = [NSDictionary dictionaryWithObjectsAndKeys:
								info.parishNumber,@"parishNumber",
								info.eventDay,@"eventDay",
								info.eventStart,@"eventStart",
								info.eventEnd,@"eventEnd",
								info.eventTypeKey,@"eventTypeKey",
								info.eventLocation,@"eventLocation",
								info.eventLanguage,@"eventLanguage",
								nil];
		
		// @todo - use switch statement to put events into specific arrays based on type key.
		switch ([info.eventTypeKey intValue]) {
			case 1: // Mass Times
				[parishMassTimes addObject:record];
				break;
			case 2: // Reconciliation
				[parishReconciliationTimes addObject:record];
				break;
			case 3: // Adoration
				[parishAdorationTimes addObject:record];
				break;
			default:
				break;
		}
	}

	// NSLog(@"Parish mass times array: %@", parishMassTimes);
	// NSLog(@"Parish reconciliation times array: %@", parishReconciliationTimes);
	// NSLog(@"Parish adoration times array: %@", parishAdorationTimes);
}


#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // There are four sections, for address, mass times, show on map, and more
    // information, in that order.
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// The number of rows varies by section.
    NSInteger rows = 0;
    switch (section) {
        case 0: // address
			rows = 1;
			break;
        case 1: // mass times
            rows = [parishMassTimes count];
            break;
		case 2: // reconciliation times
			rows = [parishReconciliationTimes count];
			break;
		case 3: // adoration times
			rows = [parishAdorationTimes count];
			break;
        case 4: // show parish on map
            rows = 1;
            break;
		case 5: // more information
			rows = 1;
			break;
        default:
            break;
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    // Set the text in the cell for the section/row.
    NSString *cellText = nil;
	NSString *detailCellText = nil;
	
	// Set up some variables.
	NSString *nonEnglishLanguage = nil;
	NSString *nonEmptyLocation = nil;
	
    switch (indexPath.section) {
		case 0:
            cellText = [NSString stringWithFormat:@"%@\n%@, %@ %@", pAddress, pCity, pState, pZip];
			cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
			cell.textLabel.numberOfLines = 2;
			cell.selectionStyle = UITableViewCellSelectionStyleBlue;
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 1:
		{
			// Get mass times, using indexPath to grab proper value.
			NSString *day = [[parishMassTimes objectAtIndex:[indexPath row]] objectForKey: @"eventDay"];
			NSString *startTime = [[parishMassTimes objectAtIndex:[indexPath row]] objectForKey: @"eventStart"];
			cellText = [NSString stringWithFormat:@"%@ - %@", day, startTime];
			
			// Get the language, check to see if it's English.
			NSString *language = [[parishMassTimes objectAtIndex:[indexPath row]] objectForKey: @"eventLanguage"];
			if ([language rangeOfString:@"English"].location == NSNotFound) {
				nonEnglishLanguage = language;
			}
			
			// Get the location, check to see if it's an empty string.
			NSString *location = [[parishMassTimes objectAtIndex:[indexPath row]] objectForKey: @"eventLocation"];
			if ([location length] !=0) {
				nonEmptyLocation = location;
			}
			
			NSArray *detailLabelInfo = [NSArray arrayWithObjects:nonEnglishLanguage, nonEmptyLocation, nil];
			detailCellText = [detailLabelInfo componentsJoinedByString:@" - "];
			
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.accessoryType = UITableViewCellAccessoryNone;
            break;
		}
		case 2:
		{
			// Get reconciliation times, using indexPath to grab proper value.
			NSString *day = [[parishReconciliationTimes objectAtIndex:[indexPath row]] objectForKey: @"eventDay"];
			NSString *startTime = [[parishReconciliationTimes objectAtIndex:[indexPath row]] objectForKey: @"eventStart"];
			NSString *endTime = [[parishReconciliationTimes objectAtIndex:[indexPath row]] objectForKey: @"eventEnd"];
			cellText = [NSString stringWithFormat:@"%@ %@ - %@", day, startTime, endTime];
			
			// Get the language, check to see if it's English.
			NSString *language = [[parishReconciliationTimes objectAtIndex:[indexPath row]] objectForKey: @"eventLanguage"];
			if ([language rangeOfString:@"English"].location == NSNotFound) {
				nonEnglishLanguage = language;
			}
			
			// Get the location, check to see if it's an empty string.
			NSString *location = [[parishReconciliationTimes objectAtIndex:[indexPath row]] objectForKey: @"eventLocation"];
			if ([location length] !=0) {
				nonEmptyLocation = location;
			}
			
			NSArray *detailLabelInfo = [NSArray arrayWithObjects:nonEnglishLanguage, nonEmptyLocation, nil];
			detailCellText = [detailLabelInfo componentsJoinedByString:@" - "];
			
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.accessoryType = UITableViewCellAccessoryNone;
			break;
		}
		case 3:
		{
			// Get adoration times, using indexPath to grab proper value.
			NSString *day = [[parishAdorationTimes objectAtIndex:[indexPath row]] objectForKey: @"eventDay"];
			NSString *startTime = [[parishAdorationTimes objectAtIndex:[indexPath row]] objectForKey: @"eventStart"];
			if ([startTime length] == 0) {
				// If the value is empty, it should be midnight / 12:00 a.m.
				startTime = @"12:00 am";
			}
			NSString *endTime = [[parishAdorationTimes objectAtIndex:[indexPath row]] objectForKey: @"eventEnd"];
			cellText = [NSString stringWithFormat:@"%@ %@ - %@", day, startTime, endTime];
			
			// Get the language, check to see if it's English.
			NSString *language = [[parishAdorationTimes objectAtIndex:[indexPath row]] objectForKey: @"eventLanguage"];
			if ([language rangeOfString:@"English"].location == NSNotFound) {
				nonEnglishLanguage = language;
			}
			
			// Get the location, check to see if it's an empty string.
			NSString *location = [[parishAdorationTimes objectAtIndex:[indexPath row]] objectForKey: @"eventLocation"];
			if ([location length] !=0) {
				nonEmptyLocation = location;
			}
			
			NSArray *detailLabelInfo = [NSArray arrayWithObjects:nonEnglishLanguage, nonEmptyLocation, nil];
			detailCellText = [detailLabelInfo componentsJoinedByString:@" - "];
			
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.accessoryType = UITableViewCellAccessoryNone;
			break;
		}
		case 4:
			cellText = NSLocalizedString(@"SHOW_ON_MAP", nil);
			cell.selectionStyle = UITableViewCellSelectionStyleBlue;
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			break;
        case 5:
            cellText = NSLocalizedString(@"MORE_INFO", nil);
			cell.selectionStyle = UITableViewCellSelectionStyleBlue;
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        default:
            break;
    }

    cell.textLabel.text = cellText;
	cell.detailTextLabel.text = detailCellText;
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch ([indexPath section]) {
		case 0: // Address
			return 60;
		case 1: // Mass Times
		case 2: // Reconciliation Times
		case 3: // Adoration Times
			return 44;
		default:
			return 40;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    /**
     * Handle taps of certain table rows.
     */

	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	// Get route from Maps app - userLocation to the parish address/coordinates.
	if ([indexPath indexAtPosition:0] == 0) {
		
		// Set up start location (defaults to Rigali Center)
		CLLocationCoordinate2D start;
		start.latitude = (CLLocationDegrees)[userLatitude doubleValue];
		start.longitude = (CLLocationDegrees)[userLongitude doubleValue];
		
		CLLocationCoordinate2D destination;
		destination.latitude = (CLLocationDegrees)[pLatitude doubleValue];
		destination.longitude = (CLLocationDegrees)[pLongitude doubleValue];
		
		// @config - Google Maps URL.
		NSString *googleMapsURLString = [NSString stringWithFormat:@"http://maps.google.com/?saddr=%1.6f,%1.6f&daddr=%1.6f,%1.6f",
										 start.latitude, start.longitude, destination.latitude, destination.longitude];
		
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:googleMapsURLString]];
	}
	
	// Show parish location on parish map (in root view (parishMap MKMapView))
	if ([indexPath indexAtPosition:0] == 4) {
		
		// Push user back to the parish map view (we'll do everything else during animation).
		[self.navigationController popToRootViewControllerAnimated:YES];
		
		@autoreleasepool {
		
		// Put current parish's latitude and longitude values into array
			NSArray *coordinatesToPush = [[NSArray alloc] initWithObjects:parishTitle, pLatitude, pLongitude, @"dontDropPin", @"openAnnotation", nil];
			
			// Pass the new center coordinates over to the parish map view through NSNotificationCenter.
			NSNotificationCenter *note = [NSNotificationCenter defaultCenter];
			[note postNotificationName:@"ParishMapUpdateEvent" object:coordinatesToPush];
		
		}
	}
	
	// Open parish page on archstl.org if user taps 'More Information' button (currently at index path/section 2).
	if ([indexPath indexAtPosition:0] == 5) {
		// Open link in webview
		// @todo - Consider using MIT-Licensed JJGWebView.
		WebViewController *parishWebViewController = [[WebViewController alloc] initWithNibName:@"WebView" bundle:nil];
		parishWebViewController.title = parishTitle;		
		parishWebViewController.webViewURL = [NSURL URLWithString:pURL];
		[self.navigationController pushViewController:parishWebViewController animated:YES];
	}
}


#pragma mark Section header titles

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	// If you return nil for a section, the titleForHeaderInSection value will be used instead
	switch (section) {
        case 0: {
			UILabel* parishNameHeader = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 40)];
			parishNameHeader.text = parishTitle; // Passed from map view
			parishNameHeader.textAlignment = UITextAlignmentCenter;
			if ([parishTitle length] < 30) {
				parishNameHeader.font = [UIFont boldSystemFontOfSize:20.0];
			} else {
				// Prevent long titles from getting cut off by reducing their font size.
				parishNameHeader.font = [UIFont boldSystemFontOfSize:16.0];
			}
			parishNameHeader.opaque = YES;
			parishNameHeader.textColor = [UIColor blackColor];
			parishNameHeader.backgroundColor = [UIColor clearColor];
			parishNameHeader.shadowColor = [UIColor whiteColor];
			parishNameHeader.shadowOffset = CGSizeMake(0,1);
			return parishNameHeader;
		}
        case 1:
        case 2:
        case 3:
		case 4:
		case 5:
        default:
            return nil;
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {    
    NSString *headerTitle = nil;
    switch (section) {
        case 0:
            headerTitle = NSLocalizedString(@"ADDRESS", nil); // But view used instead (@see viewForHeaderInSection).
            break;
        case 1:
            headerTitle = NSLocalizedString(@"MASS_TIMES", nil);
            break;
		case 2:
			headerTitle = NSLocalizedString(@"RECONCILIATION_TIMES", nil);
			break;
		case 3:
			headerTitle = NSLocalizedString(@"ADORATION_TIMES", nil);
			break;
        case 4:
		case 5:
            headerTitle = nil;
            break;
        default:
            break;
    }
    return headerTitle;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return 60;
	}
	return 31;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	NSString *footerTitle = nil;
    switch (section) {
        case 0:
            footerTitle = NSLocalizedString(@"TAP_FOR_DIRECTIONS", nil);
            break;
        case 1: // Mass times
		case 2: // Reconciliation times
			footerTitle = nil;
			break;
		case 3: // Adoration times
			footerTitle = NSLocalizedString(@"INCORRECT_TIMES_NOTICE", nil);
			break;
        case 4:
		case 5:
        default:
			footerTitle = nil;
            break;
    }
    return footerTitle;
}


#pragma mark Custom Location Manager methods

- (void)locationUpdate:(CLLocation *)location {
	userLatitude = [NSNumber numberWithDouble:location.coordinate.latitude];
	userLongitude = [NSNumber numberWithDouble:location.coordinate.longitude];
	
	// After user location found, stop the location manager
	// Note: We don't need any specific accuracy here, because CLLocationManager already has a pretty good
	// idea as to where the user is located, because the iPhone's already narrowed it down in the parishMap
	[locationController.locationManager stopUpdatingLocation];
}

- (void)locationError:(NSError *)error {
	// NSLog(@"%@", [error description]);
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
