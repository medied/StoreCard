//
//  LearnMore.m
//  StoreCard
//
//  Created by Andrew Harris on 10/27/14.
//  Copyright (c) 2014 mercurypay. All rights reserved.
//

#import "LearnMore.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface LearnMore ()

@end

@implementation LearnMore

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _txtName.delegate = self;
    _txtCompany.delegate = self;
    _txtPhone.delegate = self;
    _txtEmail.delegate = self;
    _txtBusinessType.delegate = self;
    [_txtName becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)textFieldShouldReturn:(UITextField *)formTextField {
    if (formTextField == _txtName) {
        [_txtCompany becomeFirstResponder];
    } else if (formTextField == _txtCompany) {
        [_txtPhone becomeFirstResponder];
    }
    else if (formTextField == _txtPhone) {
        [_txtEmail becomeFirstResponder];
    }
    else if (formTextField == _txtEmail) {
        [_txtBusinessType becomeFirstResponder];
    }
    else if (formTextField == _txtBusinessType) {
        [_txtBusinessType resignFirstResponder];
        
        [self btnSubmitForm:self];
    }
    
    return YES;
}

- (IBAction)btnSubmitForm:(id)sender {
}

- (IBAction)btnLaunchMail:(id)sender {
    // From within your active view controller
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;
        
        [mailCont setSubject:@"money2020 Learn More - StoreCard"];
        [mailCont setToRecipients:[NSArray arrayWithObjects:@"aharris@mercurypay.com", nil]];
        
        NSMutableString *message = [NSMutableString new];
        
        [message appendFormat:@"I would like more information about Mercury StoreCard \n\n"];
        [message appendFormat:@"NAME: %@\n", self.txtName.text];
        [message appendFormat:@"COMPANY: %@\n", self.txtCompany.text];
        [message appendFormat:@"PHONE: %@\n", self.txtPhone.text];
        [message appendFormat:@"EMAIL: %@\n", self.txtEmail.text];
        [message appendFormat:@"BUSINESS: %@\n", self.txtBusinessType.text];

        [mailCont setMessageBody:message isHTML:NO];
        
        [self presentModalViewController:mailCont animated:YES];
    }
}

// Then implement the delegate method
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissModalViewControllerAnimated:YES];
}

@end
