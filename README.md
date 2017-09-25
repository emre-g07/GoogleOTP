# GoogleOTP

Two-factor authentication client, with support for HOTP and TOTP. This clien use a original Google Authenticator client code for iOS. 

You can now open the Google OTP.xcodeproj file in XCode and run the application.

With this project, you can
 * create OTP which based on Google Authenticator Algorithm.
 * scan barcode to create OTP
 
 ![Alt text](https://user-images.githubusercontent.com/6350065/30824855-9924dfa2-a239-11e7-8639-a0c2efebf412.png "Create OTP Options")
 
i use below string to create Google OTP
otpauth://totp/AWP-S0134TESTT13:googleadmin?secret=%@&issuer=AWP-S0134TESTT13&algorithm=SHA1&digits=8&period=30

 ![Alt text](https://user-images.githubusercontent.com/6350065/30824848-934c4a2a-a239-11e7-8bb2-f8a086759be4.png "Result of OTP creation process")

The supported PARAMETERS are:

  algorithm=(SHA1|SHA256|SHA512|MD5)
    OPTIONAL, defaults to SHA1.

  secret=[websafe Base64 encoded secret key, no padding]
    REQUIRED, 128 bits or more.

  digits=(6|8)
    OPTIONAL, defaults to 6.

  counter=N  (hotp specific)
    REQUIRED

  period=N  (totp specific)
    OPTIONAL, defaults to 30.

totp
 * totp : Time base OTP
 * hotp : counter base OTP
HOTP: An HMAC-Based One-Time Password Algorithm http://tools.ietf.org/html/rfc4226
TOTP: Time-based One-time Password Algorithm http://tools.ietf.org/html/draft-mraihi-totp-timebased

secret
 * This is a screet key which is obtain from google
 
algorithm : 
 * SHA1
 * SHA256
 * SHA512
 * MD5

digits
  *OTP digit number/default is 6 digit. Other option is 8

period
  *OTP renew period/seconds
