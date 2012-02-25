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

@property (nonatomic,strong) AppDelegate *mainAppDelegate;
@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) NSURL *webViewURL;
@property (nonatomic,strong) UIBarButtonItem *actionButton;
@property (nonatomic,strong) UIBarButtonItem *refreshButton;

- (IBAction)actionButtonSelected:(id)sender;


@end
