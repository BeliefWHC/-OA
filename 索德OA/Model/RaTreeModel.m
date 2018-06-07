//
//  RaTreeModel.m
//  索德OA
//
//  Created by sw on 18/5/30.
//  Copyright © 2018年 sw. All rights reserved.
//

#import "RaTreeModel.h"
#import "MJExtension.h"

@implementation RaTreeModel

- (id)initWithName:(NSString *)name children:(NSArray *)children
{
    self = [super init];
    if (self) {
        self.childOrgs = children;
        self.orgName = name;
    }
    return self;
}

+ (id)dataObjectWithName:(NSString *)name children:(NSArray *)children
{
    return [[self alloc] initWithName:name children:children];
}


-(void)setChildOrgs:(NSMutableArray *)childOrgs{
    if (childOrgs) {
        _childOrgs = [RaTreeModel mj_objectArrayWithKeyValuesArray:childOrgs];
    }
    
}

@end


