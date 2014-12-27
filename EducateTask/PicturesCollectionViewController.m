//
//  PicturesCollectionViewController.m
//  EducateTask
//
//  Created by Admin on 26.12.14.
//  Copyright (c) 2014 rth. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <UIImageView+WebCache.h>

#import "PicturesCollectionViewController.h"
#import "PictureCollectionViewCell.h"
#import "AppDelegate.h"

@interface PicturesCollectionViewController () {
    NSMutableArray      *dataArray;
    UIView              *loadingView;
}

@end

@implementation PicturesCollectionViewController

static NSString * const reuseIdentifier         = @"CollectCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title                                  = @"CollectionView";
    
    dataArray                                   = @[].mutableCopy;
    loadingView                                 = [self loadingViewInit];

    [self.collectionView registerNib:[UINib nibWithNibName:@"PictureCollectionViewCell"
                                                    bundle:[NSBundle mainBundle]]
          forCellWithReuseIdentifier:reuseIdentifier];

    
    AFHTTPRequestOperationManager *requestManager = [[AFHTTPRequestOperationManager alloc]
                                                     initWithBaseURL:[NSURL URLWithString:@"https://www.googleapis.com"]];
//    requestManager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString        *searchEngine               = @"002767154513819630741%3Alebyppo6fhw";
    NSString        *query                      = @"kitten";
    NSString        *key                        = @"AIzaSyC7G23Qc_vd-Sllxo_BCuMkayMYIaeT9HA";
    
    NSString        *searchString               = [NSString stringWithFormat:
                                                   @"https://www.googleapis.com/customsearch/v1?cx=%@&q=%@&key=%@",
                                                   searchEngine, query, key];
    
    loadingView.hidden                          = NO;
    [requestManager GET:searchString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        for (NSDictionary *item in responseObject[@"items"]) {
            NSString    *urlString              = item[@"pagemap"][@"cse_image"][0][@"src"];
            
            if (urlString == nil) {
                urlString                       = @"";
            }
            
            [dataArray addObject:urlString];
        }
        [self.collectionView reloadData];
        loadingView.hidden                      = YES;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"fail, %@", error);
        loadingView.hidden                      = YES;
    }];
    
    //https://www.googleapis.com/customsearch/v1?cx=002767154513819630741%3Alebyppo6fhw&q=frog&key=AIzaSyDYDWlvAW4gdItQoat5mG_HPD-3l06XIL8
    //@"search?q=kitten&tbm=isch&alt=atom"
    //002767154513819630741:lebyppo6fhw
    //    https://www.google.com/search?q=kitten&tbm=isch
}

- (UIView *)loadingViewInit {
    UIView      *view           = [UIView new];
    UILabel     *label          = [UILabel new];
    
    view.backgroundColor        = [UIColor yellowColor];
    view.frame                  = [UIScreen mainScreen].bounds;
    view.hidden                 = YES;
    [APP_DELEGATE.window addSubview:view];
    
    label.text                  = @"Loading...";
    label.frame                 = CGRectMake((view.frame.size.width - 100.0) / 2,
                                             (view.frame.size.height - 20.0) / 2,
                                             100.0, 20.0);
    [view addSubview:label];
    
    return view;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PictureCollectionViewCell   *cell           = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier
                                                                                            forIndexPath:indexPath];
    NSString    *imgUrlString                   = dataArray[indexPath.row];
    
    [cell layoutIfNeeded];
    if (imgUrlString.length > 0) {
        
        [cell.cellImageView sd_setImageWithURL:[NSURL URLWithString:imgUrlString]placeholderImage:[UIImage imageNamed:@"kitten"]];
    }
    
    cell.cellImageView.clipsToBounds            = YES;
    cell.cellImageView.layer.cornerRadius       = cell.cellImageView.frame.size.width / 2;

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewFlowLayout *flowLayout      = (UICollectionViewFlowLayout *)collectionView.collectionViewLayout;
    CGFloat     minIterSpacing                  = flowLayout.minimumInteritemSpacing;
    CGFloat     insets                          = 2 * flowLayout.sectionInset.left;
    CGFloat     screenWidth                     = [UIScreen mainScreen].bounds.size.width;
    CGFloat     itemSize                        = (screenWidth - 2 * minIterSpacing - insets) / 3;
    
    return CGSizeMake(itemSize, itemSize);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self.collectionView.collectionViewLayout invalidateLayout];
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

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
