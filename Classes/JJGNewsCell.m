//
//  JJGNewsCell.m
//  Catholic Diocese
//
//  Created by Jeff Geerling on 2/14/11.
//

#import "JJGNewsCell.h"


@implementation JJGNewsCell

@synthesize articleTitle, articleSummary, articlePostDate, articleImage, imageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default-news-article-image.png"]];
		imageView.frame = CGRectMake(12.0f, 12.0f, 50.0f, 50.0f);
		[self.contentView addSubview:imageView];

		articlePostDate = [[UILabel alloc] initWithFrame:CGRectMake(70.0f, 6.0f, 225.0f, 20.0f)];
		articlePostDate.font = [UIFont systemFontOfSize:13.0f];
		articlePostDate.numberOfLines = 1;
		articlePostDate.textColor = [UIColor lightGrayColor];
		[self.contentView addSubview:articlePostDate];
		
		articleTitle = [[UILabel alloc] initWithFrame:CGRectMake(70.0f, 24.0f, 225.0f, 40.0f)];
		articleTitle.font = [UIFont boldSystemFontOfSize:15.0f];
		articleTitle.numberOfLines = 2;
		[self.contentView addSubview:articleTitle];
		
		articleSummary = [[UILabel alloc] initWithFrame:CGRectMake(70.0f, 66.0f, 225.0f, 60.0f)];
		articleSummary.font = [UIFont systemFontOfSize:14.0f];
		articleSummary.textColor = [UIColor darkGrayColor];
		articleSummary.numberOfLines = 3;
		[self.contentView addSubview:articleSummary];
	}
	
	return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
	[super willMoveToSuperview:newSuperview];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    /**
     * Configure the view for the selected state.
     */

    [super setSelected:selected animated:animated];
}


@end
