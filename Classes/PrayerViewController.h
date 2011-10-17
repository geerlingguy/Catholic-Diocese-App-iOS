//
//  PrayerViewController.h
//  Catholic Diocese
//
//  Created by Jeff Geerling on 2/3/11.
//

#import <UIKit/UIKit.h>


@interface PrayerViewController : UIViewController <NSXMLParserDelegate> {

	IBOutlet UITableView *tblLatestPrayers;
	
	NSXMLParser *prayerParser;
	NSMutableArray *prayers;
	
	NSString *currentPrayer;
	
	NSMutableString *currentName;
	NSMutableString *prayerDate;
	NSMutableString *prayerSummary;
	
	BOOL prayerItemActive;
	
}

- (void)refreshThePrayers;
- (IBAction)refreshXMLForPrayers:(id)sender;
- (IBAction)addPrayerRequestButton:(id)sender;
- (UIFont*)TitleFont;
- (UIFont*)SubFont;
- (UITableViewCell*)CreateMultilinesCell:(NSString*)cellIdentifier;
- (int) heightOfCellWithTitle:(NSString*)titleText andSubtitle:(NSString*)subtitleText;



@end
