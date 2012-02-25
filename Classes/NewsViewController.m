//
//  NewsViewController.m
//  Catholic Diocese
//
//  Created by Jeff Geerling on 1/29/11.
//

#import "NewsViewController.h"
#import "JJGNewsCell.h"
#import "EGOCache.h"
#import "WebViewController.h"
#import "DSActivityView.h"

@implementation NewsViewController


#pragma mark Regular controller methods

- (void)viewDidLoad {
	[super viewDidLoad];
	
	// Start the 'loading' overlay view.
	[DSBezelActivityView activityViewForView:self.view];
	
	// Initialize the articles array - initialize here so viewDidAppear can refresh the news
	articles = [[NSMutableArray alloc] init];
}

- (void)viewDidAppear:(BOOL)animated {
	// Load in the latest news (and refresh every time the view reappears)
	[self performSelectorInBackground:@selector(refreshTheNews) withObject:nil];
}

-(void)refreshTheNews {
    /**
     * Method loads or refreshes the news articles.
     */

	@autoreleasepool {	
        // Start the network activity spinner in the top status bar (see parserDidStartDocument for start).
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		
		// Set up URL and parser
		// @config - Path to XML feed of the latest news.
		NSData *xml = [NSData dataWithContentsOfURL: [NSURL URLWithString:@"http://www.opensourcecatholic.com/sites/opensourcecatholic.com/files/project/resources/latest-news-example.xml"]];
		parser = [[NSXMLParser alloc] initWithData:xml];
		parser.delegate = self;
		[parser parse];
		[tblLatestNews reloadData]; // Need to refresh the table after we fill up the array again.
		[parser setDelegate:nil]; // Resolves a 1024-byte memory leak
	}
}


#pragma mark Table View layout

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    /**
     * Set number of sections in tableview to 1 (explicitly).
     */

	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    /**
     * Set the count of the table's rows here.
     */

	return [articles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /**
     * Customize the appearance of table view cells.
     */

	static NSString *CellIdentifier = @"Cell";
	
	// We also experimented with UITableViewCellStyleValue2, with the date on the left... but decided against it.
	JJGNewsCell *cell = (JJGNewsCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[JJGNewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; // Add disclosure chevron
	}
	
	// Set up the cell
	int storyIndex = [indexPath indexAtPosition: [indexPath length] - 1];
	
	// Node Title
	cell.articleTitle.text = [[articles objectAtIndex: storyIndex] objectForKey: @"articleTitle"];
	
	// Date label
	NSString *publicationDate = [[articles objectAtIndex: storyIndex] objectForKey: @"publicationDate"];
	cell.articlePostDate.text = publicationDate;
	
	// Node Summary
	NSString *nodeSummary = [[articles objectAtIndex: storyIndex] objectForKey:@"articleSummary"];
	NSString *nodeSummaryForDisplay = [nodeSummary stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
	cell.articleSummary.text = nodeSummaryForDisplay;
	
	// Node Image (if exists)
	NSString *nodeImageURL = [[articles objectAtIndex: storyIndex] objectForKey:@"articleImage"];
	[cell setNewsCellPhoto:nodeImageURL];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	/**
     * Navigation logic.
     */
	
	int storyIndex = [indexPath indexAtPosition: [indexPath length] - 1];
	
	NSString * storyLink = [[articles objectAtIndex: storyIndex] objectForKey: @"articleURL"];
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	// Open in Safari.
	// [[UIApplication sharedApplication] openURL:[NSURL URLWithString:storyLink]];
	
	// Open in webview.
	// @todo - Consider using MIT-Licensed JJGWebView.
	WebViewController *webViewController = [[WebViewController alloc] initWithNibName:@"WebView" bundle:nil];
	webViewController.title = [[articles objectAtIndex: storyIndex] objectForKey: @"articleTitle"];
	webViewController.webViewURL = [NSURL URLWithString:storyLink];
	
	[self.navigationController pushViewController:webViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    /**
     * Set cell height.
     */

	return 135;
}


#pragma mark Parser methods

/**
 * RSS feed is in the format:
 *
 * <item>
 *   <title>article title</title>
 *   <pubDate>article date</pubDate>
 *   <summary>article summary</summary>
 *   <link>http://www.example.com</link>
 *   <articleImage>article date</articleImage>
 * </item>
 */

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)err {
	// Stop the 'Loading' overlay view.
	[DSBezelActivityView removeViewAnimated:YES];
	UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Validation Error" 
													  message:err.localizedDescription 
													 delegate:nil 
											cancelButtonTitle:@"OK"
											otherButtonTitles:nil];
	[myAlert show];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)err {
	// Stop the 'Loading' overlay view.
	[DSBezelActivityView removeViewAnimated:YES];
	UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Couldn't Get Latest News"
													  message:@"Either this device is not connected to the Internet, or the latest news could not be retrieved."
													 delegate:nil 
											cancelButtonTitle:@"OK"
											otherButtonTitles:nil];
	[myAlert show];
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
	// Start the network activity spinner in the top status bar (see parserDidEndDocument for stop).
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	[articles removeAllObjects];
}

- (void)parser:(NSXMLParser *)parser 
didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qualifiedName 
    attributes:(NSDictionary *)attributeDict {
	
	currentElement = elementName;
	
	if ([elementName isEqualToString:@"node"]) {
		itemActive = YES;
		currentTitle = [[NSMutableString alloc] init];
		currentLink = [[NSMutableString alloc] init];
		pubDate = [[NSMutableString alloc] init];
		currentSummary = [[NSMutableString alloc] init];
		currentImage = [[NSMutableString alloc] init];
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	
	if (itemActive) {
		NSString *fixedString = [string stringByTrimmingCharactersInSet:
								 [NSCharacterSet whitespaceAndNewlineCharacterSet]];
		
		if ([currentElement isEqualToString:@"title"]) {
			[currentTitle appendString:fixedString];
        }

		if ([currentElement isEqualToString:@"link"]) {
			[currentLink appendString:fixedString];
        }

		if ([currentElement isEqualToString:@"pubDate"]) {
			[pubDate appendString:fixedString];
        }

		if ([currentElement isEqualToString:@"summary"]) {
			[currentSummary appendString:fixedString];
        }

		if ([currentElement isEqualToString:@"articleImage"]) {
			[currentImage appendString:fixedString];
        }
	}
}

- (void)parser:(NSXMLParser *)parser 
 didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName {
	
	if ([elementName isEqualToString:@"node"]) {
		NSDictionary *record = [NSDictionary dictionaryWithObjectsAndKeys:
								currentTitle,@"articleTitle",
								currentLink,@"articleURL",
								pubDate,@"publicationDate",
								currentSummary,@"articleSummary",
								currentImage,@"articleImage",
								nil];
		
		[articles addObject:record];
		
		
		itemActive = NO;
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	// Stop the network activity spinner in the top status bar (see parserDidStartDocument for start).
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	// Stop the 'Loading' overlay view.
	[DSBezelActivityView removeViewAnimated:YES];
}


#pragma mark Respond to UI outlets

- (IBAction)refreshXMLForArchdiocesanFeed:(id)sender {
    /**
     * Respond to touch event to refresh XML.
     */

	// Start the network activity spinner in the top status bar (see parserDidStartDocument for start).
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	[self performSelectorInBackground:@selector(refreshTheNews) withObject:nil];
}


#pragma mark Memory management

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


@end
