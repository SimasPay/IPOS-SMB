//
//  Constants.h
//  Simobi
//
//  Created by Ravi on 10/7/13.
//  Copyright (c) 2013 Mfino. All rights reserved.
//

#ifndef Simobi_Constants_h
#define Simobi_Constants_h

#define SIMOBI_KEY_WINDOW [UIApplication sharedApplication].keyWindow




/** A macro that uses conditional logic to log messages.
 */
#define DEBUG_MODE 1

#ifdef DEBUG
#define CONDITIONLOG(condition, xx, ...) { if ((condition)) { \
NSLog(xx, ##__VA_ARGS__); \
} \
} ((void)0)
#else
#define CONDITIONLOG(condition, xx, ...) ((void)0)
#endif // #ifdef DEBUG




#define SIP_YPOS -24.0f

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)




#define DIALOG_BUTTON_SIZE CGSizeMake(90.0f, 48.0f)
#define OBJECTFORKEY(x,key) [[[x objectForKey:@"response"] objectForKey:key] objectForKey:@"text"]


#define kSUCCESSTRANASACTION @"successTransaction"
#define kCHANGEPINNOTIFICATION @"successChangemPIN"
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )


#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
//#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define GetResponseCode(x) [[[x objectForKey:@"response"] objectForKey:@"message"] objectForKey:@"code"]
#define GetMessageText(x) [[[x objectForKey:@"response"] objectForKey:@"message"] objectForKey:@"text"]


/*
 *Success Codes
 */

#define SIMOBI_SUCCESS_LOGIN_CODE @"630"
#define SIMOBI_SUCCESS_CHANGE_MPIN @"2039"
#define SIMOBI_SUCCESS_ACTIVATION   @"2040"
#define SIMOBI_SUCCESS_RESET_MPIN @"26"
#define SIMOBI_SUCCESS_ACCOUNT_TRANSACTION_CODE @"67"
#define SIMOBI_SUCCESS_ACCOUNT_BALANCE_CODE @"4"
#define SIMOBI_SELFBANK_TRANSFER_SUCCESSCODE @"72"
#define SIMOBI_OTHERBANK_TRANSFER_SUCCESSCODE @"72"
#define SIMOBI_UANGKU_TRANSFER_SUCCESSCODE @"81"
#define SIMOBI_PAYMENT_SUCCESSCODE @"713"
#define SIMOBI_PURCHASE_SUCCESSCODE @"660"
#define SIMOBI_LOGIN_EXPIRE_CODE @"631"
#define SIMOBI_BILLINQUIRY_CODE @"2021"
#define SIMOBI_LOGIN_PHONE_NUMBER @"PhoneNumber"
#define SIMOBI_FORCE_CHANGE_PIN_CODE @"2177"

#define SimobiLoginNOsArray @"loginNumbersArray"

#define TXN_GetUserKey @"GetUserAPIKey"
#define TXN_FlashIz_BillPay_Inquiry @"QRPaymentInquiry"
#define TXN_FlashIz_BillPay_Confirmation @"QRPayment"

#define FlashIS_User_Key_SuccessCode @"2103"
#define FlashIS_Inquery_SuccessCode @"2109"
#define FlashIS_Confirmation_SuccessCode @"2111"


/*
 *Macro gives the Button with Image
 */
#define ButtonImage(button,imageName) {[button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];}

/*
 *Language
 */

#define SIMOBI_LANGUAGE_BAHASA @"Bahasa"
#define SIMOBI_LANGUAGE_ENGLISH @"English"
#define SIMOBI_LANGUAGE_STATUS @"Language"
//kolom harus diisi

/****************************************************************************************/

/*
 *Alert Message
 */

#define FIELDEMPTY_ALERT_ENGLISH @"fields can not be empty"
#define FIELDEMPTY_ALERT_BAHASA @"kolom harus diisi"
#define OTP_MESSAGE @"please enter the Simobi code\nsent to your mobile"
#define OTP_MESSAGE_BAHASA @"Silakan masukkan kode Simobi yang dikirim ke nomor HP Anda"
#define OTP_MESSAGE_OS6 @"please enter the Simobi code\nsent to your mobile"

