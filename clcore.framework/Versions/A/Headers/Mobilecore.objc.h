// Objective-C API for talking to github.com/minvws/nl-covid19-travelscan-mobile-core Go package.
//   gobind -lang=objc github.com/minvws/nl-covid19-travelscan-mobile-core
//
// File is generated by gobind. Do not edit.

#ifndef __Mobilecore_H__
#define __Mobilecore_H__

@import Foundation;
#include "ref.h"
#include "Universe.objc.h"


@class MobilecoreResult;

@interface MobilecoreResult : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) _Nonnull id _ref;

- (nonnull instancetype)initWithRef:(_Nonnull id)ref;
- (nonnull instancetype)init;
@property (nonatomic) NSData* _Nullable value;
@property (nonatomic) NSString* _Nonnull error;
@end

FOUNDATION_EXPORT NSString* _Nonnull const MobilecoreVERIFIER_CONFIG_FILENAME;
FOUNDATION_EXPORT NSString* _Nonnull const MobilecoreVERIFIER_PUBLIC_KEYS_FILENAME;

FOUNDATION_EXPORT MobilecoreResult* _Nullable MobilecoreInitializeVerifier(NSString* _Nullable configDirectoryPath);

FOUNDATION_EXPORT MobilecoreResult* _Nullable MobilecoreVerify(NSData* _Nullable proofQREncoded);

#endif
