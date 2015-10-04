//
//  RegisterViewController.m
//  Lesson1
//
//  Created by Denis on 03.10.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import "RegisterViewController.h"
#import "NetManager.h"

@interface RegisterViewController (){
    
    int randCode;
}

@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *confPwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@property (weak, nonatomic) IBOutlet UILabel *vCode;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self gRandCode];
    
    [[self rac_signalForSelector:@selector(textFieldShouldReturn:)] subscribeNext:^(RACTuple *tuple) {

        UITextField *tf = tuple.first;
        
        if (tf == self.loginTextField){
            
            [self.pwdTextField becomeFirstResponder];
        }
        
        if (tf == self.pwdTextField) {
            
            [self.confPwdTextField becomeFirstResponder];
        }
        
        if (tf == self.confPwdTextField) {
            
            [self.codeTextField becomeFirstResponder];
        }
        
        if(tf == self.codeTextField){
            
            [tf resignFirstResponder];
            [self.registerButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
    }];
    
    RAC(self.registerButton, enabled) = [RACSignal combineLatest:@[ self.loginTextField.rac_textSignal, self.pwdTextField.rac_textSignal, self.confPwdTextField.rac_textSignal, self.codeTextField.rac_textSignal] reduce:^(NSString *login, NSString *password, NSString *confPwdTextField, NSString *code){
        return @(login.length > 4 && password.length > 2 && [self checkPwd:password confPwdText:confPwdTextField] && [self checkCode:code]);
    }];
    
    [[[self.registerButton rac_signalForControlEvents:UIControlEventTouchUpInside] filter:^BOOL(UIButton *sender) {
        return sender.enabled;
    }] subscribeNext:^(id x) {
        [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"AppVC"] animated:YES completion:nil];
        }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)refreshButt:(UIButton *)sender {
    
    
    [self gRandCode];
}


- (IBAction)cancelButt:(UIButton *)sender {
    
    [self goToMainScreen];
}


- (IBAction)registerButt:(UIButton *)sender {
    
    
}


-(void)gRandCode {
    
    [[self vCode] setText:[@"Code: " stringByAppendingString: [self rand1]]];
}


-(NSString *)rand1 {
    
    randCode = arc4random() % 10;
    return [[NSNumber numberWithInt: randCode] stringValue] ;
}


-(void)goToMainScreen {
    
    UIViewController *contr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"auth"];
    [self presentViewController:contr animated:YES completion: nil];
}


-(BOOL)checkCode:(NSString *)codeTextField {
    
    return [codeTextField intValue] == randCode;
}


-(BOOL)checkPwd:(NSString *)pwdText confPwdText:(NSString *)confPwdText{

    return [pwdText isEqualToString:confPwdText];
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
