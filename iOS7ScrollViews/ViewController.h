//
//  ViewController.h
//  WWDC2013ScrollViews
//
//  Created by Brexton Pham on 07/24/2015.
//  Copyright (c) 2015 Brexton Pham. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UICollectionViewDataSource>

@property (retain, nonatomic) IBOutlet UIScrollView * scrollView;
@property (retain, nonatomic) IBOutlet UIView * otherView;
@property (retain, nonatomic) IBOutlet UICollectionView * collectionView;
@property (retain, nonatomic) IBOutlet UICollectionViewFlowLayout * flowLayout;

@end
