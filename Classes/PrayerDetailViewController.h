//
//  PrayerDetailViewController.h
//  Catholic Diocese
//
//  Created by Jeff Geerling on 3/11/12.
//  Copyright (c) 2012 Midwestern Mac, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@class AppDelegate;

@interface PrayerDetailViewController : UIViewController {
    AppDelegate *mainAppDelegate;
	
	IBOutlet UIWebView *prayerView;

	NSURL *prayerViewURL;
}

@property (nonatomic,strong) AppDelegate *mainAppDelegate;
@property (nonatomic,strong) UIWebView *prayerView;
@property (nonatomic,strong) NSURL *prayerViewURL;

@end
