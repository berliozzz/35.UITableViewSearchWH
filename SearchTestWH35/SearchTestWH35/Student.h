//
//  Student.h
//  SearchTestWH35
//
//  Created by Nikolay Berlioz on 04.03.16.
//  Copyright © 2016 Nikolay Berlioz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Student : NSObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSDate *dayOfBirthday;
@property (assign, nonatomic) NSInteger monthOfBirthday;

+ (Student*) randomStudent;


@end
