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

@property (nonatomic, strong) AppDelegate *mainAppDelegate;
@property (nonatomic, strong) IBOutlet UITableView *parishListTableView;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;

- (void)getCoordinatesForGivenAddress:(NSString *)address;
- (void)handleSearchForTerm:(NSString *)searchTerm;


@end
