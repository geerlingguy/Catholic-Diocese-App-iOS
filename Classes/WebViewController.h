//
//  WebViewController.h
//  Catholic Diocese
//
//  Created by Jeff Geerling on 2/11/11.
//

#import <UIKit/UIKit.h>

@class AppDelegate;

@interface WebViewController : UIViewController <UITextFieldDelegate, UIWebViewDelegate, UIActionSheetDelegate> {

	AppDelegate *mainAppDelegate;
	
	IBOutlet UIWebView *webView;
	IBOutlet UIActivityIndicatorView *activityIndicator;
	IBOutlet UIBarButtonItem *actionButton;
	IBOutlet UIBarButtonItem *refreshButton;

	UIActionSheet *actionButtonActionSheet;
	
	NSURL *webViewURL;
	
}

@property (nonatomic,retain) AppDelegate *mainAppDelegate;
@property (nonatomic,retain) UIWebView *webView;
@property (nonatomic,retain) NSURL *webViewURL;
@property (nonatomic,retain) UIBarButtonItem *actionButton;
@property (nonatomic,retain) UIBarButtonItem *refreshButton;

- (IBAction)actionButtonSelected:(id)sender;

@end
