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
    self.scrollView.contentSize = CGSizeMake(2 * self.view.frame.size.width, self.view.frame.size.height);
}

#pragma mark - ScrollingCellDelegate

- (void)scrollingCellDidBeginPulling:(ScrollingCell *)cell {
    [self.scrollView setScrollEnabled:NO]; //controls user scrolling
    
    self.otherView.backgroundColor = cell.color; //change color or respective cell
}

- (void)scrollingCell:(ScrollingCell *)cell didChangePullOffset:(CGFloat)offset {
    [self.scrollView setContentOffset:CGPointMake(offset, 0)]; //set outer offset to innerscrollview offset
}

- (void)scrollingCellDidEndPulling:(ScrollingCell *)cell {
    [self.scrollView setScrollEnabled:YES]; //controls user scrolling
}


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