/*
 * URL Parameters
 */

#define SERVICE @"service"
#define TXNNAME @"txnName"
#define AMOUNT @"amount"
#define SOURCEMDN @"sourceMDN"
#define SOURCEPIN @"sourcePIN"
#define SOURCEPOCKETCODE @"sourcePocketCode"
#define MFAOTP @"mfaOtp"
#define DESTPOCETCODE @"destPocketCode"
#define TRANSFERID @"transferID"
#define PARENTTXNID @"parentTxnID"
#define DESTACCOUNTNUMBER @"destAccountNo"
#define DESTBANKACCOUNT @"destBankAccount"
#define BILLNO @"billNo"
#define BILLERCODE @"billerCode"
#define ACTIVATION_NEWPIN @"activationNewPin"
#define ACTIVATION_CONFORMPIN @"activationConfirmPin"
#define ACTIVATION_OTP @"otp"
#define MFATRANSACTION @"mfaTransaction"
#define CHANGEPIN_NEWPIN @"newPIN"
#define CHANGEPIN_CONFIRMPIN @"confirmPIN"
#define TRANSFERID @"transferID"
#define PARTNETCODE @"partnerCode"
#define CONFIRMED @"confirmed"
#define VERSION @"version"
#define OTP @"otp"
#define INQUIRY @"Inquiry"
#define DESTMDN @"destMDN"
#define COMPANYID @"companyID"
#define POCKETCODE @"2"
#define CARDPAN @"cardPan"

#define SERVICE_BANK @"Bank"
#define SERVICE_ACCOUNT @"Account"
#define SERVICE_PAYMENT @"Payment"
#define SERVICE_PURCHASE @"Shopping"
#define SERVICE_PURCHASE_AIRTIME @"Buy"

#define TXN_INQUIRY_PURCHASE @"PurchaseInquiry"
#define TXN_CONFIRM_PURCHASE @"Purchase"
#define TXN_INQUIRY_PURCHASE_AIRTIME @"AirtimePurchaseInquiry"
#define TXN_CONFIRM_PURCHASE_AIRTIME @"AirtimePurchase"

#define TXN_INQUIRY_PAYMENT @"BillPayInquiry"
#define TXN_CONFIRM_PAYMENT @"BillPay"
#define TXN_INQUIRY_SELFBANK @"TransferInquiry"
#define TXN_INQUIRY_UANGKU @"TransferToUangkuInquiry"
#define TXN_CONFIRM_SELFBANK @"Transfer"
#define TXN_CONFIRM_UANGKU @"TransferToUangku"
#define TXN_INQUIRY_OTHERBANK @"InterBankTransferInquiry"
#define TXN_CONFIRM_OTHERBANK @"InterBankTransfer"
#define TXN_INQUIRY_CHANGEMPIN @"ChangePIN"
#define TXN_INQUIRY_ACTIVATION @"Activation"
#define TXN_ACCOUNT_BALANCE @"CheckBalance"
#define TXN_ACCOUNT_HISTORY @"History"
#define TXN_REGISTRATION @"GetRegistrationMedium"
#define TXN_RESENDOTP @"ResendOtp"
#define TXN_RESETPIN @"ResetPinByOTP"
#define TXN_REACTIVATION @"Reactivation" //SubscriberReactivation Reactivation
#define TXN_BILLINQUIRY @"BillInquiry"


/*
 * Image Keys
 */

#define ROOTVIEW_LOGIN @"RootView_Login"
#define ROOTVIEW_ACTIVATION @"RootView_Activation"

#define MAINMENU_PURCHASE @"MainMenu_Purchase"
#define MAINMENU_PAYMENT @"MainMenu_Payment"
#define MAINMENU_ACCOUNT @"MainMenu_Transfer"
#define MAINMENU_TRANSFER @"MainMenu_Account"

#define ACCOUNT_BALANCE @"Balance"
#define ACCOUNT_HISTORY @"Transaction"
#define ACCOUNT_CHANGEPIN @"Change mPin"
#define ACCOUNT_LANGUAGE @"Language"

