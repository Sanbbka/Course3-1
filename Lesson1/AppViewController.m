//
//  AppViewController.m
//  Lesson1
//
//  Created by Azat Almeev on 21.09.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import "AppViewController.h"
#import <ReactiveCocoa.h>
#import <KVOMutableArray+ReactiveCocoaSupport.h>
#import <BlocksKit+UIKit.h>
#import "Item.h"
#import "ItemViewController.h"


@interface AppViewController () {
    NSNumber *number;
    int count;
}

@property (nonatomic, readonly) KVOMutableArray *items;
@end

@implementation AppViewController
@synthesize items = _items;

-(void)viewDidLoad {
    [super viewDidLoad];
    count = 0;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    [self.tableView reloadData];
}


- (KVOMutableArray *)items {
    if (!_items) {
        _items = [KVOMutableArray new];
        @weakify(self);
        [_items.changeSignal subscribeNext:^(RACTuple *tuple) {
            @strongify(self);
            self.title = [NSString stringWithFormat:@"Items count: %@", @([tuple.first count])];
            NSKeyValueChange change = [tuple.second[NSKeyValueChangeKindKey] integerValue];
            NSArray *indices = [tuple.second[NSKeyValueChangeIndexesKey] bk_mapIndex:^id(NSUInteger index) {
                return [NSIndexPath indexPathForItem:index inSection:0];
            }];
            switch (change) {
                case NSKeyValueChangeInsertion:
                    [self.tableView insertRowsAtIndexPaths:indices withRowAnimation:UITableViewRowAnimationAutomatic];
                    break;
                case NSKeyValueChangeRemoval:
                    [self.tableView deleteRowsAtIndexPaths:indices withRowAnimation:UITableViewRowAnimationAutomatic];
                    break;
                case NSKeyValueChangeReplacement:
                    [self.tableView reloadRowsAtIndexPaths:indices withRowAnimation:UITableViewRowAnimationAutomatic];
                    break;
                default:
                    [self.tableView reloadData];
                    break;
            }
        }];
    }
    return _items;
}

- (IBAction)logoutDidPress:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addButtonDidPress:(id)sender {
   
    Item *item = [[Item alloc] initWithNumber:count];
    count++;
    [self.items addObject:item];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [NSNumber numberWithInt:[self.items[indexPath.row] number]]];
    cell.detailTextLabel.text = [self.items[indexPath.row] text1];//[NSString stringWithFormat:@"%@", itemsData[indexPath.row]];
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.items removeObjectAtIndex:indexPath.row];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self performSegueWithIdentifier:@"edit" sender:indexPath];
   

}


-(NSString *)genItem:(NSUInteger *)count {
    
    NSString *itemStr;
    
    for (NSInteger i = 1; i <= count; i++) {
        
        [itemStr stringByAppendingString: [NSString stringWithFormat:@"%li", (long)i]];
    }
    return itemStr;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"edit"]) {
        NSLog(@"ok");
        ItemViewController *itemVC = segue.destinationViewController;
        
        NSInteger numb = [(NSIndexPath *)sender row];
        itemVC.index = numb;
        itemVC.items = _items;
    }
}

- (void)dealloc {
    NSLog(@"%@ deallocated", NSStringFromClass([self class]));
}

@end
