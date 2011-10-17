//
//  AddPrayerViewController.h
//  Catholic Diocese
//
//  Created by Jeff Geerling on 2/17/11.
//

#import <UIKit/UIKit.h>


@interface AddPrayerViewController : UIViewController <UIWebViewDelegate> {

	IBOutlet UIWebView *addPrayerWebView;
	
}

@property (nonatomic,retain) UIWebView *addPrayerWebView;

@end
