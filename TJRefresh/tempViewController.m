//
//  tempViewController.m
//  TJRefresh
//
//  Created by TanJian on 17/5/24.
//  Copyright © 2017年 Joshpell. All rights reserved.
//

#import "tempViewController.h"
#import "TJRefresh.h"

@interface tempViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@end

@implementation tempViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 375, self.view.bounds.size.height ) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView addRefreshHeaderWithHandle:^{
        NSLog(@"网络操作");
    }];
    [self.tableView addLoadMoreFooterWithHandle:^{
        
    }];
    [self.view addSubview:self.tableView];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [UITableViewCell new];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor yellowColor];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"结束刷新";
    }else if(indexPath.row == 9){
        cell.textLabel.text = @"结束加载";
        
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.row == 0) {
        [tableView.header endRefreshing];
    }else if(indexPath.row == 9){
        [tableView.footer endLoading];
        
    }else{
        tempViewController *view1 = [[tempViewController alloc]init];
        
        [self.navigationController pushViewController:view1 animated:YES];
    }
    
}
@end
