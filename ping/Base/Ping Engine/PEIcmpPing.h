//
//  PEIcmpPing.h
//  NetDiag
//
//  Created by bailong on 15/12/30.
//  Copyright © 2015年 Qiniu Cloud Storage. All rights reserved.
//

#import "PEStopDelegate.h"
#import "PEOutputDelegate.h"

#import <Foundation/Foundation.h>

extern const int kPEInvalidPingResponse;
extern const int kPERequestStopped;

@interface PEPingResult : NSObject

@property (readonly) NSInteger code;
@property (readonly) NSString* ip;
@property (readonly) NSUInteger size;
@property (readonly) NSTimeInterval maxRtt;
@property (readonly) NSTimeInterval minRtt;
@property (readonly) NSTimeInterval avgRtt;
@property (readonly) NSInteger loss;
@property (readonly) NSInteger count;
@property (readonly) NSTimeInterval totalTime;
@property (readonly) NSTimeInterval stddev;

- (NSString*)description;

@end

@interface PEPingResponse : NSObject

@property (readonly) NSInteger code;
@property (readonly) NSString* ip;
@property (readonly) NSUInteger size;
@property (readonly) NSTimeInterval rtt;
@property (readonly) NSInteger ttl;
@property (readonly) NSInteger count;

- (NSString*)description;

@end

typedef void (^PEPingUpdateHandler)(PEPingResponse*, PEPingResult*);
typedef void (^PEPingCompleteHandler)(PEPingResult*);

@interface PEIcmpPing : NSObject <PEStopDelegate>

+ (instancetype)start:(NSString*)host
                 size:(NSUInteger)size
               output:(id<PEOutputDelegate>)output
               update: (PEPingUpdateHandler)update
             complete:(PEPingCompleteHandler)complete;

+ (instancetype)start:(NSString*)host
                 size:(NSUInteger)size
               output:(id<PEOutputDelegate>)output
               update: (PEPingUpdateHandler)update
             complete:(PEPingCompleteHandler)complete
             interval:(NSInteger)interval
                count:(NSInteger)count;

@end
