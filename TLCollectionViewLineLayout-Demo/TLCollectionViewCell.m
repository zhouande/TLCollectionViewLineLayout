//
//  TLCollectionViewCell.m
//  TLCollectionViewLineLayout-Demo
//
//  Created by andezhou on 15/7/16.
//  Copyright (c) 2015年 andezhou. All rights reserved.
//

#import "TLCollectionViewCell.h"

@implementation TLCollectionViewCell

#pragma mark -
#pragma mark init methods
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    }
    return _imageView;
}

#pragma mark -
#pragma mark lifecycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

@end
