# ZZHttmModel

## 安装使用
> pod 'httpmodel', '~> 0.0.1'

## 使用说明
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

## 返回response对象
![github](https://github.com/yellowzhou/ZZHttmModel/blob/master/demo1.png "github")  

## Dictionary => Model
![github](https://github.com/yellowzhou/ZZHttmModel/blob/master/demo2.png "github")

## Model => Dictionary
![github](https://github.com/yellowzhou/ZZHttmModel/blob/master/demo3.png "github")

## Model => JSON
![github](https://github.com/yellowzhou/ZZHttmModel/blob/master/demo4.png "github")
![github](https://github.com/yellowzhou/ZZHttmModel/blob/master/demo5.png "github")
