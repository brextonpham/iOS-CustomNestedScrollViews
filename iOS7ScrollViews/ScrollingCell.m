//
//  ScrollingCell.m
//  CustomNestedScrollViews
//
//  Created by Brexton Pham on 07/24/2015.
//  Copyright (c) 2015 Brexton Pham. All rights reserved.
//

#import "ScrollingCell.h"

#define PULL_THRESHOLD 100

@interface ScrollingCell () {
    UIScrollView * _scrollView;
    UIImageView * _imageView;
    
    BOOL _pulling;
    BOOL _deceleratingBackToZero;
    CGFloat _decelerationDistanceRatio; //ratio of how far the outer scrollview has to move in relation to the inner
}

@end

@implementation ScrollingCell

#pragma mark - UIScrollViewDelegate

//delegate method to allow us to find out whenever scrollview content offset
//changes and lets us respond to it

//1. determine delta beyond catch point
//2. adjust parent contentOffset by delta we just calculated
//3. translate child back by delta to prevent double pull

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.x;
    
    //did we just start pulling?
    if (offset > PULL_THRESHOLD && !_pulling) {
        [self.delegate scrollingCellDidBeginPulling:self];
        _pulling = YES;
    }
    
    //tell delegate how much we changed pull offset
    if (_pulling) {
        CGFloat pullOffset;
        
        if (_deceleratingBackToZero) {
            pullOffset = offset * _decelerationDistanceRatio;
        } else {
            pullOffset = MAX(0, offset - PULL_THRESHOLD);
        }
        
        [self.delegate scrollingCell:self didChangePullOffset:pullOffset];
        _scrollView.transform = CGAffineTransformMakeTranslation(pullOffset, 0); //set a transform to prevent double pull, scrollview scrolls along with outerscroll view (to be "pinned")
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self scrollingEnded];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollingEnded];
}

- (void)scrollingEnded {
    [self.delegate scrollingCellDidEndPulling:self];
    _pulling = NO;
    _deceleratingBackToZero = NO;
    
    _scrollView.contentOffset = CGPointZero; //prevents cell from going off screen
    _scrollView.transform = CGAffineTransformIdentity;
}

//find out landing position of scrollview
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    // Not working on iOS6
    // This method is not called when the value of the scroll view’s pagingEnabled property is YES.
    CGFloat offset = _scrollView.contentOffset.x;
    
    if ((*targetContentOffset).x == 0 && offset > 0) {
        _deceleratingBackToZero = YES;
        
        CGFloat pullOffset = MAX(0, offset - PULL_THRESHOLD);
        _decelerationDistanceRatio = pullOffset / offset;
    }
}

#pragma mark - Setup & Layout

- (void)dealloc {
    [_color release];
    [_scrollView release];
    [_imageView retain];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] init];
        
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        
        [self.contentView addSubview:_scrollView];
        [_scrollView release];
        
        [_scrollView addSubview:_imageView];
        [_imageView release];
    }
    return self;
}

- (void)setColor:(UIColor *)color {
    if (color != _color) {
        [_color release];
        _color = [color retain];
    }
    UIImage *image = [UIImage imageNamed:@"yakScreenshot4.png"];
    //_imageView.backgroundColor = color;
    [_imageView setImage:image];
    //_imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)layoutSubviews {
    UIView * contentView = self.contentView;
    CGRect bounds = contentView.bounds;
    
    CGFloat pageWidth = bounds.size.width + PULL_THRESHOLD; //add pull threshold to prevent partial view pulling
    _scrollView.frame = CGRectMake(0, 0, pageWidth, bounds.size.height);
    _scrollView.contentSize = CGSizeMake(pageWidth * 2, bounds.size.height);
    
    _imageView.frame = [_scrollView convertRect:bounds fromView:contentView];
}

@end
