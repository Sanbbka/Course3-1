//
//  ItemViewController.m
//  Lesson1
//
//  Created by Denis on 04.10.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import "ItemViewController.h"
#import "AppViewController.h"
#import "Item.h"

@interface ItemViewController ()
{
    Item *ite;
    int slideValue;
}
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *lenghtTextLabel;
@property (weak, nonatomic) IBOutlet UITextField *strTextfield;
@property (weak, nonatomic) IBOutlet UIButton *saveButt;
@property (weak, nonatomic) IBOutlet UIButton *svButton;


@end

@implementation ItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ite =  [self.items objectAtIndex:_index];
    
    
    
    @weakify(self);
    [[self.slider rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UISlider *slide) {
        @strongify(self);
        slideValue = (int)[slide value];
        ite.number = slideValue;
        [self.lenghtTextLabel setText:[NSString stringWithFormat:@"%i", slideValue]];
    }];
    
    RAC(self.svButton, enabled) = [RACSignal combineLatest:@[ self.strTextfield.rac_textSignal, RACObserve(ite, number) ] reduce:^(NSString *log, NSNumber *value){
        
        return @(log.length == value.integerValue);
    }];
    [self.slider setValue:[[self.items objectAtIndex:_index] number]];
    [[self lenghtTextLabel]setText:[NSString stringWithFormat:@"%i", (int)[_slider value]]];
    
    [[self.svButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        
        
        
        ite.text1 = self.strTextfield.text;
        ite.number = (int)[self.slider value];
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
