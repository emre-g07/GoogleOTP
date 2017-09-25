# GoogleOTP
This app help to create Google OTP.
With this project, you can
 * create OTP which based on Google Authenticator Algorithm.
 * scan barcode to create OTP
 
 ![Alt text](https://user-images.githubusercontent.com/6350065/30824855-9924dfa2-a239-11e7-8639-a0c2efebf412.png "Create OTP Options")
 
i use below string to create Google OTP
otpauth://totp/AWP-S0134TESTT13:googleadmin?secret=%@&issuer=AWP-S0134TESTT13&algorithm=SHA1&digits=8&period=30

 ![Alt text](https://user-images.githubusercontent.com/6350065/30824848-934c4a2a-a239-11e7-8bb2-f8a086759be4.png "Result of OTP creation process")


totp
 * totp : Time base OTP
 * hotp : counter base OTP

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
