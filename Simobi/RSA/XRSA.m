#import "XRSA.h"
#import "BasicEncodingRules.h"
#import "NSData+Base64Extention.h"
#import "SimobiConstants.h"


#define PEER_TAG @"Simobi Public Key"

@implementation XRSA


- (XRSA *)initWithPublicKeyModulus:(NSString *)modulus withPublicKeyExponent:(NSString *)exponent

{
    self = [super init];
    
    if (self) {
        
        
        if (nil == modulus || nil == exponent)
            return nil;
        
        publicKey = [XRSA createCertificateWithPublicKeyModulus:modulus withPublicKeyExponent:exponent];
        
        maxPlainLen = SecKeyGetBlockSize(publicKey) - 12;
        
        CONDITIONLOG(DEBUG_MODE,@" publicKey : %@",publicKey);
        
    }
    
    return self;
}



- (NSData *) encryptWithData:(NSData *)content {
    
    size_t plainLen = [content length];
    if (plainLen > maxPlainLen) {
        //CONDITIONLOG(DEBUG_MODE,@"content(%ld) is too long, must < %ld", plainLen, maxPlainLen);
        return nil;
    }
    
    void *plain = malloc(plainLen);
    [content getBytes:plain
               length:plainLen];
    
    size_t cipherLen = 512; // currently RSA key length is set to 128 bytes
    void *cipher = malloc(cipherLen);
    
    OSStatus returnCode = SecKeyEncrypt(publicKey, kSecPaddingPKCS1, plain,
                                        plainLen, cipher, &cipherLen);
    
    NSData *result = nil;
    if (returnCode != 0) {
        //CONDITIONLOG(DEBUG_MODE,@"SecKeyEncrypt fail. Error Code: %ld", returnCode);
    }
    else {
        result = [NSData dataWithBytes:cipher
                                length:cipherLen];
    }
    
    free(plain);
    free(cipher);
    
    return result;
}

- (NSData *) encryptWithString:(NSString *)content {
    return [self encryptWithData:[content dataUsingEncoding:NSUTF8StringEncoding]];
}

- (NSString *) encryptToString:(NSString *)content {
    NSData *data = [self encryptWithString:content];
    
    return [data dataToHexString];
}



+(NSData *)stringasdata:(NSString *)command
{
    command = [command stringByReplacingOccurrencesOfString:@" " withString:@""];
    command = [command stringByReplacingOccurrencesOfString:@"<" withString:@""];
    command = [command stringByReplacingOccurrencesOfString:@">" withString:@""];
    //CONDITIONLOG(DEBUG_MODE,@"command= %@",command);
    NSMutableData *commandToSend= [[NSMutableData alloc] init]; unsigned char whole_byte;
    int len = [command length];
    int n = len/2;
    char byte_chars[3] = {'\0','\0','\0'}; int i;
    for (i=0; i < n; i++) {
        byte_chars[0] = [command characterAtIndex:i*2]; byte_chars[1] = [command         characterAtIndex:i*2+1]; whole_byte = strtol(byte_chars, NULL, 16); [commandToSend appendBytes:&whole_byte length:1];
    }
    // [commandToSend setLength:[commandToSend length]-1];
    return commandToSend;
    
}

+ (SecKeyRef)createCertificateWithPublicKeyModulus:(NSString *)modulus withPublicKeyExponent:(NSString *)exponent
{
    NSMutableArray *testArray = [[NSMutableArray alloc] init];
    [testArray addObject:[XRSA stringasdata:modulus]];
    [testArray addObject:[XRSA stringasdata:exponent]];
    NSData *dummyData = [testArray berData];
    NSMutableArray *testArray2 = [dummyData berDecode];
    NSData *pubKeyData = [testArray2 berData];
    
    
    OSStatus sanityCheck = noErr;
    SecKeyRef publicKeyReference = NULL;
    
    NSString * peerName = @"Simobi Public Key";
    
    NSData * peerTag =
    [[NSData alloc]
     initWithBytes:(const void *)[peerName UTF8String]
     length:[peerName length]];
    
    NSMutableDictionary * peerPublicKeyAttr = [[NSMutableDictionary alloc] init];
    
    [peerPublicKeyAttr
     setObject:(__bridge id)kSecClassKey
     forKey:(__bridge id)kSecClass];
    [peerPublicKeyAttr
     setObject:(__bridge id)kSecAttrKeyTypeRSA
     forKey:(__bridge id)kSecAttrKeyType];
    [peerPublicKeyAttr
     setObject:peerTag
     forKey:(__bridge id)kSecAttrApplicationTag];
    [peerPublicKeyAttr
     setObject:pubKeyData
     forKey:(__bridge id)kSecValueData];
    [peerPublicKeyAttr
     setObject:[NSNumber numberWithBool:YES]
     forKey:(__bridge id)kSecReturnPersistentRef];
    
    sanityCheck = SecItemAdd((__bridge CFDictionaryRef) peerPublicKeyAttr, (CFTypeRef *)&publicKeyReference);
    
    
    SecKeyRef rsapublicKey = NULL;
    
    NSData * publicTag = [NSData dataWithBytes:[peerName cStringUsingEncoding:NSUTF8StringEncoding]
                                        length:[peerName length]];
    
    NSMutableDictionary *queryPublicKey =
    [[NSMutableDictionary alloc] init];
    
    [queryPublicKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [queryPublicKey setObject:publicTag forKey:(__bridge id)kSecAttrApplicationTag];
    [queryPublicKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [queryPublicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    
    OSStatus status = SecItemCopyMatching
    ((__bridge CFDictionaryRef)queryPublicKey, (CFTypeRef *)&rsapublicKey);
    
    if (status != noErr) {
        
        
        CONDITIONLOG(DEBUG_MODE,@"Bla Bla");
        return nil;
    }
    
    return rsapublicKey;
    
    
}

@end
