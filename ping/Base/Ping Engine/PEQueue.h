//
//  PEQueue.h
//  NetDiag
//
//  Created by BaiLong on 2016/12/7.
//  Copyright © 2016年 Qiniu Cloud Storage. All rights reserved.
//

#ifndef PEQueue_h
#define PEQueue_h

#import <Foundation/Foundation.h>

@interface PEQueue : NSObject

+ (void)async_run_serial:(dispatch_block_t)block;

+ (void)async_run_main:(dispatch_block_t)block;

@end

#endif /* PEQueue_h */
