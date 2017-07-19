//
//  ZZClassProperty.m
//  YZHttpModel
//
//  Created by 黄周 on 2017/7/14.
//  Copyright © 2017年 yellow. All rights reserved.
//

#import "ZZClassProperty.h"

@implementation ZZClassProperty

- (NSString *)description
{
    return [NSString stringWithFormat:@"%p: {\nname: %@,\ntype: %@\nprotocol: %@\n}}",_name,_type,_protocolName];
}
@end
