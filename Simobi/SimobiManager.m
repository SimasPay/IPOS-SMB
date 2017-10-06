//
//  SimobiSharedManager.m
//  Simobi
//
//  Created by Ravi on 10/9/13.
//  Copyright (c) 2013 Mfino. All rights reserved.
//

#import "SimobiManager.h"
#import "SimobiConstants.h"


/*
 * Macro for setting Key and Value to respective Dictionary
 */

#define ENGLISH_TEXT(value,key)   {[self.englishTextDict setObject:value forKey:key];}
#define BAHASA_TEXT(value,key)    {[self.bahasaTextDict setObject:value forKey:key];}


             ////////////////////Settingup Text Data////////////////////////

static NSString *const englishText [] = {ENGLISH_PHONENUMBER_TEXT,ENGLISH_MPIN_TEXT,ENGLISH_OTP_TEXT,ENGLISH_REENTER_MPIN_TEXT,ENGLISH_TRANSFER_ACCOUNT_TEXT,ENGLISH_TRANSFER_AMOUNT_TEXT,ENGLISH_TRANSFER_MPIN_TEXT,ENGLISH_CHANGEPIN_OLDMPIN_TEXT,ENGLISH_TRANSFER_NEWMPIN_TEXT,ENGLISH_TRANSFER_REENTER_MPIN_TEXT,ENGLISH_LANGUAGE_TEXT,ENGLISH_PURCHASE_TEXT,ENGLISH_PAYMENT_TEXT,ENGLISH_TRANSFER_TEXT,ENGLISH_ACCOUNT_TEXT,ENGLISH_ACTIVATION_TEXT,ENGLISH_LANGUAGE_TEXT,ENGLISH_BALNCE_TEXT,ENGLISH_TRANSACTION_TEXT,ENGLISH_CHANGEPIN_TEXT,ENGLISH_SELFBANK_TEXT,ENGLISH_OTHERBANK_TEXT,ENGLISH_CONFIRM_TEXT,ENGLISH_CANCEL_TEXT,ENGLISH_SUBMIT_TEXT,ENGLISH_OK_TEXT,ENGLISH_CONTACTUS_TEXT,ENGLISH_PURCHASE_CATEGORY_TEXT,ENGLISH_PURCHASE_PRODUCT_TEXT,ENGLISH_BILLER_TEXT,ENGLISH_PAYMENT_CATEGORY_TEXT,ENGLISH_PAYMENT_PRODUCT_TEXT,ENGLISH_NEWMPIN_TEXT,ENGLISH_CONFIRMPIN_TEXT,ENGLISH_NEXT_TEXT,ENGLISH_TIME_OUT_ERROR,ENGLISH_RESET_PIN_TEXT,ENGLISH_REACTIVATION_TEXT,ENGLISH_TIME_OUT_ERROR_FINANCE,ENGLISH_PAYBYQR_TEXT,ENGLISH_UANGKU_TEXT,ENGLISH_UANGKU_TITLE};

static NSString *const textKeys [] = {PHONE,MPIN,ACTIVATION__OTP,ACTIVATION_REENTER_PIN,TRANSFER_ACCOUNT,TRANSFER_AMOUNT,TRANSFER_MPIN,CHANGEPIN_OLD_MPIN,CHANEPIN_NEW_MPIN,CHANEPIN_REENTER_NEW_MPIN,LANGUAGE,PURCHASE,PAYMENT,TRANSFER,ACCOUNT,ACTIVATION,CHANGELANGUAGE,BALANCE,TRANSACTION,CHANGEPIN,SELF_BANK, OTHER_BANK,CONFIRM,CANCEL,SUBMIT,OKBUTTON,CONTACTUS,PURCHASECATEGORY,PURCHASEPRODUCT,BILLER,PAYMENTCATEGORY,PAYMENTPRODUCT,NEWPIN,CONFIRMPIN,NEXT,REQUEST_TIME_OUT_ERROR,RESET_MPIN_TITLE,REACTIVATION_TITLE,REQUEST_TIME_OUT_ERROR_FINANCE,PAYBYQR,TRANSFER_UANGKU,TRANSFER_UANGKU_TITLE};

