//
//  ViewController.m
//  Google OTP
//
//  Created by EmreG on 22.09.2017.
//  Copyright © 2017 EmreG. All rights reserved.
//

#import "ViewController.h"
#import "GoogleAutOTPTableViewCell.h"
#import "QRCodeReaderViewController.h"
#import "HmacOTPGenerator.h"
#import "GTMStringEncoding.h"
#import "TOTP.h"


static NSString *const kBase32Charset = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ234567";
static NSString *const kBase32Synonyms =
@"AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz";
static NSString *const kBase32Sep = @" -";

@interface ViewController ()<UITableViewDelegate,QRCodeReaderDelegate>{

    NSMutableArray *otpList;
    BOOL isCallGoogleAuthenticationTOTP;
}

@property (strong, nonatomic) IBOutlet UITableView *tableViewOTPList;
@property (nonatomic, strong) HmacOTPGenerator *otpGenerator;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    otpList = [[NSMutableArray alloc] init];
    isCallGoogleAuthenticationTOTP = NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickedOTPStartAction:(id)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Options" message:@"Please select Google OPT option" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // Cancel button tappped.
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"With QRReader" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        
        [self dismissViewControllerAnimated:YES completion:^{
        }];
        [self clickedCreateQRCodeReaderButton];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"With Manuel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    
        
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        [self alertPopUpWithInput];
    }]];
    
    
    [self presentViewController:actionSheet animated:YES completion:nil];
    
}

-(void)alertPopUpWithInput{

    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Google OTP"
                                                                              message: @"Please enter secret key which obtain from Google."
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Secret Key";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField * secretKey = textfields[0];
        if (secretKey.text.length > 0) {
            NSString *resultAsString = [NSString stringWithFormat:@"otpauth://totp/AWP-S0134SWIFTT13:swpadmin?secret=%@&issuer=AWP-S0134TESTT13&algorithm=SHA1&digits=8&period=30",secretKey];
            [self createTOTP:resultAsString];
        }else {
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@"Google OTP"
                                         message:@"Please enter secret key which obtain from Google. This app will not check this secret key that is suitable/correct!"
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"OK"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                        }];
            
            
            [alert addAction:yesButton];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [otpList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat rowHeight = 80;
    return rowHeight;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GoogleAutOTPTableViewCell * cell = [self.tableViewOTPList dequeueReusableCellWithIdentifier:@"mycell"];
    
    if (!cell){
        [self.tableViewOTPList registerNib:[UINib nibWithNibName:@"GoogleAutOTPTableViewCell" bundle:nil] forCellReuseIdentifier:@"mycell"];
        cell = [self.tableViewOTPList dequeueReusableCellWithIdentifier:@"mycell"];
    }
    
    TOTP *otp = [otpList objectAtIndex:indexPath.row];
    cell.lblBarcodeName.text = otp.name;
    cell.lblBarcodeIssuer.text = otp.issuer;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    isCallGoogleAuthenticationTOTP = NO;
    TOTP *otp = [otpList objectAtIndex:indexPath.row];
    [self showOTP:otp];
}

-(void)clickedCreateQRCodeReaderButton{
    
    isCallGoogleAuthenticationTOTP = NO;
    QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    // Instantiate the view controller
    QRCodeReaderViewController *vc = [QRCodeReaderViewController readerWithCancelButtonTitle:@"Cancel" codeReader:reader startScanningAtLoad:YES showSwitchCameraButton:YES showTorchButton:YES];
    
    // Set the presentation style
    vc.modalPresentationStyle = UIModalPresentationFormSheet;
    
    // Define the delegate receiver
    vc.delegate = self;
    
    // Or use blocks
    [reader setCompletionWithBlock:^(NSString *resultAsString) {
        
        [self createTOTP:resultAsString];
    }];
    
    [self presentViewController:vc animated:YES completion:NULL];
}

-(NSData *)base32Decode:(NSString *)string {
    GTMStringEncoding *coder =
    [GTMStringEncoding stringEncodingWithString:kBase32Charset];
    [coder addDecodeSynonyms:kBase32Synonyms];
    [coder ignoreCharacters:kBase32Sep];
    return [coder decode:string error:nil];
}

-(void)showOTP:(TOTP*)otp{
    
    NSData *secret = [self base32Decode:otp.secret];
    self.otpGenerator = [[HmacOTPGenerator alloc] initWithSecret:secret digits:[otp.digits intValue]];
    
    NSTimeInterval seconds = [[NSDate date] timeIntervalSince1970];
    uint64_t counter = (uint64_t)(seconds / [otp.period intValue]);
    
    NSString *resultOTP = [self.otpGenerator generateOTPWithCounter:counter algorithm:otp.algorithm];
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Google OTP"
                                 message:resultOTP
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                }];
    
    
    [alert addAction:yesButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)createTOTP:(NSString*)resultAsString{
    
    TOTP *otp = [self parseQRCode:resultAsString];
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    if (isCallGoogleAuthenticationTOTP == NO) {
        isCallGoogleAuthenticationTOTP = YES;
        [otpList addObject:otp];
        [self.tableViewOTPList reloadData];
        [self showOTP:otp];
    }
}

-(TOTP*)parseQRCode:(NSString*)resultAsString{
    
    NSMutableDictionary *barcodeKeyValue = [NSMutableDictionary new];
    NSArray *parseArray = [resultAsString componentsSeparatedByString:@"?"];
    NSString *otpNamePart = [parseArray objectAtIndex:0];
    NSArray* otpNamePartArray = [otpNamePart componentsSeparatedByString:@":"];
    NSString* otpName = [otpNamePartArray objectAtIndex:([otpNamePartArray count] -1)];
    if ([parseArray count] > 1) {
        NSString *actualPart = [parseArray objectAtIndex:1];
        parseArray = [actualPart componentsSeparatedByString:@"&"];
        
        for (int i = 0; i< [parseArray count]; i++) {
            NSString *parseValue = [parseArray objectAtIndex:i];
            NSArray *valueArray = [parseValue componentsSeparatedByString:@"="];
            
            if ([valueArray count] > 1) {
                [barcodeKeyValue setObject:[valueArray objectAtIndex:1] forKey:[valueArray objectAtIndex:0]];
            }
        }
    }
    
    NSString* activationCode = [barcodeKeyValue objectForKey:@"secret"];
    NSString* period = [barcodeKeyValue objectForKey:@"period"];
    NSString* digits = [barcodeKeyValue objectForKey:@"digits"];
    NSString* algorithm = [barcodeKeyValue objectForKey:@"algorithm"];
    NSString* issuer = [barcodeKeyValue objectForKey:@"issuer"];
    
    
    TOTP *totp = [TOTP new];
    totp.secret = activationCode;
    totp.period = period;
    totp.digits = digits;
    totp.algorithm = algorithm;
    totp.issuer = issuer;
    totp.name = otpName;
    return totp;
}

@end
