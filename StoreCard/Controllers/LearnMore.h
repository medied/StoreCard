//
//  LearnMore.h
//  StoreCard
//
//  Created by Andrew Harris on 10/27/14.
//  Copyright (c) 2014 mercurypay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LearnMore : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *txtName;
@property (strong, nonatomic) IBOutlet UITextField *txtCompany;
@property (strong, nonatomic) IBOutlet UITextField *txtPhone;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtBusinessType;

@property (strong, nonatomic) IBOutlet UIButton *btnSubmitForm;

- (IBAction)btnLaunchMail:(id)sender;

@end
