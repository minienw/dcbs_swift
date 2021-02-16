// Objective-C API for talking to github.com/minvws/nl-covid19-coronatester-ctcl-core/clmobile Go package.
//   gobind -lang=objc github.com/minvws/nl-covid19-coronatester-ctcl-core/clmobile
//
// File is generated by gobind. Do not edit.

#ifndef __Clmobile_H__
#define __Clmobile_H__

@import Foundation;
#include "ref.h"
#include "Universe.objc.h"


@class ClmobileCreateCredentialMessage;
@class ClmobileResult;
@class ClmobileVerifyResult;

@interface ClmobileCreateCredentialMessage : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) _Nonnull id _ref;

- (nonnull instancetype)initWithRef:(_Nonnull id)ref;
- (nonnull instancetype)init;
// skipped field CreateCredentialMessage.IssueSignatureMessage with unsupported type: *github.com/privacybydesign/gabi.IssueSignatureMessage

// skipped field CreateCredentialMessage.Attributes with unsupported type: map[string]string

@end

@interface ClmobileResult : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) _Nonnull id _ref;

- (nonnull instancetype)initWithRef:(_Nonnull id)ref;
- (nonnull instancetype)init;
@property (nonatomic) NSData* _Nullable value;
@property (nonatomic) NSString* _Nonnull error;
@end

@interface ClmobileVerifyResult : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) _Nonnull id _ref;

- (nonnull instancetype)initWithRef:(_Nonnull id)ref;
- (nonnull instancetype)init;
@property (nonatomic) NSData* _Nullable attributesJson;
@property (nonatomic) int64_t unixTimeSeconds;
@property (nonatomic) NSString* _Nonnull error;
@end

FOUNDATION_EXPORT ClmobileResult* _Nullable ClmobileCreateCommitmentMessage(NSData* _Nullable holderSkJson, NSData* _Nullable issuerPkXml, NSData* _Nullable issuerNonceBase64);

FOUNDATION_EXPORT ClmobileResult* _Nullable ClmobileCreateCredential(NSData* _Nullable holderSkJson, NSData* _Nullable ccmJson);

FOUNDATION_EXPORT ClmobileResult* _Nullable ClmobileDiscloseAllWithTime(NSData* _Nullable issuerPkXml, NSData* _Nullable credJson);

FOUNDATION_EXPORT ClmobileResult* _Nullable ClmobileDiscloseAllWithTimeQrEncoded(NSData* _Nullable issuerPkXml, NSData* _Nullable holderSkJson, NSData* _Nullable credJson);

FOUNDATION_EXPORT ClmobileResult* _Nullable ClmobileGenerateHolderSk(void);

FOUNDATION_EXPORT ClmobileResult* _Nullable ClmobileReadCredential(NSData* _Nullable credJson);

FOUNDATION_EXPORT ClmobileVerifyResult* _Nullable ClmobileVerify(NSData* _Nullable issuerPkXml, NSData* _Nullable proofAsn1);

FOUNDATION_EXPORT ClmobileVerifyResult* _Nullable ClmobileVerifyQREncoded(NSData* _Nullable issuerPkXml, NSData* _Nullable proofQrEncodedAsn1);

#endif
