//
//  NewsViewController.h
//  Catholic Diocese
//
//  Created by Jeff Geerling on 1/29/11.
//

#import <UIKit/UIKit.h>


@interface NewsViewController : UIViewController <NSXMLParserDelegate> {

	IBOutlet UITableView *tblLatestNews;

	NSXMLParser *parser;
	NSMutableArray *articles;
	
	NSString *currentElement;
	
	NSMutableString *currentTitle;
	NSMutableString *currentLink;
	NSMutableString *pubDate;
	NSMutableString *currentSummary;
	NSMutableString *currentImage;
	
	BOOL itemActive;
}

- (IBAction)refreshXMLForArchdiocesanFeed:(id)sender;
-(void)refreshTheNews;


@end
