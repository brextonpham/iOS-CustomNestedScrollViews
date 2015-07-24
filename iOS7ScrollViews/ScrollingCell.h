//
//  ScrollingCell.h
//  WWDC2013ScrollViews
//
//  Created by Brexton Pham on 07/24/2015.
//  Copyright (c) 2015 Brexton Pham. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScrollingCellDelegate;

@interface ScrollingCell : UICollectionViewCell <UIScrollViewDelegate>
@property (nonatomic, assign) id<ScrollingCellDelegate> delegate;
@property (nonatomic, retain) UIColor * color;
@end

@protocol ScrollingCellDelegate <NSObject>
- (void)scrollingCellDidBeginPulling:(ScrollingCell *)cell; //gets called when your finger goes past catchpoint and starts pulling outer scrollview with you
- (void)scrollingCell:(ScrollingCell *)cell didChangePullOffset:(CGFloat)offset; //gets called when content offset is changed
- (void)scrollingCellDidEndPulling:(ScrollingCell *)cell; //tell delegate when pulling is ended
@end