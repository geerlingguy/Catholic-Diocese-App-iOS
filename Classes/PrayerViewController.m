//
//  PrayerViewController.m
//  Catholic Diocese
//
//  Created by Jeff Geerling on 2/3/11.
//

#import "PrayerViewController.h"
#import "DSActivityView.h"
#import "AddPrayerViewController.h"


@implementation PrayerViewController

// Constants for use in custom cell heights/display
#define CONST_Cell_height 40.0f
#define CONST_Cell_width 270.0f
#define CONST_textLabelFontSize 14
#define CONST_detailLabelFontSize 14
static UIFont *subFont;
static UIFont *titleFont;


#pragma mark Regular controller methods

// Load in the latest prayers on the first view load.
- (void)viewDidLoad {
	[super viewDidLoad];
	
	// Start the 'loading' overlay view.
	[DSBezelActivityView activityViewForView:self.view];

	// Initialize the prayers array - initialize here so viewDidAppear can refresh the news
	prayers = [[NSMutableArray alloc] init];
}

- (void)viewDidAppear:(BOOL)animated {
	[self performSelectorInBackground:@selector(refreshThePrayers) withObject:nil];
}


#pragma mark Prayer request functionality

// Secondary thread to load in the prayers in the background on view load.
- (void)refreshThePrayers {
	@autoreleasepool {
	
	// Start the network activity spinner in the top status bar.
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		
		// Set up URL and parser
		// @config - URL of prayer data XML (feed).
		NSData *prayerXML = [NSData dataWithContentsOfURL: [NSURL URLWithString:@"http://www.opensourcecatholic.com/sites/opensourcecatholic.com/files/project/resources/latest-prayers-example.xml"]];
		prayerParser = [[NSXMLParser alloc] initWithData:prayerXML];
		prayerParser.delegate = self;
		[prayerParser parse];
		[tblLatestPrayers reloadData]; // Need to refresh the table after we fill up the array again.
		[prayerParser setDelegate:nil]; // Resolves a 1024-byte memory leak
	
	}
}

#pragma mark Table View Cell calculations

/**
 * See: http://iphone-dev-tips.alterplay.com/2009/11/show-multiline-text-cells-in.html
 */
- (UIFont*)TitleFont {
	if (!titleFont) titleFont = [UIFont systemFontOfSize:CONST_textLabelFontSize];
	return titleFont;
}

- (UIFont*)SubFont {
	if (!subFont) subFont = [UIFont systemFontOfSize:CONST_detailLabelFontSize];
	return subFont;
}

- (UITableViewCell*)CreateMultilinesCell:(NSString*)cellIdentifier {
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
													reuseIdentifier:cellIdentifier];
	
	cell.textLabel.numberOfLines = 0;
	cell.textLabel.font = [self TitleFont];
	
	cell.detailTextLabel.numberOfLines = 0;
	cell.detailTextLabel.font = [self SubFont];
	
	return cell;
}

- (int) heightOfCellWithTitle :(NSString*)titleText 
				   andSubtitle:(NSString*)subtitleText
{
	CGSize titleSize = {0, 0};
	CGSize subtitleSize = {0, 0};
	
	if (titleText && ![titleText isEqualToString:@""]) 
		titleSize = [titleText sizeWithFont:[self TitleFont] 
						  constrainedToSize:CGSizeMake(CONST_Cell_width, 4000) 
							  lineBreakMode:UILineBreakModeWordWrap];
	
	if (subtitleText && ![subtitleText isEqualToString:@""]) 
		subtitleSize = [subtitleText sizeWithFont:[self SubFont] 
								constrainedToSize:CGSizeMake(CONST_Cell_width, 4000) 
									lineBreakMode:UILineBreakModeWordWrap];
	
	return titleSize.height + subtitleSize.height;
}

#pragma mark Table View layout

// Set number of sections in tableview to 1 (explicitly).
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [prayers count];
}

// Set the count of the table's rows here.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

// Set the cell header - name
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {    

    NSString *name = [[prayers objectAtIndex: section] objectForKey: @"prayerName"];
	NSString *headerTitle = [NSString stringWithFormat:@"From %@:", name];
	
    return headerTitle;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	
	// We also experimented with UITableViewCellStyleValue2, with the date on the left... but decided against it.
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [self CreateMultilinesCell:CellIdentifier];
		cell.selectionStyle = UITableViewCellSelectionStyleNone; // We don't need people tapping on the requests...
	}
	
	// Set up the cell
	int prayerIndex = [indexPath indexAtPosition:0];
	
	// Set the label (the prayer summary)
	cell.textLabel.text = [[prayers objectAtIndex: prayerIndex] objectForKey: @"prayerSummary"];
	cell.detailTextLabel.text = [[prayers objectAtIndex: prayerIndex] objectForKey: @"prayerDate"];

	return cell;
}

