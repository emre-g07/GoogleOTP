//
//  GoogleAutOTPTableViewCell.h
//  Google OTP
//
//  Created by EmreG on 10.04.2017.
//  Copyright © 2017 EmreG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoogleAutOTPTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgBarcodeThumbnail;
@property (strong, nonatomic) IBOutlet UILabel *lblBarcodeName;
@property (strong, nonatomic) IBOutlet UILabel *lblBarcodeIssuer;

@end
