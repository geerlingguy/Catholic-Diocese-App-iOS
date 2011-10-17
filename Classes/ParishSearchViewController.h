//
//  ParishSearchViewController.h
//  Catholic Diocese
//
//  Created by Jeff Geerling on 2/9/11.
//

#import <UIKit/UIKit.h>

@class AppDelegate;

@interface ParishSearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UISearchDisplayDelegate, UISearchBarDelegate> {
	AppDelegate *mainAppDelegate;
	
	UITableView *parishListTableView;

	NSMutableArray *searchResults;
	NSString *latitude;
	NSString *longitude;
}

@property (nonatomic, retain) AppDelegate *mainAppDelegate;
@property (nonatomic, retain) IBOutlet UITableView *parishListTableView;
@property (nonatomic, retain) NSMutableArray *searchResults;
@property (nonatomic, retain) NSString *latitude;
@property (nonatomic, retain) NSString *longitude;

- (void)getCoordinatesForGivenAddress:(NSString *)address;
- (void)handleSearchForTerm:(NSString *)searchTerm;

@end
