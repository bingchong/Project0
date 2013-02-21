//
//  LoginSuccessfulViewController.m
//  FirstView
//
//  Created by Lion User on 20/02/2013.
//  Copyright (c) 2013 Lion User. All rights reserved.
//

#import "LoginSuccessfulViewController.h"

@interface LoginSuccessfulViewController ()

@end

@implementation LoginSuccessfulViewController
//@synthesize DisplayText, DisplayUsername;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    //DisplayUsername.text = DisplayText.text;
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

//- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
//    [theTextField resignFirstResponder];
//    return YES;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
