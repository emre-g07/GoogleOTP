//
//  TOTP.h
//  Google OTP
//
//  Created by EmreG on 11.04.2017.
//  Copyright © 2017 EmreG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TOTP : NSObject
@property(nonatomic,strong) NSString *secret;
@property(nonatomic,strong) NSString *period;
@property(nonatomic,strong) NSString *digits;
@property(nonatomic,strong) NSString *algorithm;
@property(nonatomic,strong) NSString *issuer;
@property(nonatomic,strong) NSString *name;
@end
