//
//  LLProductsCell.m
//  MyAlipay
//
//  Created by Agoni on 16/4/24.
//  Copyright © 2016年 KauriHealthLvkk. All rights reserved.
//

#import "LLProductsCell.h"

@interface LLProductsCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *buycountLabel;

@end
@implementation LLProductsCell

- (void)setProduct:(LLProduct *)product
{
    _product = product;
    self.iconView.image = [UIImage imageNamed:product.icon];
    self.titleLabel.text = product.title;
    self.descLabel.text = product.desc;
    self.priceLabel.text = [NSString stringWithFormat:@"%@ 元",product.price];
    self.buycountLabel.text = [NSString stringWithFormat:@"已售 %@",product.buyCount];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