#define TRANSFER_BANKSINARMAS @"Transfer_BankSinarmas"
#define TRANSFER_OTHERBANK @"Transfer_OtherBank"

#define SIMOBI_CONFIRM @"Confirm"
#define SIMOBI_CANCEL @"Cancel"
#define SIMOBI_OK @"OK"



/*
 * Text Keys
 */

#define PHONE @"phone"
#define MPIN @"mPin"
#define ACTIVATION__OTP @"activation_Otp"
#define ACTIVATION_REENTER_PIN @"activation_rePin"
#define TRANSFER_ACCOUNT @"transfer_Account"
#define TRANSFER_AMOUNT @"transfer_Amount"
#define TRANSFER_MPIN @"transfer_mPin"
#define CHANGEPIN_OLD_MPIN @"changePin_Oldpin"
#define CHANEPIN_NEW_MPIN @"changePin_Newpin"
#define CHANEPIN_REENTER_NEW_MPIN @"changePin_rePin"
#define LANGUAGE @"language"
#define PURCHASE @"purchase"
#define PAYMENT @"payment"
#define TRANSFER @"transfer"
#define ACCOUNT @"account"
#define PAYBYQR @"paybyQR"
#define TRANSFER_UANGKU_TITLE @"transferUangkuTitle"
#define ACTIVATION @"activation"
#define CHANGELANGUAGE @"changelanguage"
#define BALANCE @"balance"
#define TRANSACTION @"transaction"
#define CHANGEPIN @"changepin"
#define SELF_BANK @"selfBank"
#define TRANSFER_UANGKU @"transferUangku"
#define OTHER_BANK @"otherBank"
#define CONFIRM @"confirm"
#define SUBMIT @"submit"
#define CANCEL @"cancel"
#define NEXT @"next"

#define OKBUTTON @"OK"
#define CONTACTUS @"contactus"
#define PAYMENTCATEGORY @"paymentcategory"
#define BILLER @"biller"
#define PAYMENTPRODUCT @"paymnetproduct"
#define PURCHASECATEGORY @"purchasecategory"
#define PURCHASEPRODUCT @"purchaseproduct"
#define CONFIRMPIN @"confirmPIN"
#define NEWPIN @"newPIN"
#define RESET_MPIN_TITLE @"ResetMPIN"
#define REACTIVATION_TITLE @"Reactivation"

#define REQUEST_TIME_OUT_ERROR @"requestTimeOut"
#define REQUEST_TIME_OUT_ERROR_FINANCE @"financeRequestTimeOut"


/*
 * English Text
 */
#define ENGLISH_PHONENUMBER_TEXT @"Mobile Number"
#define ENGLISH_MPIN_TEXT @"mPIN"
#define ENGLISH_OTP_TEXT @"enter your verification code (OTP)"
#define ENGLISH_REENTER_MPIN_TEXT @"re-enter your mPIN"
#define ENGLISH_TRANSFER_ACCOUNT_TEXT @"Account Number"
#define ENGLISH_TRANSFER_AMOUNT_TEXT @"amount"
#define ENGLISH_TRANSFER_MPIN_TEXT @"mPIN"

#define ENGLISH_CHANGEPIN_OLDMPIN_TEXT @"Old mPIN"
#define ENGLISH_TRANSFER_NEWMPIN_TEXT @"New mPIN"
#define ENGLISH_TRANSFER_REENTER_MPIN_TEXT @"Confirm New mPIN"

#define ENGLISH_CHOSE_LANGUAGE_TEXT @"choose your language"
#define ENGLISH_PURCHASE_TEXT @"Purchase"
#define ENGLISH_PAYBYQR_TEXT @"Pay by QR"
#define ENGLISH_UANGKU_TEXT @"UANGKU"
#define ENGLISH_UANGKU_TITLE @"UANGKU"
#define ENGLISH_PAYMENT_TEXT @"Payment"
#define ENGLISH_TRANSFER_TEXT @"Transfer"
#define ENGLISH_ACCOUNT_TEXT @"Account"

