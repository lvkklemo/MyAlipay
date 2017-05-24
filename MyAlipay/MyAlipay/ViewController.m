//
//  ViewController.m
//  MyAlipay
//
//  Created by Agoni on 16/4/24.
//  Copyright © 2016年 KauriHealthLvkk. All rights reserved.
//

#import "ViewController.h"
#import "LLProduct.h"
#import "LLProductsCell.h"
#import "MJExtension.h"
#import "Order.h"
#import "APAuthV2Info.h"
#import "RSADataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

@interface ViewController ()
@property (nonatomic, strong) NSArray *products;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - tableView 数据源方法

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"%lu",(unsigned long)self.products.count);
    return self.products.count;
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LLProductsCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"productCell"];
    
    //  设置数据
    cell.product = self.products[indexPath.row];
    
    return cell;
}

- (NSArray *)products
{
    if (_products == nil) {
        _products = [LLProduct objectArrayWithFilename:@"tgs.plist"];
    }
    return _products;
}

- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

#pragma mark - tableView代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%s",__func__);
    [self doAlipayPay];
}

#pragma mark -
#pragma mark   ==============点击订单模拟支付行为==============
//
//选中商品调用支付宝极简支付
//
- (void)doAlipayPay
{
    //重要说明
    //这里只是为了方便直接向商户展示支付宝的整个支付流程；所以Demo中加签过程直接放在客户端完成；
    //真实App里，privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
    //防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *appID = @"2017032206341732";
    
    // 如下私钥，rsa2PrivateKey 或者 rsaPrivateKey 只需要填入一个
    // 如果商户两个都设置了，优先使用 rsa2PrivateKey
    // rsa2PrivateKey 可以保证商户交易在更加安全的环境下进行，建议使用 rsa2PrivateKey
    // 获取 rsa2PrivateKey，建议使用支付宝提供的公私钥生成工具生成，
    // 工具地址：https://doc.open.alipay.com/docs/doc.htm?treeId=291&articleId=106097&docType=1
    NSString *rsa2PrivateKey = @"MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCPe+cUmMj8713nQaugPzbFtBSrounsTY2Fe+WZ41G2jPIkmD4Q4Gt8FVe28Qn4wduZjtgSctsnp4+G/Iu2l657V54Pxod5+6wNEFi68wfFVw/pdSc4qp4C8IOeXJhonqMrAFERmsktj/rdv6DMbM1JyQgCFzKg7Fv7kJoArWWllkrz7TQoynysjuJAJjCe73dMGT7TLYIdaLleQ4XFzaVjWYHJB2g//w+FrZAXlu9l+vQnE26/DHrYgn7axvMm66sJUsKnJuzJ5Uy+o50es4Zy5aNZLLva+k5efw0PyI4IYPa6yghDaIbv3eTznaeefiuV/EWyWzxwyinPlZo7rRo7AgMBAAECggEAZurYtU1h3QtUr6vLDwZIo0aoDPSuFXELMdPMvLTwx6ARj24kFrbiYf5tDCuYm3VxrpNnKNR5ndfye0Bqdm4WGSKfnXEpe7WpkzVGb9IioMnx/+KoX10COdmKjuyb5W7kWtO/UoFUC/paVvQ8wmTIW0R3GgjJp+PhlnACBrpZTouJX1mJxklvEEOPrBZ7fVPrgAPcmIjwUKMJK94l4E990WZ+kTun8LubOsHllVpjdEBkW9LdnsHci5V3vskmt7Asi4vQVM8JHGWP3HHcmfTdbBxlY4LZBw/uJK3KY2RiMY5cozYBuubcuNLV8eooZqn03SvveXzMZBK9neY74PayAQKBgQDcL113HQntACgGuunN25GvWnDJIlVPCuSEnndfVHK4+RsnF2Ao8iwH/qWv7MyB5rJ9hOU9qlTD9SG1/+aLZmmlrVcK7oE85MoiXzXo6PYuxEfbrgUPSmH0xPDmC+w1qoZTFYeZo8qk/Jkk0sFevpZfB0LiakAA2d2/ivwAm2uvAwKBgQCm0qlOYvS5tNbpjQtgCo7gaEBEC0J0dTibfH11ZQo/XKCN+U8a0IGUvLiU7lHfkCqHjuJrtp2ZibTDhEKpnux5yzU/pafKJa4BweF0tkEi356OVbf8rJqAADitzhsNIzW0R5Nwn2VKg027ZbIkiQUZuDIWOb/iXAaLz6UivGLGaQKBgGxfv9A98cG+PvU5EJUrSmSVzkehZ33VLa781GKOjTzwF2ZBQipFMFjrBKA3nF0fsKDJRY/5g2lEAUi0YMQiL0PFsr8Fr4TKU5dhZ4ZxC6LvJzNATus8wEQanzuLiMLNYPoJ8ck0biyQy8vtFBJPGnJBf7EzfLcuhM+fV/Pwi6sDAoGAQKXAcJ0Og2zeH/HFp7lPtw0PYo8OeLz4a+DpaXX3a6iEm6AylIyaur4LtcNJPR7MLG4ltmI1Xsurnl0BzGPG9kfWYczbYg4KCapNqYH7af1In5X+T8+/q7zqOgh2GTg81pkqPOm4QhDyLZ3yVBA5RsdHua81eg35h3K3ZuekS4kCgYBqMpahVSNM08KHONhjVBb/3r8dPMTv2Cx2xwt+1Z4bBckrLUD5BNGj9/G9EEfo2Cp4JNDuPY4jAi7MX6FkUaYHDn9LVtuFjA66x6DzkiNlthJhYCXz5q6Z+wc9eRBivoZJIVo4+OLiC4t4H0HjBesFdGihF4OVEi5iN+MFq0CfGw==";
    NSString *rsaPrivateKey = @"";
    /*============================================================================*/
    /*MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAj3vnFJjI/O9d50GroD82xbQUq6Lp7E2NhXvlmeNRtozyJJg+EOBrfBVXtvEJ+MHbmY7YEnLbJ6ePhvyLtpeue1eeD8aHefusDRBYuvMHxVcP6XUnOKqeAvCDnlyYaJ6jKwBREZrJLY/63b+gzGzNSckIAhcyoOxb+5CaAK1lpZZK8+00KMp8rI7iQCYwnu93TBk+0y2CHWi5XkOFxc2lY1mByQdoP/8Pha2QF5bvZfr0JxNuvwx62IJ+2sbzJuurCVLCpybsyeVMvqOdHrOGcuWjWSy72vpOXn8ND8iOCGD2usoIQ2iG793k852nnn4rlfxFsls8cMopz5WaO60aOwIDAQAB*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([appID length] == 0 ||
        ([rsa2PrivateKey length] == 0 && [rsaPrivateKey length] == 0))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少appId或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order* order = [Order new];
    
    // NOTE: app_id设置
    order.app_id = appID;
    
    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";
    
    // NOTE: 参数编码格式
    order.charset = @"utf-8";
    
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    
    // NOTE: 支付版本
    order.version = @"1.0";
    
    // NOTE: sign_type 根据商户设置的私钥来决定
    order.sign_type = (rsa2PrivateKey.length > 1)?@"RSA2":@"RSA";
    
    // NOTE: 商品数据
    order.biz_content = [BizContent new];
    order.biz_content.body = @"我是测试数据";
    order.biz_content.subject = @"1";
    order.biz_content.out_trade_no = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.biz_content.timeout_express = @"30m"; //超时时间设置
    order.biz_content.total_amount = [NSString stringWithFormat:@"%.2f", 0.01]; //商品价格
    
    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    NSLog(@"orderSpec = %@",orderInfo);
    
    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    NSString *signedString = nil;
    RSADataSigner* signer = [[RSADataSigner alloc] initWithPrivateKey:((rsa2PrivateKey.length > 1)?rsa2PrivateKey:rsaPrivateKey)];
    if ((rsa2PrivateKey.length > 1)) {
        signedString = [signer signString:orderInfo withRSA2:YES];
    } else {
        signedString = [signer signString:orderInfo withRSA2:NO];
    }
    
    // NOTE: 如果加签成功，则继续执行支付
    if (signedString != nil) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = @"hwdAlipay";
        
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];
        
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
    }
}



@end
