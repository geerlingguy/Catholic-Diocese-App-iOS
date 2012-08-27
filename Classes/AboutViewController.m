//
//  AboutViewController.m
//  Catholic Diocese
//
//  Created by Jeff Geerling on 2/23/11.
//

#import "AboutViewController.h"


@implementation AboutViewController


#pragma mark Regular controller methods

- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark Respond to UI outlets

- (IBAction)openPrivacyPolicy:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:NSLocalizedString(@"PRIVACY_POLICY_URL", nil)]];
}

- (IBAction)openMobileAppAboutPage:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:NSLocalizedString(@"MOBILE_APP_URL", nil)]];
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
