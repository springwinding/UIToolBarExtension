//
//  ViewController.m
//  UIToolBarExtension
//
//  Created by JiangYan on 15/11/2.
//  Copyright © 2015年 Mybabay. All rights reserved.
//

#import "ViewController.h"
#import "UIToolbar+KIDBlur.h"

@interface 宝宝知道Cell : UITableViewCell
@property(nonatomic, strong) UIImageView *blurImageView;
@end

@implementation 宝宝知道Cell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
    }
    return self;
}

#pragma mark getter and setter

- (UIImageView *)blurImageView{
    if(!_blurImageView){
        _blurImageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        [self.contentView addSubview:_blurImageView];
        _blurImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        _blurImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _blurImageView;
}

@end

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[tableView]-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:@{@"tableView":tableView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[tableView]-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:@{@"tableView":tableView}]];
    [tableView registerClass:[宝宝知道Cell class] forCellReuseIdentifier:@"宝宝知道CellIndentifier"];
    
    UIToolbar.kid_tintColor     = [UIColor redColor];
    UIToolbar.kid_tintAlpha     = 0.3;
    UIToolbar.kid_blurRadius    = 2.0f;
    UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    [self.view addSubview:toolbar];
    toolbar.center = self.view.center;
    toolbar.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200.f;
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    宝宝知道Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"宝宝知道CellIndentifier"];
    NSString *imageName = [NSString stringWithFormat:@"宝宝知道_%@", @(arc4random()%3)];
    cell.blurImageView.image = [UIImage imageNamed:imageName];
    return cell;
}

@end
