//
//  ItemViewController.h
//  Lesson1
//
//  Created by Denis on 04.10.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <KVOMutableArray+ReactiveCocoaSupport.h>
@interface ItemViewController : UIViewController

@property (assign, nonatomic) NSInteger index;
@property (nonatomic) KVOMutableArray *items;

@end
