//
//  Employee.m
//  DataStore
//
//  Created by Iacopo Peri on 13/03/15.
//  Copyright (c) 2015 Iacopo Peri. All rights reserved.
//

#import "Employee.h"

@implementation Employee

- (id) initWithFirstName:(NSString*)fin
           andFamilyName:(NSString*)fam
             andEmployee:(NSString*)employ {
    self = [super init];
    if(self) {
        self.firstName = fin;
        self.familyName = fam;
        self.employment = employ;
    }
    return self;
}

@end
