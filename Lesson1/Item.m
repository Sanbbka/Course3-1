//
//  Item.m
//  Lesson1
//
//  Created by Denis on 03.10.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import "Item.h"

@implementation Item


-(instancetype)initWithNumber:(int)number {
    
    self = [super init];
    
    if (self) {
        
        _number = number;
        _text1 = [self genItem:number];
    }
    return self;
}


-(NSString *)genItem:(int)count {
    
    NSString *itemStr = @"";
    NSString *str = @"";
    
    for (int i = 1; i <= count; i++) {
        str = [NSString stringWithFormat:@"%i", i];
        itemStr = [itemStr stringByAppendingString:str];
    }
    return itemStr;
}

@end
