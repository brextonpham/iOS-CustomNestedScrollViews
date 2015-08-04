//
//  ViewController.m
//  CustomNestedScrollViews
//
//  Created by Brexton Pham on 07/24/2015.
//  Copyright (c) 2015 Brexton Pham. All rights reserved.
//

#import "ViewController.h"
#import "ScrollingCell.h"

static NSString * cellIdentifier = @"CellIdentifier";

@interface ViewController () <ScrollingCellDelegate> //conform to delegate protocol
@end

CGFloat _random() { return (float)rand() / (float)RAND_MAX;}

@implementation ViewController

- (void)dealloc {
    [_collectionView release];
    [_flowLayout release];
    [_scrollView release];
    [_otherView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerClass:[ScrollingCell class] forCellWithReuseIdentifier:cellIdentifier];
    self.scrollView.contentSize = CGSizeMake(2 * self.view.frame.size.width, self.view.frame.size.height - 61);
    self.otherView.backgroundColor = [UIColor whiteColor];
    
    
    UIImage *tabs = [UIImage imageNamed:@"tabBar2.png"];
    UIImageView *tabImageView = [[UIImageView alloc] initWithImage: tabs];
    //tabImageView.contentMode = UIViewContentModeScaleToFill;
    tabImageView.frame = CGRectMake(0, 507, 320, 50);
    [self.scrollView addSubview:tabImageView];
    
    UIImage *navBar = [UIImage imageNamed:@"navBar2.png"];
    UIImageView *navBarImageView = [[UIImageView alloc] initWithImage:navBar];
    navBarImageView.contentMode = UIViewContentModeScaleAspectFit;
    navBarImageView.frame = CGRectMake(0, -5, 320, 61);
    [self.scrollView addSubview:navBarImageView];
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - ScrollingCellDelegate

- (void)scrollingCellDidBeginPulling:(ScrollingCell *)cell {
    [self.scrollView setScrollEnabled:NO]; //controls user scrolling
    
    //self.otherView.backgroundColor = cell.color; //change color or respective cell
    UIImage* image = [UIImage imageNamed:@"pingScreenshot2"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = self.otherView.bounds;
    imageView.frame = CGRectMake(0, 15, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 15);
    [self.otherView addSubview:imageView];
}

- (void)scrollingCell:(ScrollingCell *)cell didChangePullOffset:(CGFloat)offset {
    [self.scrollView setContentOffset:CGPointMake(offset, 0)]; //set outer offset to innerscrollview offset
}

- (void)scrollingCellDidEndPulling:(ScrollingCell *)cell {
    [self.scrollView setScrollEnabled:YES]; //controls user scrolling
}

/*
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CGRectGetWidth(self.view.bounds), 100);
}
  */


#pragma mark - UICollectionViewDatasource methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ScrollingCell * cell = (ScrollingCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.delegate = self; 
    
    CGFloat red = _random();
    CGFloat green = _random();
    CGFloat blue = _random();
    cell.color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
    
    return cell;
}

@end
