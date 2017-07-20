//
//  ViewController.m
//  ZZHttpModel
//
//  Created by 黄周 on 2017/7/19.
//  Copyright © 2017年 yellow. All rights reserved.
//

#import "ViewController.h"
#import "ZZHttpModel.h"
#import "NSJSONSerialization+Extension.h"

@implementation UserModel

@end

@implementation ADModel
+ (UserModel *)usermodel
{
    UserModel *model = [[UserModel alloc]init];
    model.attrs = [NSString stringWithFormat:@"attrs%i",rand()];
    model.roleId = rand();
    model.sid = [NSString stringWithFormat:@"sid%li",random()];
    model.trueName = [NSString stringWithFormat:@"name%li",random()];
    model.smtpSave = YES;
    return model;
}

+ (instancetype)model
{
    ADModel *model = [[ADModel alloc]init];
    model.index = random();
    model.imgUrl = @"www.baidu.com";
    
    UserModel *m1 = [self usermodel];
    UserModel *m2 = [self usermodel];
    UserModel *m3 = [self usermodel];
    
    model.users  =@[m1,m2,m3];
    model.model = [self usermodel];
    return model;
}
@end


@protocol KuaidiInfo <NSObject>
@end
@interface KuaidiInfo : NSObject

@property (nonatomic, copy) NSString * time;
@property (nonatomic, copy) NSString *ftime;
@property (nonatomic, copy) NSString *context;
@property (nonatomic, copy) NSString *location;

@end
@implementation KuaidiInfo
@end

@interface KuaidiModel : NSObject

@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *nu;
@property (nonatomic, copy) NSString *ischeck;
@property (nonatomic, copy) NSString *condition;
@property (nonatomic, copy) NSString *com;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSMutableArray<KuaidiInfo> *data;

@end
@implementation KuaidiModel
@end


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    ADModel *adModel = [ADModel model];
    
    NSDictionary *dic = [adModel toDictionary];
    NSString *json = [adModel toJsonString];
    
    ADModel *m1 = [[ADModel alloc]initWithDictionary:dic];
    ADModel *m2 = [[ADModel alloc]initWithString:json];
    
    NSLog(@"%@",dic);
    NSLog(@"%@",json);
    
    UserModel *user1 = m1.users.firstObject;
    UserModel *user2 = adModel.users.firstObject;
    
    if ([user1.sid isEqualToString:user1.sid]) {
        NSLog(@"equal .....");
    }
    
    [self test1];
}

- (void)test1
{
    NSString *url = @"http://www.kuaidi100.com/query?type=yuantong&postid=11111111111";
    ZZHttpModel *model = [[ZZHttpModel alloc]initWithMethod:@"POST"];
    [model pullData:url withParams:nil requestBlock:^(NSMutableURLRequest *request) {
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"text/javascript" forHTTPHeaderField:@"Accept"];
    } withCompletionBlock:^(ZZHTTPResponse *response) {
        NSLog(@"%@",response);
        
        KuaidiModel *kuaidi = [[KuaidiModel alloc]initWithDictionary:response.data];
        NSLog(@"%@",[kuaidi toDictionary]);
    }];
}

@end