// Set cell height (variable, depends on length of prayer request)
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	int prayerIndex = [indexPath indexAtPosition:0];
	NSString *title = [[prayers objectAtIndex:prayerIndex] objectForKey: @"prayerSummary"];
	NSString *subtitle = [[prayers objectAtIndex: prayerIndex] objectForKey: @"prayerDate"];
	
	int height = 10 + [self heightOfCellWithTitle:title andSubtitle:subtitle];
	return (height < CONST_Cell_height ? CONST_Cell_height : height);
}

#pragma mark Parser methods

/*
 
 XML feed is in the format:
 
 <node>
   <title>prayer title</title>
   <link>http://www.example.com</link>
   <description>prayer summary</description>
   <pubDate>prayer date</pubDate>
 </node>
 
 */

- (void)parser:(NSXMLParser *)prayerParser validationErrorOccurred:(NSError *)err {
	// Stop the 'Loading' overlay view.
	[DSBezelActivityView removeViewAnimated:YES];
	UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Validation Error" 
													  message:err.localizedDescription 
													 delegate:nil 
											cancelButtonTitle:@"OK"
											otherButtonTitles:nil];
	[myAlert show];
}

- (void)parser:(NSXMLParser *)prayerParser parseErrorOccurred:(NSError *)err {
	// Stop the 'Loading' overlay view.
	[DSBezelActivityView removeViewAnimated:YES];
	UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Couldn't Get Prayers"
													  message:@"Either this device is not connected to the Internet, or the latest prayer requests could not be retrieved."
													 delegate:nil 
											cancelButtonTitle:@"OK"
											otherButtonTitles:nil];
	[myAlert show];
}

- (void)parserDidStartDocument:(NSXMLParser *)prayerParser {
	// Start the network activity spinner in the top status bar.
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

	[prayers removeAllObjects];
}

- (void)parser:(NSXMLParser *)parser 
didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qualifiedName 
    attributes:(NSDictionary *)attributeDict {
	
	currentPrayer = elementName;
	
	if ([elementName isEqualToString:@"node"])
	{
		prayerItemActive = YES;
		currentName = [[NSMutableString alloc] init];
		prayerDate = [[NSMutableString alloc] init];
		prayerSummary = [[NSMutableString alloc] init];
	}
}

- (void)parser:(NSXMLParser *)prayerParser foundCharacters:(NSString *)string {
	if (prayerItemActive)
	{
		NSString *fixedString = [string stringByTrimmingCharactersInSet:
								 [NSCharacterSet whitespaceAndNewlineCharacterSet]];
		
		if ([currentPrayer isEqualToString:@"title"])
			[currentName appendString:fixedString];
		
		if ([currentPrayer isEqualToString:@"pubDate"])
			[prayerDate appendString:fixedString];
		
		if ([currentPrayer isEqualToString:@"description"])
			[prayerSummary appendString:fixedString];
	}
}

- (void)parser:(NSXMLParser *)prayerParser 
 didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName {
	if ([elementName isEqualToString:@"node"])
	{
		NSDictionary *record = [NSDictionary dictionaryWithObjectsAndKeys:
								currentName,@"prayerName",
								prayerDate,@"prayerDate",
								prayerSummary,@"prayerSummary",
								nil];
		
		[prayers addObject:record];
		
		
		prayerItemActive = NO;
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)prayerParser {
	// Stop the network activity spinner in the top status bar (see parserDidStartDocument for start).
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

	// Stop the 'Loading' overlay view.
	[DSBezelActivityView removeViewAnimated:YES];
}

#pragma mark Respond to UI outlets

// Respond to touch event to refresh prayer request list.
- (IBAction)refreshXMLForPrayers:(id)sender {
	[self performSelectorInBackground:@selector(refreshThePrayers) withObject:nil];
}

// Respond to touch event to add a new prayer request.
- (IBAction)addPrayerRequestButton:(id)sender {
	
	// Set up parish detail controller, pass parish name and number to it
	AddPrayerViewController *addPrayerView = [[AddPrayerViewController alloc] initWithNibName:@"AddPrayerView" bundle:nil];
	addPrayerView.title = @"Add Prayer Request";
	
	// Push to the parish detail controller
	[self.navigationController pushViewController:addPrayerView animated:YES];
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
