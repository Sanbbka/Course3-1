//
//  Item.h
//  Lesson1
//
//  Created by Denis on 03.10.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject

@property (nonatomic, readwrite) int number;
@property (nonatomic, readwrite) NSString *text1;

-(instancetype)initWithNumber:(int)number;
    

@end
