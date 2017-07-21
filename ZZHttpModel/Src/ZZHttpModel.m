//
//  ZZHttpModel.m
//  ZZHttpModel
//
//  Created by 黄周 on 2017/7/20.
//  Copyright © 2017年 yellow. All rights reserved.
//

#import "ZZHttpModel.h"


@implementation ZZHTTPResponse

@end

@interface ZZHttpModel ()

@property (nonatomic ,strong) AFHTTPSessionManager *manager;

@property (nonatomic, copy) void (^completionBlock)(ZZHTTPResponse *response);

@end

@implementation ZZHttpModel

- (id)initWithMethod:(NSString *)method
{
    self = [self init];
    if (self) {
        self.method = method;
    }
    
    return self;
}

- (id)initWithUrl:(NSString *)url
{
    self = [self init];
    if (self) {
        self.url = url;
    }
    
    return self;
}

- (id)initWithDelegate:(id<ZZHTTPModelDelegate>)delegate
{
    self = [self init];
    if (self) {
        self.delegate = delegate;
    }
    
    return self;
}

+ (id)model:(NSString *)method url:(NSString *)url
{
    ZZHttpModel *model = [[self alloc]initWithMethod:method];
    model.url = url;
    return model;
}


- (void)pullData
{
    [self pullData:nil];
}

- (void)pullData:(NSDictionary *)params
{
    [self pullData:params withCompletionBlock:nil];
}


- (void)pullData:(NSDictionary *)params withCompletionBlock:(void (^)(ZZHTTPResponse *))completion
{
    [self pullData:self.url withParams:params withCompletionBlock:completion];
}

- (void)pullData:(NSString *)url withParams:(NSDictionary *)params withCompletionBlock:(void (^)(ZZHTTPResponse *))completion
{
    [self pullData:url withParams:params requestBlock:nil withCompletionBlock:completion];
}

- (void)pullData:(NSString *)url withParams:(NSDictionary *)params requestBlock:(void (^)(NSMutableURLRequest *request))requestBlock withCompletionBlock:(void (^)(ZZHTTPResponse *response))completion
{
    if (!_manager) {
        self.manager = [AFHTTPSessionManager manager];
        [_manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
        _manager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD", nil];
        
        NSMutableSet *set = [NSMutableSet setWithSet:_manager.responseSerializer.acceptableContentTypes];
        [set addObject:@"text/html"];
        _manager.responseSerializer.acceptableContentTypes = set;
    }
    
    if (url) {
        self.url = url;
    }
    
    if (params) {
        self.params = params;
    }
    
    [self.headerFields enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [_manager.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
    
    if (!self.request) {
        self.request = [self requestWithMethod:self.method URLString:self.url parameters:self.params error:nil];
        [self.request setValue:@"text/javascript" forHTTPHeaderField:@"Accept"];
    }
    
    if (self.httpBody) {
        
        [self.request setHTTPBody:[self.httpBody dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if (self.headerFields ) {
        self.request.allHTTPHeaderFields = self.headerFields;
    }
    if (requestBlock) {
        requestBlock(self.request);
    }
    
    self.completionBlock = completion;
    
    if (self.httpBody || requestBlock) {
        __block typeof(self) weakSelf = self;
        self.task = [_manager dataTaskWithRequest:self.request completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
            responseObject?[weakSelf requestSuccess:weakSelf.task responseObject:responseObject]:[weakSelf requestFailure:weakSelf.task error:error];
        }];
        
        [self.task resume];
        return;
    }

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Warc-performSelector-leaks"
    SEL sel = NSSelectorFromString(self.method);
    if ([self respondsToSelector:sel]) {
        [self performSelector:sel];
    }
#pragma clang diagnostic pop
    
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method URLString:(NSString *)URLString parameters:(id)parameters error:(NSError *__autoreleasing *)error
{
    return [[AFJSONRequestSerializer serializer] requestWithMethod:self.method URLString:self.url parameters:self.params error:nil];
}

#pragma mark -- http 请求方式

- (void)POST
{
    _task = [_manager POST:self.url parameters:self.params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self requestSuccess:task responseObject:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self requestFailure:task error:error];
    }];
}

- (void)GET
{
    self.task = [self.manager GET:self.url parameters:self.params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [self requestSuccess:task responseObject:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self requestFailure:task error:error];
    }];
}

- (void)PUT
{
    self.task = [self.manager PUT:self.url parameters:self.params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [self requestSuccess:task responseObject:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self requestFailure:task error:error];
    }];
}

- (void)DELETE
{
    self.task = [self.manager DELETE:self.url parameters:self.params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [self requestSuccess:task responseObject:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self requestFailure:task error:error];
    }];
}


#pragma mark --
- (void)requestSuccess:(NSURLSessionTask *)task responseObject:(id) responseObject
{
    ZZHTTPResponse *response = [ZZHTTPResponse new];
    response.data = responseObject;
    response.statusCode = ((NSHTTPURLResponse*)task.response).statusCode;
    response.task = self.task;
    if (_completionBlock) {
        self.completionBlock(response);
    }
    
    if ([self.delegate respondsToSelector:@selector(httpModel:response:)]) {
        [self.delegate httpModel:self response:response];
    }
}

- (void)requestFailure:(NSURLSessionTask *)task error:(NSError*)error
{
    ZZHTTPResponse *response = [ZZHTTPResponse new];
    response.error = error;
    response.statusCode = ((NSHTTPURLResponse*)task.response).statusCode;
    response.task = self.task;
    if (_completionBlock) {
        self.completionBlock(response);
    }
    
    if ([self.delegate respondsToSelector:@selector(httpModel:response:)]) {
        [self.delegate httpModel:self response:response];
    }
}

- (NSString *)method
{
    if (!_method) {
        _method = @"POST";
    }
    
    return _method;
}
@end
