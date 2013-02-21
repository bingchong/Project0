//
//  FirstViewViewController.h
//  FirstView
//
//  Created by Lion User on 20/02/2013.
//  Copyright (c) 2013 Lion User. All rights reserved.
//

#import <UIKit/UIKit.h>

//Preset the error codes
static const int SUCCESS = 1;
static const int ERR_BAD_CREDENTIALS = -1;
static const int ERR_USER_EXISTS = -2;
static const int ERR_BAD_USERNAME = -3;
static const int ERR_BAD_PASSWORD = -4;

@interface FirstViewViewController : UIViewController <UITextFieldDelegate>

//Variables to store username, password, and number of logins (counts)
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSNumber *counts;

//Dictionary to contain error code
@property (strong, nonatomic) NSDictionary *errorCode;

//NSString for URL
@property (strong, nonatomic) NSString *URL;

//Outlet to display message
@property (strong, nonatomic) IBOutlet UITextView *displayMessage;


//User inputs for the username and password
@property (strong, nonatomic) IBOutlet UITextField *inputUsername;
@property (strong, nonatomic) IBOutlet UITextField *inputPassword;

//Methods for login and adduser buttons
- (IBAction)loginExecution:(id)sender;
- (IBAction)addUserExecution:(id)sender;

//Methods for HTTP and requests
- (NSDictionary*) HTTPResponseAndRequest: (NSString*)url_appended;
- (void) response_Handler: (NSDictionary *) reply;

//@property (strong, nonatomic) IBOutlet UITextField *InputUsername;


@end
