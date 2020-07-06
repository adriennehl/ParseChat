//
//  ViewController.m
//  ParseChat
//
//  Created by Adrienne Li on 7/6/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)onSignUp:(id)sender {
    // initialize a user object
    PFUser *newUser = [PFUser user];
    
    if ([self.usernameField.text isEqualToString:@""] || [self.passwordField.text isEqualToString:@""]) {
        UIAlertController *alert = [self createAlert:@"Please enter a username and password" title:@"Username and Password Required"];
        
        // show the alert controller
        [self presentViewController:alert animated:YES completion:^{
            // optional code for what happens after the alert controller has finished presenting
        }];
        
    }
    
    else {
        // set user properties
        newUser.username = self.usernameField.text;
        newUser.password = self.passwordField.text;
        
        // call sign up function on the object
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (error != nil) {
                UIAlertController *signupAlert = [self createAlert:error.localizedDescription title:@"Error Signing Up"];
                
                // show the alert controller
                [self presentViewController: signupAlert animated:YES completion:^{
                    // optional code for what happens after the alert controller has finished presenting
                }];
                
            } else {
                NSLog(@"User registered successfully");
                
                // manually segue to logged in view
                [self performSegueWithIdentifier:@"loginSegue" sender:nil];
            }
        }];
    }
}

- (IBAction)onLogin:(id)sender {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        
        if (error != nil) {
            UIAlertController *loginAlert = [self createAlert:error.localizedDescription title:@"Error Logging In"];
            
            // show the alert controller
            [self presentViewController: loginAlert animated:YES completion:^{
                // optional code for what happens after the alert controller has finished presenting
            }];
        } else {
            NSLog(@"User logged in successfully");
            
            // display view controller that needs to shown after successful login
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
    }];
}

- (UIAlertController *) createAlert: (NSString *) errorDescription title: (NSString *) title {
    
    
    // create a cancel action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
        // handle cancel response here. Doing nothing will dismiss the view.
    }];
    
    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
        // handle response here.
    }];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle: title
                                                                   message:errorDescription
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
    
    // add the cancel action to the alertController
    [alert addAction:cancelAction];
    
    // add the OK action to the alert controller
    [alert addAction:okAction];
    
    return alert;
    
}
@end
