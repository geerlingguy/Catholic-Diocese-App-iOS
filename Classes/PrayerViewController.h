//
//  PrayerViewController.h
//  Catholic Diocese
//
//  Created by Jeff Geerling on 2/3/11.
//

#import <UIKit/UIKit.h>


@interface PrayerViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	IBOutlet UITableView *tblPrayers;
	NSMutableArray *prayers;
}


@end