#define ENGLISH_ACTIVATION_TEXT @"Activation"
#define ENGLISH_LANGUAGE_TEXT @"Language"
#define ENGLISH_BALNCE_TEXT @"Balance"
#define ENGLISH_TRANSACTION_TEXT @"History"
#define ENGLISH_CHANGEPIN_TEXT @"change mPIN"

#define ENGLISH_SELFBANK_TEXT @"Transfer"
#define ENGLISH_OTHERBANK_TEXT @"Other Bank"

#define ENGLISH_CONFIRM_TEXT @"Confirm"
#define ENGLISH_CANCEL_TEXT @"Cancel"
#define ENGLISH_SUBMIT_TEXT @"Next"
#define ENGLISH_OK_TEXT @"OK"
#define ENGLISH_NEXT_TEXT @"Next"

#define ENGLISH_CONTACTUS_TEXT @"Contact us"

#define ENGLISH_PURCHASE_CATEGORY_TEXT @"Prepaid Category"
#define ENGLISH_BILLER_TEXT @"Biller Name"
#define ENGLISH_PURCHASE_PRODUCT_TEXT @"Prepaid Type"
#define ENGLISH_PAYMENT_CATEGORY_TEXT @"Payment Category"
#define ENGLISH_PAYMENT_PRODUCT_TEXT @"Payment Type"

#define ENGLISH_CONFIRMPIN_TEXT @"Confirm New mPIN"

#define ENGLISH_NEWMPIN_TEXT @"New mPIN"

#define ENGLISH_RESET_PIN_TEXT @"Activation"

#define ENGLISH_REACTIVATION_TEXT @"Reactivation"



#define ENGLISH_TIME_OUT_ERROR @"Dear customer, currently you are not connected to Bank Sinarmas server. Please try again later."
#define ENGLISH_TIME_OUT_ERROR_FINANCE @"Please wait while your transaction is being processed. Please check your transaction history to see this transaction status."

#define ENGLISH_SIX_DIGIT_LOGIN @"mPIN should be 6 digits. If your mPIN is less than 6 digits, please change your mPIN to 6 digit at the nearest Bank Sinarmas ATM"

#define ENGLISH_SIX_DIGIT_ACTIVATION @"mPIN should be 6 digits"
#define ENGLISH_FILL_PHONE_NUMBER @"Please provide phone number"
#define ENGLISH_FILL_MPIN @"Silakan masukkan Nomor HP Anda"
/*
 *Bahasa Text
 */

#define BAHASA_PHONENUMBER_TEXT @"Nomor Handphone"
#define BAHASA_MPIN_TEXT @"mPIN"
#define BAHASA_OTP_TEXT @"masukkan kode verifikasi (OTP)"
#define BAHASA_REENTER_MPIN_TEXT @"masukkan kembali mPIN baru anda"
#define BAHASA_TRANSFER_ACCOUNT_TEXT @"Nomor Rekening"
#define BAHASA_TRANSFER_AMOUNT_TEXT @"jumlah"
#define BAHASA_TRANSFER_MPIN_TEXT @"mPIN"

#define BAHASA_CHANGEPIN_OLDMPIN_TEXT @"mPIN Lama"
#define BAHASA_TRANSFER_NEWMPIN_TEXT @"mPIN Baru"
#define BAHASA_TRANSFER_REENTER_MPIN_TEXT @"Konfirmasi mPIN Baru"

#define BAHASA_CHOOSELANGUAGE_TEXT @"pilih bahasa"
#define BAHASA_PURCHASE_TEXT @"Pembelian"
#define BAHASA_PAYBYQR_TEXT @"Bayar Pakai QR"
#define BAHASA_TRANSFER_UANGKU_TEXT @"UANGKU"
#define BAHASA_TRANSFER_UANGKU_TITLE @"UANGKU"
#define BAHASA_PAYMENT_TEXT @"Pembayaran"
#define BAHASA_TRANSFER_TEXT @"Transfer"
#define BAHASA_ACCOUNT_TEXT @"Rekening"

#define BAHASA_ACTIVATION_TEXT @"Aktivasi"
#define BAHASA_LANGUAGE_TEXT @"Bahasa"
#define BAHASA_BALNCE_TEXT @"Saldo"
#define BAHASA_TRANSACTION_TEXT @"Transaksi"
#define BAHASA_CHANGEPIN_TEXT @"ganti mPIN"

