//
//  ParishEvent.h
//  Catholic Diocese
//
//  Created by Jeff Geerling on 2/20/11.
//

#import <CoreData/CoreData.h>


@interface ParishEvents :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * eventEnd;
@property (nonatomic, retain) NSNumber * parishNumber;
@property (nonatomic, retain) NSString * eventLanguage;
@property (nonatomic, retain) NSString * eventDay;
@property (nonatomic, retain) NSNumber * eventTypeKey;
@property (nonatomic, retain) NSString * eventLocation;
@property (nonatomic, retain) NSString * eventStart;

@end



