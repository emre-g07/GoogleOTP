//
//  HmacOTPGenerator.m
//
//  Copyright 2016 Murat ADIGÜZEL
//  Copyright 2016 EmreG A.Ş.
//

#import "HmacOTPGenerator.h"
#import <CommonCrypto/CommonHMAC.h>

NSString *const kOTPGeneratorSHA1Algorithm = @"SHA1";
NSString *const kOTPGeneratorSHA256Algorithm = @"SHA256";
NSString *const kOTPGeneratorSHA512Algorithm = @"SHA512";
NSString *const kOTPGeneratorSHAMD5Algorithm = @"MD5";

static NSUInteger kPinModTable[] = {
    0,
    10,
    100,
    1000,
    10000,
    100000,
    1000000,
    10000000,
    100000000,
};

@interface HmacOTPGenerator ()

@property (nonatomic, strong) NSData *secret;
@property (nonatomic) int digits;

@end

@implementation HmacOTPGenerator

- (id)initWithSecret:(NSData *)secret digits:(int)digits {
    if ((self = [super init])) {
        self.secret = secret;
        self.digits = digits;
    }
    return self;
}

- (NSString *)generateOTPWithCounter:(uint64_t)counter algorithm:(NSString*)algorithm{
    CCHmacAlgorithm alg;
    NSUInteger hashLength = 0;
    
    if ([algorithm isEqualToString:kOTPGeneratorSHA1Algorithm]) {
        alg = kCCHmacAlgSHA1;
        hashLength = CC_SHA1_DIGEST_LENGTH;
    } else if ([algorithm isEqualToString:kOTPGeneratorSHA256Algorithm]) {
        alg = kCCHmacAlgSHA256;
        hashLength = CC_SHA256_DIGEST_LENGTH;
    } else if ([algorithm isEqualToString:kOTPGeneratorSHA512Algorithm]) {
        alg = kCCHmacAlgSHA512;
        hashLength = CC_SHA512_DIGEST_LENGTH;
    } else if ([algorithm isEqualToString:kOTPGeneratorSHAMD5Algorithm]) {
        alg = kCCHmacAlgMD5;
        hashLength = CC_MD5_DIGEST_LENGTH;
    } else {
        return nil;
    }
    
    NSMutableData *hash = [NSMutableData dataWithLength:hashLength];
    
    counter = NSSwapHostLongLongToBig(counter);
    NSData *counterData = [NSData dataWithBytes:&counter
                                         length:sizeof(counter)];
    CCHmacContext ctx;
    CCHmacInit(&ctx, alg, [self.secret bytes], [self.secret length]);
    CCHmacUpdate(&ctx, [counterData bytes], [counterData length]);
    CCHmacFinal(&ctx, [hash mutableBytes]);
    
    const char *ptr = [hash bytes];
    unsigned char offset = ptr[hashLength-1] & 0x0f;
    uint32_t truncatedHash =
    NSSwapBigIntToHost(*((uint32_t *)&ptr[offset])) & 0x7fffffff;
    uint32_t pinValue = truncatedHash % kPinModTable[_digits];
    
    return [NSString stringWithFormat:@"%0*u", _digits, pinValue];
}

@end