#define BAHASA_SELFBANK_TEXT @"Transfer"
#define BAHASA_OTHERBANK_TEXT @"Bank Lain"

#define BAHASA_CONFIRM_TEXT @"Konfirmasi"
#define BAHASA_CANCEL_TEXT @"Batal"
#define BAHASA_SUBMIT_TEXT @"Lanjut"
#define BAHASA_OK_TEXT @"OK"
#define BAHASA_NEXT_TEXT @"Lanjut"

#define BAHASA_CONTCTUS_TEXT @"Hubungi Kami"

#define BAHASA_PURCHASE_CATEGORY_TEXT @"Kategori Prabayar"
#define BAHASA_BILLER_TEXT @"Nama Biller"
#define BAHASA_PURCHASE_PRODUCT_TEXT @"Tipe Prabayar"
#define BAHASA_PAYMENT_CATEGORY_TEXT @"Kategori Pembayaran"
#define BAHASA_PAYMENT_PRODUCT_TEXT @"Jenis Pembayaran"

#define BAHASA_CONFIRMPIN_TEXT @"Konfirmasi mPIN"
#define BAHASA_NEWMPIN_TEXT @"mPIN Baru"

#define BAHASA_RESET_PIN_TEXT @"Aktivasi"

#define BAHASA_REACTIVATION_TEXT @"Aktivasi Ulang"


#define BAHASA_TIME_OUT_ERROR @"Nasabah yang terhormat, saat ini tidak dapat terhubung dengan server Bank Sinarmas. Silahkan coba lagi nanti."
#define BAHASA_TIME_OUT_ERROR_FINANCE @"Mohon menunggu, transaksi Anda sedang dalam proses. Periksa riwayat transaksi untuk mengetahui status transaksi Anda"

#define BAHASA_SIX_DIGIT_LOGIN @"Panjang mPIN harus 6 digit. Apabila mPIN Anda kurang dari 6 digit, silahkan ubah dahulu mPIN Anda menjadi 6 digit di ATM Bank Sinarmas terdekat"
#define BAHASA_SIX_DIGIT_ACTIVATION @"Panjang mPIN harus 6 digit"
#define BAHASA_FILL_PHONE_NUMBER @"Silakan masukkan Nomor HP Anda"
#define BAHASA_FILL_MPIN @"Silakan masukkan mPIN Anda"

