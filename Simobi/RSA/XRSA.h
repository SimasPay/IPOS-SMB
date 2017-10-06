#import <Foundation/Foundation.h>
#import <Security/Security.h>

@interface XRSA : NSObject {
    SecKeyRef publicKey;
    SecCertificateRef certificate;
    SecPolicyRef policy;
    SecTrustRef trust;
    size_t maxPlainLen;
}
- (XRSA *)initWithPublicKeyModulus:(NSString *)modulus withPublicKeyExponent:(NSString *)exponent;

- (NSData *) encryptWithData:(NSData *)content;
- (NSData *) encryptWithString:(NSString *)content;
- (NSString *) encryptToString:(NSString *)content;

@end