static NSString *const bahasaText [] = {BAHASA_PHONENUMBER_TEXT,BAHASA_MPIN_TEXT,BAHASA_OTP_TEXT,BAHASA_REENTER_MPIN_TEXT,BAHASA_TRANSFER_ACCOUNT_TEXT,BAHASA_TRANSFER_AMOUNT_TEXT,BAHASA_TRANSFER_MPIN_TEXT,BAHASA_CHANGEPIN_OLDMPIN_TEXT,BAHASA_TRANSFER_NEWMPIN_TEXT,BAHASA_TRANSFER_REENTER_MPIN_TEXT,BAHASA_LANGUAGE_TEXT,BAHASA_PURCHASE_TEXT,BAHASA_PAYMENT_TEXT,BAHASA_TRANSFER_TEXT,BAHASA_ACCOUNT_TEXT,BAHASA_ACTIVATION_TEXT,BAHASA_LANGUAGE_TEXT,BAHASA_BALNCE_TEXT,BAHASA_TRANSACTION_TEXT,BAHASA_CHANGEPIN_TEXT,BAHASA_SELFBANK_TEXT,BAHASA_OTHERBANK_TEXT,BAHASA_CONFIRM_TEXT,BAHASA_CANCEL_TEXT,BAHASA_SUBMIT_TEXT,BAHASA_OK_TEXT,BAHASA_CONTCTUS_TEXT,BAHASA_PURCHASE_CATEGORY_TEXT,BAHASA_PURCHASE_PRODUCT_TEXT,BAHASA_BILLER_TEXT,BAHASA_PAYMENT_CATEGORY_TEXT,BAHASA_PAYMENT_PRODUCT_TEXT,BAHASA_NEWMPIN_TEXT,BAHASA_CONFIRMPIN_TEXT,BAHASA_NEXT_TEXT,BAHASA_TIME_OUT_ERROR,BAHASA_RESET_PIN_TEXT,BAHASA_REACTIVATION_TEXT,BAHASA_TIME_OUT_ERROR_FINANCE,BAHASA_PAYBYQR_TEXT,BAHASA_TRANSFER_UANGKU_TEXT,BAHASA_TRANSFER_UANGKU_TITLE};

@interface SimobiManager ()

@property (nonatomic,strong) NSMutableDictionary *englishTextDict;
@property (nonatomic,strong) NSMutableDictionary *bahasaTextDict;

@end

@implementation SimobiManager
@synthesize public_KEY;
@synthesize sourceMDN,sourcePIN,publicKeyDict;
@synthesize englishTextDict,bahasaTextDict;
@synthesize language;
@synthesize pIN;


+ (id)shareInstance{
    static SimobiManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}


- (void)setUpTextDataForEnglish
{

    self.englishTextDict = [NSMutableDictionary dictionaryWithCapacity:0];
   
    ENGLISH_TEXT(englishText[0],  textKeys[0]);
    ENGLISH_TEXT(englishText[1],  textKeys[1]);
    ENGLISH_TEXT(englishText[2],  textKeys[2]);
    ENGLISH_TEXT(englishText[3],  textKeys[3]);
    ENGLISH_TEXT(englishText[4],  textKeys[4]);
    ENGLISH_TEXT(englishText[5],  textKeys[5]);
    ENGLISH_TEXT(englishText[6],  textKeys[6]);
    ENGLISH_TEXT(englishText[7],  textKeys[7]);
    ENGLISH_TEXT(englishText[8],  textKeys[8]);
    ENGLISH_TEXT(englishText[9],  textKeys[9]);
    ENGLISH_TEXT(englishText[10], textKeys[10]);
    ENGLISH_TEXT(englishText[11], textKeys[11]);
    ENGLISH_TEXT(englishText[12], textKeys[12]);
    ENGLISH_TEXT(englishText[13], textKeys[13]);
    ENGLISH_TEXT(englishText[14], textKeys[14]);
    ENGLISH_TEXT(englishText[15], textKeys[15]);
    ENGLISH_TEXT(englishText[16], textKeys[16]);
    ENGLISH_TEXT(englishText[17], textKeys[17]);
    ENGLISH_TEXT(englishText[18], textKeys[18]);
    ENGLISH_TEXT(englishText[19], textKeys[19]);
    ENGLISH_TEXT(englishText[20], textKeys[20]);
    ENGLISH_TEXT(englishText[21], textKeys[21]);
    ENGLISH_TEXT(englishText[22], textKeys[22]);
    ENGLISH_TEXT(englishText[23], textKeys[23]);
    ENGLISH_TEXT(englishText[24], textKeys[24]);
    ENGLISH_TEXT(englishText[25], textKeys[25]);
    ENGLISH_TEXT(englishText[26], textKeys[26]);
    ENGLISH_TEXT(englishText[27], textKeys[27]);
    ENGLISH_TEXT(englishText[28], textKeys[28]);
    ENGLISH_TEXT(englishText[29], textKeys[29]);
    ENGLISH_TEXT(englishText[30], textKeys[30]);
    ENGLISH_TEXT(englishText[31], textKeys[31]);
    ENGLISH_TEXT(englishText[32], textKeys[32]);
    ENGLISH_TEXT(englishText[33], textKeys[33]);
    ENGLISH_TEXT(englishText[34], textKeys[34]);
    ENGLISH_TEXT(englishText[35], textKeys[35]);
    ENGLISH_TEXT(englishText[36], textKeys[36]);
    ENGLISH_TEXT(englishText[37], textKeys[37]);
    ENGLISH_TEXT(englishText[38], textKeys[38]);
    ENGLISH_TEXT(englishText[39], textKeys[39]);
    ENGLISH_TEXT(englishText[40], textKeys[40]);
    ENGLISH_TEXT(englishText[41], textKeys[41]);

}

