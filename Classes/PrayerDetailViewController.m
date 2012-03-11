//
//  PrayerDetailViewController.m
//  Catholic Diocese
//
//  Created by Jeff Geerling on 3/11/12.
//  Copyright (c) 2012 Midwestern Mac, LLC. All rights reserved.
//

#import "PrayerDetailViewController.h"
#import "Catholic_DioceseAppDelegate.h"


@implementation PrayerDetailViewController

@synthesize mainAppDelegate, prayerView, prayerViewURL;


#pragma mark Regular controller methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

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
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:prayerViewURL];
    
	// Load URL in UIWebView
	[prayerView loadRequest:requestObj];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
