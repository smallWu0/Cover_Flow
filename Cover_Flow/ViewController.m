//
//  ViewController.m
//  Cover_Flow
//
//  Created by mac on 16/7/16.
//  Copyright © 2016年 wxy. All rights reserved.
//

#import "ViewController.h"
#import "WXYCoverFlowLayout.h"



static NSString *cellid = @"cellid";

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)NSArray *imageData;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    WXYCoverFlowLayout *layout = [[WXYCoverFlowLayout alloc]init];
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200) collectionViewLayout:layout];
    
    collectionView.center = self.view.center;
    
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellid];
    
    [self.view addSubview:collectionView];
    
    _imageData = [self loadImageData];
    
    
    
    
}

- (NSArray *)loadImageData{
    
 
    if (!_imageData) {
        _imageData = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"heros.plist" ofType:nil]];
    }
    return _imageData;
}



-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _imageData.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellid forIndexPath:indexPath];
    
    UIImageView *imageView = [[UIImageView
                               alloc]initWithFrame:cell.contentView.bounds];
    imageView.image=[UIImage imageNamed:_imageData[indexPath.row][@"icon"]];

    [cell.contentView addSubview:imageView];
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
