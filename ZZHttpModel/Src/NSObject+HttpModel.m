//
//  NSObject+HttpModel.m
//  YZHttpModel
//
//  Created by 黄周 on 2017/7/14.
//  Copyright © 2017年 yellow. All rights reserved.
//

#import "NSObject+HttpModel.h"
#import <objc/runtime.h>

#import "ZZClassProperty.h"

static const char * kClassPropertiesKey = "key";


@implementation NSObject (HttpModel)

+ (void)exchangeInstanceMethod1:(SEL)method1 method2:(SEL)method2
{
    method_exchangeImplementations(class_getInstanceMethod(self, method1), class_getInstanceMethod(self, method2));
}

- (void)__inspectProperties
{
    if (objc_getAssociatedObject(self.class, kClassPropertiesKey)) {
        // 已经初始化过
        return;
    }
    
    NSMutableDictionary *ppDictionary = [[NSMutableDictionary alloc] init];
    
    unsigned int i = 0;
    unsigned int nProperty = 0;
    objc_property_t *properties = class_copyPropertyList(self.class, &nProperty);
    for (; i < nProperty; i++) {
        objc_property_t p = properties[i];
        const char *pName = property_getName(p);
        if (strcmp(pName, "debugDescription") == 0 ||
            strcmp(pName, "description") == 0 ||
            strcmp(pName, "hash") == 0 ||
            strcmp(pName, "superclass") == 0) {
            // iOS8.0+
            continue;
        }
        
        NSString *propertyType = @(property_getAttributes(p));
        
        NSArray *attributeItems = [propertyType componentsSeparatedByString:@","];
        
        NSScanner *scanner = [NSScanner scannerWithString:attributeItems[0]];
        [scanner scanUpToString:@"T" intoString: nil];
        [scanner scanString:@"T" intoString:nil];
        
        ZZClassProperty *clsProperty = [ZZClassProperty new];
        
        NSString *type = nil;
        NSString *protocolName= nil;
        if ([scanner scanString:@"@\"" intoString:nil]) {
            [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\"<"] intoString:&type];
            if ([scanner scanString:@"<" intoString:nil]) {
                [scanner scanUpToString:@">" intoString:&protocolName];
            }
            
        } else {
            [scanner scanUpToString:@"," intoString:&type];
        }
        
        if ([protocolName isEqualToString:@"Optional"]) {
            protocolName = type;
        }
        clsProperty.name = @(pName);
        clsProperty.type = type;
        clsProperty.protocolName = protocolName;
        
        [ppDictionary setObject:clsProperty forKey:@(pName)];
    }
    
    objc_setAssociatedObject(self.class, kClassPropertiesKey, ppDictionary, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-designated-initializers"
- (id)initWithDictionary:(NSDictionary *)data
#pragma clang diagnostic pop
{
    if (![data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    [self __inspectProperties];
    
    NSDictionary *clsPropertyDic = objc_getAssociatedObject(self.class, kClassPropertiesKey);
    NSArray *allKeys = [clsPropertyDic allKeys];
    
    for (NSString *key in allKeys) {
        ZZClassProperty *clsProperty = [clsPropertyDic objectForKey:key];
        if (clsProperty.protocolName) {
            NSArray *itemsData = [data objectForKey:key];
            
            if (![itemsData isKindOfClass:[NSArray class]]) {
                Class cls = NSClassFromString(clsProperty.type);
                id item = [data valueForKey:key];
                if (item == nil) {
                    continue;
                }
                
                id obj = [[cls alloc]initWithDictionary:item];
                [self setValue:obj forKey:key];
                continue ;
            }
            
            if (itemsData == nil || itemsData.count == 0) {
                continue;
            }
            
            Class cls = NSClassFromString(clsProperty.protocolName);
            
            //            if ([itemsData isKindOfClass:[NSDictionary class]]) {
            //                id obj = [[cls alloc]initWithDictionary:(id)itemsData];
            //                [self setValue:obj forKey:key];
            //                continue;
            //            }
            
            NSMutableArray *items = [[NSMutableArray alloc]initWithCapacity:itemsData.count];
            for (NSDictionary *item in itemsData) {
                id obj = [[cls alloc]initWithDictionary:item];
                [items addObject:obj];
            }
            
            [self setValue:items forKey:key];
            
        } else {
            id obj = [data valueForKey:key];
            if (obj != nil) {
                [self setValue:obj forKey:key];
            }
            
        }
    }
    
    return self;
}

- (id)initWithString:(NSString *)json
{
    self = [self init];
    
    NSError *error;
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    if (data) {
        return [self initWithDictionary:obj];
    } else {
        return nil;
    }
    
    return self;
}

- (NSDictionary *)toDictionary
{
    [self __inspectProperties];
    
    NSDictionary *clsPropertyDic = objc_getAssociatedObject(self.class, kClassPropertiesKey);
    NSArray *allKeys = [clsPropertyDic allKeys];
    NSMutableDictionary *result = [[NSMutableDictionary alloc]initWithCapacity:allKeys.count];
    
    for (NSString *key in allKeys) {
        ZZClassProperty *clsProperty = [clsPropertyDic objectForKey:key];
        if (clsProperty.protocolName) {
            NSArray *itemsData = [self valueForKey:key];
            
            if (![itemsData isKindOfClass:[NSArray class]]) {
                id item = [self valueForKey:key];
                if (item == nil) {
                    continue;
                }
                
                NSDictionary *temp = [item toDictionary];
                if (temp) {
                    [result setValue:temp forKey:key];
                }
                continue ;
            }
            if (itemsData == nil || itemsData.count == 0) {
                continue;
            }
            
            NSMutableArray *items = [[NSMutableArray alloc]initWithCapacity:itemsData.count];
            
            for (id item in itemsData) {
                id obj = [item toDictionary];
                [items addObject:obj];
            }
            
            [result setValue:items forKey:key];
            
        } else {
            id obj = [self valueForKey:key];
            if (obj != nil) {
                [result setValue:obj forKey:key];
            }
            
        }
    }
    
    return result;
}

- (NSString *)toJsonString
{
    NSDictionary *dict = [self toDictionary];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    NSString *jsonStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    return jsonStr;
}

+ (NSMutableArray *)arrayOfModelsFromJson:(NSString *)json
{
    NSError *error;
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *objectList = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    if ([objectList isKindOfClass:[NSArray class]]) {
        NSMutableArray *result = [[NSMutableArray alloc]initWithCapacity:objectList.count];
        for (NSDictionary *object in objectList) {
            id item = [[self alloc]initWithDictionary:object];
            [result addObject:item];
        }
        return result;
    }
    
    return nil;
}

+ (NSMutableArray *)arrayOfDictionariesFromModels:(NSArray *)models
{
    
    NSMutableArray *result = [[NSMutableArray alloc]initWithCapacity:models.count];
    for (id object in models) {
        [result addObject:[object toDictionary]];
    }
    
    return  result;
}

+ (NSString *)jsonFromModels:(NSArray *)models
{
    NSMutableArray *objects = [self arrayOfDictionariesFromModels:models];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:objects options:0 error:nil];
    NSString *jsonStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    return jsonStr;
}

@end
