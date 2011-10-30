//
//  JJGNewsCell.h
//  Catholic Diocese
//
//  Created by Jeff Geerling on 2/14/11.
//

#import <UIKit/UIKit.h>

@class EGOImageView;
@interface JJGNewsCell : UITableViewCell {

	IBOutlet UILabel *articleTitle;
	IBOutlet UILabel *articleSummary;
	IBOutlet UILabel *articlePostDate;
	IBOutlet UIImageView *articleImage;
	
@private
	EGOImageView* imageView;
	
}

@property (nonatomic,strong) IBOutlet UILabel *articleTitle;
@property (nonatomic,strong) IBOutlet UILabel *articleSummary;
@property (nonatomic,strong) IBOutlet UILabel *articlePostDate;
@property (nonatomic,strong) IBOutlet UIImageView *articleImage;

- (void)setNewsCellPhoto:(NSString*)articleImage;

@end
