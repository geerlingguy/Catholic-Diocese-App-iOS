//
//  ParishSearchViewController.m
//  Catholic Diocese
//
//  Created by Jeff Geerling on 2/9/11.
//

#import "ParishSearchViewController.h"
#import "Parish.h"
#import "Catholic_DioceseAppDelegate.h"
#import "ParishDetailViewController.h"
#import "ParishMapViewController.h"


@implementation ParishSearchViewController

@synthesize mainAppDelegate, parishListTableView, searchResults, latitude, longitude;


#pragma mark Regular controller methods

- (void)viewDidLoad {
    [super viewDidLoad];
	
	mainAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[[self parishListTableView] reloadData];
}


#pragma mark Configure the Table View & Cells

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    /**
     * Count of rows for tableview.
     */
	NSInteger rows;
	
	if (tableView == [[self searchDisplayController] searchResultsTableView])
		rows = [[self searchResults] count];
	else
		rows = [mainAppDelegate.parishData count];
	
	return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /**
     * Set up the table cells (individually).
     */

	NSInteger row = [indexPath row];
	NSString *parishNameForThisRow = nil;
	
	// Account for search results, for parish name.
	if (tableView == [[self searchDisplayController] searchResultsTableView]) {
		parishNameForThisRow = [[[self searchResults] objectAtIndex:row] objectForKey: @"parishName"];
	} else {
		parishNameForThisRow = [[mainAppDelegate.parishData objectAtIndex:row] objectForKey: @"parishName"];
	}
	
	static NSString *CellIdentifier = @"CellIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; // Add disclosure chevron
	}
	
	cell.textLabel.text = parishNameForThisRow;
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSInteger row = [indexPath row];
	
	// UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
	
	// Set up parish detail controller, pass parish name and number to it
	ParishDetailViewController *parishDetailViewController = [[ParishDetailViewController alloc] initWithNibName:@"ParishDetailView" bundle:nil];
	parishDetailViewController.title = NSLocalizedString(@"PARISH_INFO", nil);
	
	// Account for search results, for parish number.
	if (tableView == [[self searchDisplayController] searchResultsTableView]) {
		parishDetailViewController.parishTitle = [[[self searchResults] objectAtIndex:row] objectForKey: @"parishName"];
		parishDetailViewController.number = [[[self searchResults] objectAtIndex:row] objectForKey: @"parishNumber"];
	} else {
		parishDetailViewController.number = [[mainAppDelegate.parishData objectAtIndex:row] objectForKey: @"parishNumber"];
		parishDetailViewController.parishTitle = [[mainAppDelegate.parishData objectAtIndex:row] objectForKey: @"parishName"];
	}
	
	// Push to the parish detail controller
	[self.navigationController pushViewController:parishDetailViewController animated:YES];
}


#pragma mark Search Handling

- (void)handleSearchForTerm:(NSString *)searchTerm {
	if ([self searchResults] == nil) {
		NSMutableArray *array = [[NSMutableArray alloc] init];
		[self setSearchResults:array];
		array = nil;
	}
	
	[[self searchResults] removeAllObjects];

	// Loop through parish array's dictionaries, getting the parish names and comparing them to current search term
	for (NSDictionary *currentDict in mainAppDelegate.parishData) {
		NSString *currentString = [currentDict objectForKey: @"parishName"];
		if ([currentString rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location != NSNotFound) {
			[[self searchResults] addObject:currentDict];
		}
	}
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
	[self handleSearchForTerm:searchString];
    
	return YES;
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
	[[self parishListTableView] reloadData];
}


#pragma mark Respond to UI outlets

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	// Perform address lookup in background thread
	[self performSelectorInBackground:@selector(getCoordinatesForGivenAddress:) withObject:textField.text];
	
	// Hide the keyboard after textfield is done.
	[textField resignFirstResponder];
	
	// Push user back to the parish map view.
	[self.navigationController popViewControllerAnimated:YES];
	
	return YES;
}

- (void)getCoordinatesForGivenAddress:(NSString *)address {
	// Start network activity spinner.
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	@autoreleasepool {
        // Format entered address in string to pass to Google Maps API, and get back coordinates.
        // @config - Google Maps API for getting address coordinates.
        NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=csv", 
                                   [address	stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSString *locationString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSASCIIStringEncoding error:nil];
            
        // Stop network activity spinner.
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        // Format returned string (CSV) into lat/long measurements.
        NSArray *listItems = [locationString componentsSeparatedByString:@","];
        
        if([listItems count] >= 4 && [[listItems objectAtIndex:0] isEqualToString:@"200"]) {
            latitude = [listItems objectAtIndex:2];
            longitude = [listItems objectAtIndex:3];
            
            // Put latitude and longitude values into array
            NSArray *coordinatesToPush = [[NSArray alloc] initWithObjects:@"noParishHere", latitude, longitude, @"dropPin", @"dontOpenAnnotation", nil];
            
            // Pass the new center coordinates over to the parish map view through NSNotificationCenter.
            NSNotificationCenter *note = [NSNotificationCenter defaultCenter];
            [note postNotificationName:@"ParishMapUpdateEvent" object:coordinatesToPush];
        }
        else {
            //Show error
            UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Couldn't Find Location"
                                                              message:@"Either this device is not connected to the Internet, or the location entered needs to be more precise."
                                                             delegate:nil 
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [myAlert show];	
        }
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

	[self setSearchResults:nil];
}


@end