- (void)setUpTextDataForBahasa
{
    
    self.bahasaTextDict = [NSMutableDictionary dictionaryWithCapacity:0];

    BAHASA_TEXT(bahasaText[0],  textKeys[0]);
    BAHASA_TEXT(bahasaText[1],  textKeys[1]);
    BAHASA_TEXT(bahasaText[2],  textKeys[2]);
    BAHASA_TEXT(bahasaText[3],  textKeys[3]);
    BAHASA_TEXT(bahasaText[4],  textKeys[4]);
    BAHASA_TEXT(bahasaText[5],  textKeys[5]);
    BAHASA_TEXT(bahasaText[6],  textKeys[6]);
    BAHASA_TEXT(bahasaText[7],  textKeys[7]);
    BAHASA_TEXT(bahasaText[8],  textKeys[8]);
    BAHASA_TEXT(bahasaText[9],  textKeys[9]);
    BAHASA_TEXT(bahasaText[10], textKeys[10]);
    BAHASA_TEXT(bahasaText[11], textKeys[11]);
    BAHASA_TEXT(bahasaText[12], textKeys[12]);
    BAHASA_TEXT(bahasaText[13], textKeys[13]);
    BAHASA_TEXT(bahasaText[14], textKeys[14]);
    BAHASA_TEXT(bahasaText[15], textKeys[15]);
    BAHASA_TEXT(bahasaText[16], textKeys[16]);
    BAHASA_TEXT(bahasaText[17], textKeys[17]);
    BAHASA_TEXT(bahasaText[18], textKeys[18]);
    BAHASA_TEXT(bahasaText[19], textKeys[19]);
    BAHASA_TEXT(bahasaText[20], textKeys[20]);
    BAHASA_TEXT(bahasaText[21], textKeys[21]);
    BAHASA_TEXT(bahasaText[22], textKeys[22]);
    BAHASA_TEXT(bahasaText[23], textKeys[23]);
    BAHASA_TEXT(bahasaText[24], textKeys[24]);
    BAHASA_TEXT(bahasaText[25], textKeys[25]);
    BAHASA_TEXT(bahasaText[26], textKeys[26]);
    BAHASA_TEXT(bahasaText[27], textKeys[27]);
    BAHASA_TEXT(bahasaText[28], textKeys[28]);
    BAHASA_TEXT(bahasaText[29], textKeys[29]);
    BAHASA_TEXT(bahasaText[30], textKeys[30]);
    BAHASA_TEXT(bahasaText[31], textKeys[31]);
    BAHASA_TEXT(bahasaText[32], textKeys[32]);
    BAHASA_TEXT(bahasaText[33], textKeys[33]);
    BAHASA_TEXT(bahasaText[34], textKeys[34]);
    BAHASA_TEXT(bahasaText[35], textKeys[35]);
    BAHASA_TEXT(bahasaText[36], textKeys[36]);
    BAHASA_TEXT(bahasaText[36], textKeys[37]);
    BAHASA_TEXT(bahasaText[38], textKeys[38]);
    BAHASA_TEXT(bahasaText[39], textKeys[39]);
    BAHASA_TEXT(bahasaText[40], textKeys[40]);
    BAHASA_TEXT(bahasaText[41], textKeys[41]);

}

- (NSDictionary *)textDataForLanguage
{
    NSDictionary *temp = ([language isEqualToString:SIMOBI_LANGUAGE_ENGLISH]) ? self.englishTextDict : self.bahasaTextDict;
    
    NSMutableDictionary *result = [@{} mutableCopy];
    for (NSString *key in temp.allKeys) {
        NSString *value = temp[key];
        value = [value stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                               withString:[[value substringToIndex:1] capitalizedString]];
        value = [value stringByReplacingOccurrencesOfString:@"anda" withString:@"Anda"];
        value = [value stringByReplacingOccurrencesOfString:@"MPIN" withString:@"mPIN"];
        [result setObject:value forKey:key];
    }
    return result;
}


- (id)init
{
    if (self = [super init]) {
        
        //Add Variables
        self.responseData = [[NSMutableDictionary alloc] initWithCapacity:0];
        [self setUpTextDataForBahasa];
        [self setUpTextDataForEnglish];
    }
    return self;

}
@end
