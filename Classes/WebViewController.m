//
//  WebViewController.m
//  Catholic Diocese
//
//  Created by Jeff Geerling on 2/11/11.
//

#import "WebViewController.h"
#import "Catholic_DioceseAppDelegate.h"


@implementation WebViewController

@synthesize mainAppDelegate, webView, webViewURL, actionButton, refreshButton;


#pragma mark Regular controller methods

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Set the app delegate
	mainAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	// Access the articles array like so: mainAppDelegate.articles
	
	// For testing:
	//	NSString *urlAddress = @"http://www.example.org/";
	//	NSURL *url = [NSURL URLWithString:urlAddress];
	//	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	
	// webViewURL gets passed in from other views - form URL request with it
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:webViewURL];

	// Load URL in UIWebView
	[webView loadRequest:requestObj];
}


#pragma mark Web View methods

- (void)webViewDidStartLoad:(UIWebView *)webView {
	[activityIndicator startAnimating];
	
	// Disable Action bar button item...
	self.actionButton.enabled = NO;
	self.refreshButton.enabled = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[activityIndicator stopAnimating];
	
	// Enable Action bar button item...
	self.actionButton.enabled = YES;
	self.refreshButton.enabled = YES;
}

- (void)webView:(UIWebView *)wv didFailLoadWithError:(NSError *)error {
	[activityIndicator stopAnimating];
	
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


#pragma mark IBAction outlets

- (IBAction)actionButtonSelected:(id)sender {
	actionButtonActionSheet = [[UIActionSheet alloc] initWithTitle:nil  
														  delegate:self  
												 cancelButtonTitle:@"Cancel"  
											destructiveButtonTitle:nil 
												 otherButtonTitles:NSLocalizedString(@"OPEN_IN_BROWSER", nil),
																   NSLocalizedString(@"EMAIL_LINK", @""), nil];
	[actionButtonActionSheet showFromBarButtonItem:sender animated:YES];
	[actionButtonActionSheet showInView:mainAppDelegate.window];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (actionSheet == actionButtonActionSheet) {
		NSURL *currentURL = [[webView request] URL];
		
		switch (buttonIndex) {
			case 0: // Open in Browser
				[[UIApplication sharedApplication] openURL:currentURL];
				break;
				
			case 1: { // Email Link...
                // @config - Email subject line.
				NSString *mailtoString = [[NSString alloc] initWithFormat:@"mailto:?subject=Link%%20from%%20Diocese%%20App&body=%@", [currentURL absoluteString]];
				NSURL *mailtoURL = [[NSURL alloc] initWithString:mailtoString];
				[[UIApplication sharedApplication] openURL:mailtoURL];
				break;
			}
				
			default:
				break;
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
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


@end
