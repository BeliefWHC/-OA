//
//  WKProcessPool+SharedProcessPool.h
//  索德OA
//
//  Created by sw on 18/6/5.
//  Copyright © 2018年 sw. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface WKProcessPool (SharedProcessPool)

+ (WKProcessPool*)sharedProcessPool;

@end
