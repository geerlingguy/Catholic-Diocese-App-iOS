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

@property (nonatomic, strong) NSString * eventEnd;
@property (nonatomic, strong) NSNumber * parishNumber;
@property (nonatomic, strong) NSString * eventLanguage;
@property (nonatomic, strong) NSString * eventDay;
@property (nonatomic, strong) NSNumber * eventTypeKey;
@property (nonatomic, strong) NSString * eventLocation;
@property (nonatomic, strong) NSString * eventStart;


@end
