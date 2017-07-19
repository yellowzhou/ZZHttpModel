//
//  NSObject+HttpModel.h
//  YZHttpModel
//
//  Created by 黄周 on 2017/7/14.
//  Copyright © 2017年 yellow. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Optional
@end

@interface NSObject (HttpModel)


- (id)initWithDictionary:(NSDictionary *)data;

- (id)initWithString:(NSString *)json;

- (NSDictionary *)toDictionary;

- (NSString *)toJsonString;

+ (NSArray *)arrayOfModelsFromJson:(NSString *)json;

+ (NSMutableArray *)arrayOfDictionariesFromModels:(NSArray *)models;

+ (NSString *)jsonFromModels:(NSArray *)models;

@end