#define EULAMESSAGE @"Term and condition M-Bank Sinarmas Services\nArticle 1: Definition\nUnless defined otherwise, by:\n1.1. M-Bank Sinarmas shall mean e-banking service to carry out the financial and non-financial transactions with clearer menu display where the application shall be downloaded firstly by using cellular phone handset/tablet computer as well as 3G/GPRS/WIFI technology.\n1.2 Bank shall mean PT. Sinarmas (Persero) Tbk, having its domicile and head office in Jakarta\n1.3 3G/GPRS/WIFI Technology shall mean the data package delivery and receive technology made available by the cellular network/telecommunication service provider.\n1.4 Customer shall mean individual owner of Bank Sinarmas ATM card.\n1.5 M-Bank Sinarmas service can be linked to Bank Sinarmas saving account or Bank Sinarmas current account with currency IDR.\nArticle 2: Terms of Simobi Bank Sinarmas registration\n2.1. Already having Bank Sinarmas giro account or Bank Sinarmas savings account.\n2.2. Customer must do Simobi Bank Sinarmas Registration from Bank Sinarmas office or ATM Bank Sinarmas. Once registration successful, customer will received sms with 8 digit OTP (one time password) to be used for activation.\n2.3. Simobi Bank Sinarmas application service can be downloaded from www.banksinarmas.com\n2.4. Have read and accepting the Terms and Conditions of Simobi Bank Sinarmas.\nArticle 3: Conditions of Simobi Bank Sinarmas Use\n3.1  Customer must do activation prior to be able using the Simobi Bank Sinarmas services.\n3.2  The Customer may use Simobi Bank Sinarmas service to obtain information or carry out banking transaction already determined.\n3.3  Simobi Bank Sinarmas service can be used by registering all cellular telephone available in Indonesia.\n3.4  Simobi Bank Sinarmas service can only be used in 1 cellular telephone number (MSISDN) for one account.\n3.5  For all financial transaction from Simobi Bank Sinarmas will be challenged and authenticated by mPIN.\n3.6  Simobi Bank Sinarmas mPIN is created while activation process by customer.\n3.7  When implementing the transaction, the Customer shall:\n• Ensure the completeness and correctness of data on transaction mentioned. All consequences arising from the default, incompleteness and or error by the Customer shall fully become the Customer’s responsibility.\n• Enter Simobi Bank Sinarmas mPIN while making transaction.\n3.8  Every instruction provided by the Customer through Simobi Bank Sinarmas service cannot be canceled.\n3.9  Every instruction already provided by the Customer according to the Terms & Conditions of this service shall be valid proof, unless proven otherwise and the Bank has no obligation to examine such validity.\n3.10  The Bank shall be entitled to neglect the Customer's instruction, if:\na. Balance in Customer's account is insufficient.\nb. There is indication of crime.\n3.11  All consequences arising as the consequence of the abuse of Simobi Bank Sinarmas shall become full responsibility of the Customer and the Customer hereby keeps harmless the Bank from all claims potentially arising in any terms and from any parties.\n3.12 As the proof of transaction implementation, the Customer will obtain the transaction number proof at every end of transaction via SMS, as long as the Customer's cellular phone message box still allows or there is no communication network interference. \n3.13 At its own consideration, the Bank shall be entitled to change the transaction limit. Such change shall bind the Customer sufficiently by the notification according to the prevailing provisions.\nArticle 4: Simobi Bank Sinarmas password\n4.1  The Customer shall secure his mPIN. In this respect, the Customer shall not:\na. Notify the mPIN to the others;\nb. Save mPIN in the cellular telephone memory or other saving facilities allowing the other parties to know it;\nThe Customer shall also replace the mPIN periodically.\n4.2  All consequences arising due to the abuse of mPIN shall fully become the Customer’s responsibility and the Customer hereby keeps harmless the Bank from all claims potentially arising in any terms and from any parties.\n4.3  If the Customer wrongly enters the mPIN for 3 (three) times consecutively, then the application will be automatically blocked. To reactivate such application, the Customer shall visit the provided Bank Sinarmas office or ATM to do mPIN reset.\nArticle 5: Cessation of Access to Simobi Bank Sinarmas service\n5.1  Simobi Bank Sinarmas service will be ceased by the Bank if:\na. There is written request from the Customer.\nb. The customer closes all accounts accessible via Simobi Bank Sinarmas service.\nc. Obliged by the prevailing legislation and or court’s judgment.\nArticle 6: Miscellany\nFor the problem relating to cellular phone number, GPRS/3G network, invoice for use of GPRS/3G, SMS charge, and value added service of GPRS/3G, the Customer shall directly contact the operator of the relevant GPRS/3G cellular mobile network/ telecommunication service. While for the problem on service, the Customer may contact the Bank Sinarmas CARE 500 153.\nThe Bank may change these Terms and Conditions according to the need. The change will be binding to the Customer sufficiently by notification according to the provisions applicable to the Bank.\nThe Customer shall comply with the terms applicable to the Bank including but not limited to the General Conditions of Account Opening, Special Conditions of Giro Account Opening, or Special Conditions of Savings Account Opening.\nThe powers of attorney granted relating to this service shall be a valid power of attorney that will not expire as long as the Customer still uses Simobi Bank Sinarmas service or there is still other obligation of the Customer to the bank.\nThe Customer shall keep harmless the Bank from all claims, in case the Bank fails to implement the Customer’s instruction partly or entirely due to any events or causes beyond the control or capability of the Bank such as computer virus interference, web browser, dysfunction system or transmission, electricity failure, telecommunication failure or government policy, as well as any other events or causes beyond the control or capability of the Bank."

