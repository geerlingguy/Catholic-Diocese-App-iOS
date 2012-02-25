//
//  AddPrayerViewController.m
//  Catholic Diocese
//
//  Created by Jeff Geerling on 2/17/11.
//

#import "AddPrayerViewController.h"
#import "DSActivityView.h"


@implementation AddPrayerViewController

@synthesize addPrayerWebView;

- (void)viewDidLoad {
    /**
     * Implement viewDidLoad to do additional setup after loading the view,
     * typically from a nib.
     */

    [super viewDidLoad];

	// @config - URL on your website for adding prayer requests.
	NSString *urlAddress = @"http://www.example.org/add-prayer-request";
	NSURL *url = [NSURL URLWithString:urlAddress];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	
	// Load URL in UIWebView
	[addPrayerWebView loadRequest:requestObj];
}

- (void)webViewDidStartLoad:(UIWebView *)addPrayerWebView {
	// Start the network activity spinner in the top status bar.
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	// Start the 'loading' overlay view.
	[DSBezelActivityView activityViewForView:self.view];
}

- (void)webViewDidFinishLoad:(UIWebView *)addPrayerWebView {
	// Stop the network activity spinner in the top status bar.
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	// Stop the 'Loading' overlay view.
	[DSBezelActivityView removeViewAnimated:YES];
}

- (void)webView:(UIWebView *)wv didFailLoadWithError:(NSError *)error {
	// Stop the 'Loading' overlay view.
	[DSBezelActivityView removeViewAnimated:YES];
    if (error != NULL) {
        UIAlertView *errorAlert = [[UIAlertView alloc]
								   initWithTitle:@"Error Loading Web Page"
								   message: [error localizedFailureReason]
								   delegate:nil
								   cancelButtonTitle:@"OK"
								   otherButtonTitles:nil];
        [errorAlert show];
    }
}

#pragma mark Cleanup methods

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
