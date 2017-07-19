//
//  ViewController.h
//  ZZHttpModel
//
//  Created by 黄周 on 2017/7/19.
//  Copyright © 2017年 yellow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+HttpModel.h"

@protocol UserModel <NSObject>
@end

@interface UserModel : NSObject<NSObject>

@property (nonatomic, copy)     NSString *attrs;
@property (nonatomic, assign)   NSInteger roleId;
@property (nonatomic, copy)     NSString *sid;
@property (nonatomic, copy)     NSString *trueName;
@property (nonatomic, assign)   BOOL smtpSave;

@end


@interface ADModel : NSObject

@property (nonatomic, assign)   NSInteger   index;
@property (nonatomic, strong)   NSString    *imgUrl;
@property (nonatomic, strong)   NSArray<UserModel> *users;


@property (nonatomic, strong)   UserModel<Optional>   *model;
@end


@interface ViewController : UIViewController


@end

