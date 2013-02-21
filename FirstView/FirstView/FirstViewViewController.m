//
//  FirstViewViewController.m
//  FirstView
//
//  Created by Lion User on 20/02/2013.
//  Copyright (c) 2013 Lion User. All rights reserved.
//

#import "FirstViewViewController.h"
#import "LoginSuccessfulViewController.h"


@interface FirstViewViewController ()

@end

@implementation FirstViewViewController
//@synthesize InputUsername;
@synthesize username, password;

//Initialize the respective error code with the respective messages
- (void)viewDidLoad
{
    self.errorCode = [NSDictionary dictionaryWithObjectsAndKeys:
                      @"Invalid username and password combination. Please try again.", [NSNumber numberWithInt:ERR_BAD_CREDENTIALS],
                      @"This username alreeady exists. Please try again.", [NSNumber numberWithInt:ERR_USER_EXISTS],
                      @"The username should not be empty and at most 128 characters long. Please try again.", [NSNumber numberWithInt:ERR_BAD_USERNAME],
                      @"The password should be at most 128 characters long. Please try again.", [NSNumber numberWithInt:ERR_BAD_PASSWORD],
                      nil];
    self.URL = [NSString stringWithFormat:@"http://frozen-anchorage-1167.herokuapp.com"];
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}



//A response_Handler method that takes in the reply as argument (for login button)
- (IBAction)loginExecution:(id)sender{
    NSDictionary *reply = [self HTTPResponseAndRequest:@"/users/login"];
    //runs the method by passing in the reply as argument
    NSLog(@"reply");
    [self response_Handler:reply];
}

//A response_Handler method that takes in the reply as arguemnt (for addUser button)
- (IBAction)addUserExecution:(id)sender{
    NSDictionary *reply = [self HTTPResponseAndRequest:@"/users/add"];
    [self response_Handler:reply];
}

//Handles the HTTP response and request
- (NSDictionary*) HTTPResponseAndRequest:(NSString *)url_appended{
    self.username = self.inputUsername.text;
    self.password = self.inputPassword.text;
    
    NSError *err;
    
    NSDictionary *jsonDict = [NSDictionary dictionaryWithObjectsAndKeys:self.username, @"user", self.password, @"password", nil];
    
    NSData *JRequest = [NSJSONSerialization dataWithJSONObject:jsonDict options:NSJSONWritingPrettyPrinted error:&err];
    
    //NSLog(@"JsonRequest: %@", [[NSString alloc] initWithData:JRequest encoding:NSUTF8StringEncoding]);
    NSString *url_address = [NSString stringWithFormat:@"%@%@", self.URL, url_appended];
    NSLog(@"address: %@", url_address);
    
    NSURL *address = [NSURL URLWithString:url_address];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:address cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:[NSString stringWithFormat:@"%d", [JRequest length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:JRequest];
    
    NSURLResponse *urlResp = [[NSURLResponse alloc]init];
    
    NSData *JResponse = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResp error:&err];
    
    NSDictionary *JDictResponse = [NSJSONSerialization JSONObjectWithData:JResponse options:kNilOptions error:&err];
    
    return JDictResponse;
    
}

//Get error message corresponding to the error code from current response
- (NSString *)getReturnMsg:(NSDictionary *)resp{
    NSNumber *errCode = [resp objectForKey:@"errCode"];
    NSLog(@"error code: %@", errCode);
    NSString *msg = [self.errorCode objectForKey:errCode];
    return msg;
}

- (void)response_Handler:(NSDictionary *)reply{
    NSString *return_message = [self getReturnMsg:reply];
    NSLog(@"return_message: %@", return_message);
    
    //if return_message == nil, there is no errors. Else, display error message
    if (return_message == nil){
        self.counts = [reply objectForKey:@"count"];
        LoginSuccessfulViewController *viewControl = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginSuccessfulViewController"];
        [self presentViewController:viewControl animated:YES completion:nil];
        viewControl.Display.text = [NSString stringWithFormat:@"Welcome %@ ! \n You have logged in %@ times.", self.username, self.counts];
    }
    else{
        self.displayMessage.text = return_message;
    }
    
    [self.inputUsername resignFirstResponder];
    self.inputUsername.text = @"";
    self.inputPassword.text = @"";
}


@end
