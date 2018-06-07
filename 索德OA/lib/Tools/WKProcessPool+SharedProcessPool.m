//
//  WKProcessPool+SharedProcessPool.m
//  索德OA
//
//  Created by sw on 18/6/5.
//  Copyright © 2018年 sw. All rights reserved.
//

#import "WKProcessPool+SharedProcessPool.h"

@implementation WKProcessPool (SharedProcessPool)

+ (WKProcessPool*)sharedProcessPool {
    
    static WKProcessPool* SharedProcessPool;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        SharedProcessPool = [[WKProcessPool alloc] init];
        
    });
    
    return SharedProcessPool;
    
}

@end
