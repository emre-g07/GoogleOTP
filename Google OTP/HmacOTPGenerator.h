//
//  HmacOTPGenerator.h
//
//  Copyright 2016 Murat ADIGÜZEL
//  Copyright 2016 EmreG A.Ş.
//

#import <Foundation/Foundation.h>

@interface HmacOTPGenerator : NSObject

- (id)initWithSecret:(NSData *)secret digits:(int)digits;
- (NSString *)generateOTPWithCounter:(uint64_t)counter algorithm:(NSString*)algorithm;

@end
