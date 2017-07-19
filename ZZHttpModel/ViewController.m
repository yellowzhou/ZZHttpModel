//
//  ViewController.m
//  ZZHttpModel
//
//  Created by 黄周 on 2017/7/19.
//  Copyright © 2017年 yellow. All rights reserved.
//

#import "ViewController.h"

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
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
