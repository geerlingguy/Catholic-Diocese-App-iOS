//
//  Parish.h
//  Catholic Diocese
//
//  Created by Jeff Geerling on 2/6/11.
//

#import <CoreData/CoreData.h>


@interface Parish :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * parishLatitude;
@property (nonatomic, retain) NSNumber * parishLongitude;
@property (nonatomic, retain) NSString * parishName;
@property (nonatomic, retain) NSNumber * parishNumber;
@property (nonatomic, retain) NSString * parishArchdiocesanURL;
@property (nonatomic, retain) NSString * parishStreetAddress;
@property (nonatomic, retain) NSString * parishCity;
@property (nonatomic, retain) NSString * parishZipCode;
@property (nonatomic, retain) NSString * parishState;

@end



