//
//  PEOutputDelegate.h
//  ping
//
//  Created by Michael Fröhlich on 23.06.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PEOutputDelegate <NSObject>
    
- (void)write:(NSString*)line;
    
@end
