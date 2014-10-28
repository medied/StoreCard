//
//  StoreCard.h
//  StoreCard Money 20/20 2014 TradeShow iOS App
//
//  Created by Andrew Harris on 10/8/14.
//  Copyright (c) 2014 mercurypay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@interface StoreCard : UIViewController <ZBarReaderDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *lbltemsPurchased;
@property (strong, nonatomic) IBOutlet UILabel *lblTranType;
@property (strong, nonatomic) IBOutlet UILabel *lblKeyedSV;
@property (strong, nonatomic) IBOutlet UILabel *lblDollarAmount;
@property (strong, nonatomic) IBOutlet UIButton *btnCharge;
@property (strong, nonatomic) IBOutlet UIButton *btn2dollar;
@property (strong, nonatomic) IBOutlet UIButton *btn5dollar;
@property (strong, nonatomic) IBOutlet UIButton *btn10dollar;


@property (weak, nonatomic) IBOutlet UIButton *btnGiftSale;

- (IBAction)btnQR:(id)sender;
- (IBAction)btn2dollar:(id)sender;
- (IBAction)btn5dollar:(id)sender;
- (IBAction)btn10dollar:(id)sender;
- (IBAction)clickGiftSale:(id)sender;
- (IBAction)btnClear:(id)sender;
- (IBAction)btnClearKeyPad:(id)sender;
- (IBAction)btnKeypadClick:(id)sender;

@end
