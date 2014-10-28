//
//  StoreCard.m
//  StoreCard Money 20/20 2014 TradeShow iOS App
//
//  Created by Andrew Harris on 10/8/14.
//  Copyright (c) 2014 mercurypay. All rights reserved.
//

#import "StoreCard.h"
#import "AppDelegate.h"

@interface StoreCard ()

@property double total;
@property int itemCount;

@property NSString *url;
@property NSString *merchantID;
@property NSString *merchantPassword;
@property NSString *tranType;
@property NSString *tranCode;

@end

@implementation StoreCard

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _total = 0;
    _itemCount = 0;
    [self updateSale];
    
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTap)];
    [_lblKeyedSV addGestureRecognizer:tapGesture];
    
    	// Configure settings to target proper platform
    
   	// BISTRO 6435 Development Network
		// 1.	Card Range 6050110010032766196 – 6050110010032767195 These cards are branded with the same merchant test environment BISTRO 6435 but this range has Developer Network stamped on the top.
		// 2.	Card configuration: BID 1, 3 digit security codes printed on card, 5% cash back option
		// 3.	Card range is set up in SQL for use over legacy CERT for all standard gift card functionality.
		// 4.	Card range was also built in Prod/Bon Appetite if needed.
		// 5.	This range over CERT links to a separate Cert version of the StoreCard Manager site externally reached at https://storecard.mercurydev.net For technical, security and firewall reasons this site is not accessible from our internal networked workstations.  Use this URL to access internally:  https://storecardui.test.prod.mps/
		// 6.	https://storecard.mercurydev.net will be printed on the back of these cards as well as in the corresponding QR code.
		// 7.	Reload activity on the StoreCard Manager site will be reported on that site as well as pushed out to Cert Developer Reporting.  The StoreCard manager site will include all development transaction history. 

	// CERT
    	// self.url = @"https://w1.mercurycert.net/PaymentsAPI";
    	// self.merchantID = @"003503902913105";
	// self.merchantPassword = @"xyz";
    
    
    	// Additional Option: Production Testing
	// There is a separate set of production issued cards and procedures for testing over BISTRO 6435 in the production environment.  

	// BISTRO 6435 over Production
	// 1.	Card configuration: BID 543121, 3 digit security codes printed on card, 5% cash back option. Note these cards to not have the Developer Network Stamp on them.  
	// 2.	Primary MID is 88430189141=BISTRO.  Additional TIDs can be added as needed.
	// 3.	CRM was used over Production to load two gift ranges for all standard gift card functionality.

    	// PROD
    	// self.url = @"https://w1.mercurypay.com/PaymentsAPI";
    	// self.merchantID = @"88430189141=BISTRO";
    	// self.merchantPassword =@"81301DUR";
}

- (void)viewDidAppear
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)labelTap
{
    [self sendTransaction:_lblKeyedSV.text];
}

- (void)sendTransaction:(NSString *)acct
{
    
    NSString *min = @"00001";
    NSString *max = @"10000";
    
    int randNum = arc4random() % ([max intValue] - [min intValue]) + [min intValue];
    NSString *num = [NSString stringWithFormat:@"%d", randNum];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    [dictionary setObject:num forKey:@"InvoiceNo"]; //randoNum to avoid AP*
    [dictionary setObject:num forKey:@"RefNo"]; //randoNum to avoid AP*
    [dictionary setObject:@"Bistro 6435 iOS Demo POS - StoreCard" forKey:@"Memo"];
    [dictionary setObject:[NSString stringWithFormat:@"%.2f", _total] forKey:@"Purchase"];
    [dictionary setObject:acct forKey:@"AcctNo"];
    [dictionary setObject:@"6453 Bistro iOS App" forKey:@"OperatorID"];
    [dictionary setObject:@"Bistro 6435 iOS Demo POS - StoreCard" forKey:@"Memo"];
    
    [self processTransactionWithDictionary:dictionary andResource:@"/PrePaid/Sale"];
}

- (IBAction)clickGiftSale:(id)sender {
    [self sendTransaction:@"7712950000000000353"];
}

- (IBAction)btnClear:(id)sender {
    NSString *label = ((UIButton*)sender).titleLabel.text;
    if ([label isEqualToString:@"Clear"]){
        _total = 0;
        _itemCount =0;
    }
    [self updateSale];
}

- (IBAction)btnClearKeyPad:(id)sender {
    NSString *label = ((UIButton*)sender).titleLabel.text;
    if ([label isEqualToString:@"Clear"]){
        _lblKeyedSV.text = @"";
    }
}

- (IBAction)btnQR:(id)sender {
    // Present a barcode reader that scans from the camera feed
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    // Disable rarely used I2/5 to improve performance
    ZBarImageScanner *scanner = reader.scanner;
    [scanner setSymbology: ZBAR_I25 config: ZBAR_CFG_ENABLE to: 0];
    
    // Present and release the controller
    [self presentViewController:reader animated:YES completion:nil];
}

