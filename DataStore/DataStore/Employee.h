//
//  Employee.h
//  DataStore
//
//  Created by Iacopo Peri on 13/03/15.
//  Copyright (c) 2015 Iacopo Peri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Employee : NSObject

@property NSString* firstName;
@property NSString* familyName;
@property NSString* employment;
@property bool isOk;

- (id) initWithFirstName:(NSString*)fin
                          andFamilyName:(NSString*)fam
             andEmployee:(NSString*)employ;

@end
