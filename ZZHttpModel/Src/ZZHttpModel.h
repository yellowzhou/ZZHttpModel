//
//  ZZHttpModel.h
//  ZZHttpModel
//
//  Created by 黄周 on 2017/7/20.
//  CZZright © 2017年 yellow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>


@interface ZZHTTPResponse : NSObject

@property (nonatomic, strong)   NSError  *error;
@property (nonatomic, strong)   id          data;
@property (nonatomic, assign)   NSInteger statusCode;

@property (nonatomic, strong)   NSURLSessionTask    *task;

@end

@class ZZHttpModel;
@protocol ZZHTTPModelDelegate <NSObject>

- (void)httpModel:(ZZHttpModel *)model response:(ZZHTTPResponse *)response;

@end

typedef  void (^HttpModelCompletion)(ZZHTTPResponse *response);

@interface ZZHttpModel : NSObject

@property (nonatomic, copy)     NSString        *method;
@property (nonatomic, copy)     NSString        *url;
@property (nonatomic, strong)   NSDictionary    *params;
@property (nonatomic, strong)   NSDictionary    *headerFields;
@property (nonatomic, copy)     NSString  *httpBody;
@property (nonatomic, strong)   ZZHTTPResponse     *response;
@property (nonatomic, strong)   NSURLSessionTask    *task;

@property (nonatomic, strong)   NSMutableURLRequest *request;

@property (nonatomic, weak)     id<ZZHTTPModelDelegate> delegate;

+ (id)model:(NSString *) method url:(NSString *)url;

- (id)initWithMethod:(NSString *)method;
- (id)initWithUrl:(NSString *)url;
- (id)initWithDelegate:(id<ZZHTTPModelDelegate>)delegate;

- (void)pullData;
- (void)pullData:(NSDictionary *)params;
- (void)pullData:(NSDictionary *)params withCompletionBlock:(void (^)(ZZHTTPResponse *response))completion;
- (void)pullData:(NSString *)url withParams:(NSDictionary *)params withCompletionBlock:(void (^)(ZZHTTPResponse *response))completion;

- (void)pullData:(NSString *)url withParams:(NSDictionary *)params requestBlock:(void (^)(NSMutableURLRequest *request))request withCompletionBlock:(void (^)(ZZHTTPResponse *response))completion;

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method URLString:(NSString *)URLString parameters:(id)parameters error:(NSError *__autoreleasing *)error;



@end
