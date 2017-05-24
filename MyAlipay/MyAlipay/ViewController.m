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

#pragma mark - tableView代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%s",__func__);
}

- (NSArray *)products
{
    if (_products == nil) {
        _products = [LLProduct objectArrayWithFilename:@"tgs.plist"];
    }
    return _products;
}

@end