- (void) imagePickerController: (UIImagePickerController*) reader didFinishPickingMediaWithInfo: (NSDictionary*) info {
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    
    ZBarSymbol *symbol = nil;
    
    for(symbol in results)
        break;

    NSLog(@"StoredValue = %@", symbol.data);
    [self sendTransaction:symbol.data];
}

- (IBAction)btn2dollar:(id)sender {
    _total = _total + 2.00;
    _itemCount++;
    [self updateSale];
}

- (IBAction)btn5dollar:(id)sender {
    _total = _total + 5.00;
    _itemCount++;
    [self updateSale];
}

- (IBAction)btn10dollar:(id)sender {
    _total = _total + 10.00;
    _itemCount++;
    [self updateSale];
}

- (IBAction)btnKeypadClick:(id)sender {
    NSString *label = ((UIButton*)sender).titleLabel.text;
    _lblKeyedSV.text = [_lblKeyedSV.text stringByAppendingFormat:@"%@", label];
}

- (void)updateSale {
    if (_itemCount > 0) {
        _lbltemsPurchased.text = [NSString stringWithFormat:@"Sale (%d Items)", _itemCount];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        _lblDollarAmount.text = [formatter stringFromNumber:[NSNumber numberWithDouble:_total]];
        _lblTranType.text = @"PrePaid";
        _btnCharge.enabled = NO;
        [_btnCharge setBackgroundColor: [UIColor colorWithRed:102.0/255.0 green:204.0/255.0 blue:255.0/255.0 alpha:0.5]];
    }
    else {
        _lbltemsPurchased.text = @"No Sale (0)";
        _lblDollarAmount.text = @"$0.00";
        _lblTranType.text = @"";
        _btnCharge.enabled = NO;
        [_btnCharge setBackgroundColor: [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0]];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    _total = 0;
    _itemCount =0;
    
    [self updateSale];
    [self dismissModalViewControllerAnimated:YES]; // this dude makes the tapped label go back to login screen... works fine on QR scan. bad user experience. I have put everywhere! read that there are some methods but over my knowledge level. could and else if in the UIAlertView be the solution? 
}

- (void) processTransactionWithDictionary:(NSDictionary *)dictionary andResource:(NSString *) resource {
    
    // Create a JSON POST
    NSString *urlResource = [NSString stringWithFormat:@"%@%@", self.url, resource];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlResource]];
	[request setTimeoutInterval:30];
	[request setHTTPMethod:@"POST"];
	[request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    // Add Authorization header
    NSString *credentials = [NSString stringWithFormat:@"%@:%@", self.merchantID, self.merchantPassword];
    NSString *base64Credentials = [self base64String:credentials];
    [request addValue:[@"Basic " stringByAppendingString:base64Credentials] forHTTPHeaderField:@"Authorization"];
    
    // Serialize NSDictionary to JSON data
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    
    // Add JSON data to request body
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: jsonData];
    
    // Process request async
    [NSURLConnection connectionWithRequest:request delegate:self];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    [dictionary setObject:@"88430189141" forKey:@"MerchantID"];
    [dictionary setObject:@"605011..." forKey:@"AcctNo"];
    [dictionary setObject:@"PrePaid" forKey:@"TranType"];
    [dictionary setObject:@"Offline" forKey:@"RefNo"];
    [dictionary setObject:@"Approved" forKey:@"CmdStatus"];
    [dictionary setObject:@"111111" forKey:@"AuthCode"];
    [dictionary setObject:[NSString stringWithFormat:@"%.2f", _total] forKey:@"Authorize"];
    [dictionary setObject:@"Offline" forKey:@"ResponseOrigin"];
    [dictionary setObject:@"Offline Success" forKey:@"TextResponse"];
    [dictionary setObject:@"Sale" forKey:@"TranCode"];
    [dictionary setObject:@"111111" forKey:@"InvoiceNo"];
    [dictionary setObject:@"6453 Bistro iOS App" forKey:@"OperatorID"];
    [dictionary setObject:[NSString stringWithFormat:@"%.2f", _total] forKey:@"Purchase"];
    [dictionary setObject:@"Offline" forKey:@"Balance"];
    [dictionary setObject:@"Offline" forKey:@"DSIXReturnCode"];
    [dictionary setObject:@"Bistro 6435 iOS Demo POS - StoreCard" forKey:@"Memo"];

    [self showReceipt: dictionary];

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Deserialize response from REST service
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    [self showReceipt: dictionary];
}

- (void)showReceipt: (NSDictionary *)dictionary {
     NSMutableString *message = [NSMutableString new];
    for (NSString *key in [dictionary allKeys])
    {
        [message appendFormat:@"%@: %@;\n", key, [dictionary objectForKey:key]];
    }
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"JSON RESTful\n Payments API\n ------\n RESPONSE\n -----\n Stored Value\n ------\n"
                                                   message: message
                                                  delegate: self
                                         cancelButtonTitle: nil
                                         otherButtonTitles:@"OK",nil];
    [alert show];
}
// Base64 function taken from http://calebmadrigal.com/string-to-base64-string-in-objective-c/
- (NSString *)base64String:(NSString *)str
{
    NSData *theData = [str dataUsingEncoding: NSASCIIStringEncoding];
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

@end
