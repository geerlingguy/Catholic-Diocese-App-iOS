//
//  PrayerViewController.m
//  Catholic Diocese
//
//  Created by Jeff Geerling on 2/3/11.
//

#import "PrayerViewController.h"
#import "PrayerDetailViewController.h"


@implementation PrayerViewController

#pragma mark Regular controller methods

- (void)viewDidLoad {
	[super viewDidLoad];

    // Build an array of the prayer names.
    prayers = [NSArray arrayWithObjects:
               @"Our Father",
               @"Hail Mary",
               @"Glory Be", nil];

    // Build an array of the prayer file names (without .html).
    prayersFiles = [NSArray arrayWithObjects:
                    @"our-father",
                    @"hail-mary",
                    @"glory-be", nil];

    // Set the title of the navigation bar.
    self.navigationItem.title = @"Prayers";
}


#pragma mark Table View layout

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [prayers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /**
     * Customize the appearance of table view cells.
     */

	static NSString *CellIdentifier = @"Cell";

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}

    // Set up the cell.
    NSString *cellValue = [prayers objectAtIndex:indexPath.row];
    cell.textLabel.text = cellValue;

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    /**
     * Detect which row has been selected, and open the prayer.
     */

    PrayerDetailViewController *prayerViewController = [[PrayerDetailViewController alloc] initWithNibName:@"PrayerDetailView" bundle:[NSBundle mainBundle]];
    prayerViewController.title = [prayers objectAtIndex:indexPath.row];
	prayerViewController.prayerViewURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:[prayersFiles objectAtIndex:indexPath.row] ofType:@"html" inDirectory:@"prayers"]];
    [self.navigationController pushViewController:prayerViewController animated:YES];

    // Deselect the selected row.
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; 
}


#pragma mark Cleanup functions

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