#import <DIMOPayiOS/DIMOPayiOS.h>
/****************************************************************************************/
//115.112.108.203:8443
//simobi.banksinarmas.com
//dev.simobi.banksinarmas.com
//175.101.5.69:8443


//  ##########################      DEV   ##########################
/*
        #define SIMOBI_URL @"https://175.101.5.70:8443/webapi/sdynamic?channelID=7&"
        #define SIMOBI_PUBLICKEY_ACCESS_URL @"https://175.101.5.70:8443/webapi/sdynamic?channelID=7&service=Account&sourceMDN=null&sourcePIN=null&txnName=GetPublicKey"
        #define SIMOBI_BANKCODE_DATA_URL @"https://175.101.5.70:8443/webapi/sdynamic?category=category.bankCodes&channelID=7&service=Payment&txnName=GetThirdPartyData&version=-1"
        #define SIMOBI_PAYMENT_DATA_URL @"https://175.101.5.70:8443/webapi/sdynamic?category=category.payments&channelID=7&service=Payment&txnName=GetThirdPartyData&version=-1"
        #define SIMOBI_PURCHASE_DATA_URL @"https://175.101.5.70:8443/webapi/sdynamic?category=category.purchase&channelID=7&service=Payment&txnName=GetThirdPartyData&version=-1"
 #define FLASHiZ_SERVER  ServerURLDev
 */

//  ##########################      QA   ##########################

/*
#define SIMOBI_URL @"https://175.101.5.70:8443/webapi/sdynamic?channelID=7&"
#define SIMOBI_PUBLICKEY_ACCESS_URL @"https://175.101.5.70:8443/webapi/sdynamic?channelID=7&service=Account&sourceMDN=null&sourcePIN=null&txnName=GetPublicKey"
#define SIMOBI_BANKCODE_DATA_URL @"https://175.101.5.70:8443/webapi/sdynamic?category=category.bankCodes&channelID=7&service=Payment&txnName=GetThirdPartyData&version=-1"
#define SIMOBI_PAYMENT_DATA_URL @"https://175.101.5.70:8443/webapi/sdynamic?category=category.payments&channelID=7&service=Payment&txnName=GetThirdPartyData&version=-1"
#define SIMOBI_PURCHASE_DATA_URL @"https://175.101.5.70:8443/webapi/sdynamic?category=category.purchase&channelID=7&service=Payment&txnName=GetThirdPartyData&version=-1"
#define FLASHiZ_SERVER  ServerURLDev
*/

//  ##########################      UAT   ##########################

/*
        #define SIMOBI_URL @"https://dev.simobi.banksinarmas.com/webapi/sdynamic?channelID=7&"
        #define SIMOBI_PUBLICKEY_ACCESS_URL @"https://dev.simobi.banksinarmas.com/webapi/sdynamic?channelID=7&service=Account&sourceMDN=null&sourcePIN=null&txnName=GetPublicKey"
        #define SIMOBI_BANKCODE_DATA_URL @"https://dev.simobi.banksinarmas.com/webapi/sdynamic?category=category.bankCodes&channelID=7&service=Payment&txnName=GetThirdPartyData&version=-1"
        #define SIMOBI_PAYMENT_DATA_URL @"https://dev.simobi.banksinarmas.com/webapi/sdynamic?category=category.payments&channelID=7&service=Payment&txnName=GetThirdPartyData&version=-1"
        #define SIMOBI_PURCHASE_DATA_URL @"https://dev.simobi.banksinarmas.com/webapi/sdynamic?category=category.purchase&channelID=7&service=Payment&txnName=GetThirdPartyData&version=-1"
 
 #define FLASHiZ_SERVER  ServerURLDev
*/

//  ##########################      STAGING   ##########################
 
