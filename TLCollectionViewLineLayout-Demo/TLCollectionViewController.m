//
//  TLCollectionViewController.m
//  TLCollectionViewLineLayout-Demo
//
//  Created by andezhou on 15/7/16.
//  Copyright (c) 2015年 andezhou. All rights reserved.
//

#import "TLCollectionViewController.h"
#import "FXBlurView.h"
#import "TLCollectionViewCell.h"
#import "TLCollectionViewLineLayout.h"

static NSString * const reuseIdentifier = @"Cell";

@interface TLCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) TLCollectionViewLineLayout *lineLayout;

@end

@implementation TLCollectionViewController

#pragma mark -
#pragma mark lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"TLCollectionViewLineLayout";
    
    [self.view addSubview:self.collectionView];

    // Do any additional setup after loading the view.
}

#pragma mark -
#pragma mark init methods
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"bg%zi.jpg", 7%3]];
        FXBlurView *blurView = [[FXBlurView alloc] initWithFrame:_imageView.bounds];
        blurView.blurRadius = 10;
        blurView.tintColor = [UIColor clearColor];
        [_imageView addSubview:blurView];
    }
    return _imageView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _lineLayout = [[TLCollectionViewLineLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:_lineLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundView = self.imageView;
        [_collectionView registerClass:[TLCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:7 inSection:0]
                                    atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                            animated:YES];
    }
    return _collectionView;
}

#pragma mark -
#pragma mark UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat width = self.lineLayout.itemSize.width + self.lineLayout.minimumLineSpacing;
    NSInteger item = offsetX/width;
    NSString *imageName1 = [NSString stringWithFormat:@"bg%zi.jpg", item%3];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:.5f animations:^{
        weakSelf.imageView.image = [UIImage imageNamed:imageName1];
    }];
}

#pragma mark -
#pragma mark UICollectionViewDatasoure
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 30;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TLCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    NSString *imageName = [NSString stringWithFormat:@"bg%zi.jpg", indexPath.item%3];
    cell.imageView.image = [UIImage imageNamed:imageName];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