/*
 #define SIMOBI_URL @"https://staging.dimo.co.id:8470/webapi/sdynamic?channelID=7&"
 #define SIMOBI_PUBLICKEY_ACCESS_URL @"https://staging.dimo.co.id:8470/webapi/sdynamic?channelID=7&service=Account&sourceMDN=null&sourcePIN=null&txnName=GetPublicKey"
 #define SIMOBI_BANKCODE_DATA_URL @"https://staging.dimo.co.id:8470/webapi/sdynamic?category=category.bankCodes&channelID=7&service=Payment&txnName=GetThirdPartyData&version=-1"
 #define SIMOBI_PAYMENT_DATA_URL @"https://staging.dimo.co.id:8470/webapi/sdynamic?category=category.payments&channelID=7&service=Payment&txnName=GetThirdPartyData&version=-1"
 #define SIMOBI_PURCHASE_DATA_URL @"https://staging.dimo.co.id:8470/webapi/sdynamic?category=category.purchase&channelID=7&service=Payment&txnName=GetThirdPartyData&version=-1"
 #define FLASHiZ_SERVER  ServerURLDev
*/

//  ##########################      PROD   ##########################
 /*       #define SIMOBI_URL @"https:simobi.banksinarmas.com/webapi/sdynamic?channelID=7&"
        #define SIMOBI_PUBLICKEY_ACCESS_URL @"https:simobi.banksinarmas.com/webapi/sdynamic?channelID=7&service=Account&sourceMDN=null&sourcePIN=null&txnName=GetPublicKey"
        #define SIMOBI_BANKCODE_DATA_URL @"http:simobi.banksinarmas.com/webapi/dynamic?category=category.bankCodes&channelID=7&service=Payment&txnName=GetThirdPartyData&version=-1"
        #define SIMOBI_PAYMENT_DATA_URL @"http:simobi.banksinarmas.com/webapi/dynamic?category=category.payments&channelID=7&service=Payment&txnName=GetThirdPartyData&version=-1"
        #define SIMOBI_PURCHASE_DATA_URL @"http:simobi.banksinarmas.com/webapi/dynamic?category=category.purchase&channelID=7&service=Payment&txnName=GetThirdPartyData&version=-1"
        #define FLASHiZ_SERVER  ServerURLLive
  */


// ##########################      local   ##########################
/*
#define SIMOBI_URL @"https:192.168.0.18:8443/webapi/sdynamic?channelID=7&"
#define SIMOBI_PUBLICKEY_ACCESS_URL @"https:192.168.0.18:8443/webapi/sdynamic?channelID=7&service=Account&sourceMDN=null&sourcePIN=null&txnName=GetPublicKey"
#define SIMOBI_BANKCODE_DATA_URL @"http:192.168.0.18:8443/webapi/dynamic?category=category.bankCodes&channelID=7&service=Payment&txnName=GetThirdPartyData&version=-1"
#define SIMOBI_PAYMENT_DATA_URL @"http:192.168.0.18:8443/webapi/dynamic?category=category.payments&channelID=7&service=Payment&txnName=GetThirdPartyData&version=-1"
#define SIMOBI_PURCHASE_DATA_URL @"http:192.168.0.18:8443/webapi/dynamic?category=category.purchase&channelID=7&service=Payment&txnName=GetThirdPartyData&version=-1"
#define FLASHiZ_SERVER  ServerURLLive
  */

// ##########################  UAT BSIM   ##########################

#define SIMOBI_URL @"https:10.32.3.65:8443/webapi/sdynamic?channelID=7&"
#define SIMOBI_PUBLICKEY_ACCESS_URL @"https:10.32.3.65:8443/webapi/sdynamic?channelID=7&service=Account&sourceMDN=null&sourcePIN=null&txnName=GetPublicKey"
#define SIMOBI_BANKCODE_DATA_URL @"https:10.32.3.65:8443/webapi/dynamic?category=category.bankCodes&channelID=7&service=Payment&txnName=GetThirdPartyData&version=-1"
#define SIMOBI_PAYMENT_DATA_URL @"hhttps:10.32.3.65:8443/webapi/dynamic?category=category.payments&channelID=7&service=Payment&txnName=GetThirdPartyData&version=-1"
#define SIMOBI_PURCHASE_DATA_URL @"https:10.32.3.65:8443/webapi/dynamic?category=category.purchase&channelID=7&service=Payment&txnName=GetThirdPartyData&version=-1"
#define FLASHiZ_SERVER  ServerURLDev



#endif
