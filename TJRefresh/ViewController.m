//
//  ViewController.m
//  TJRefresh
//
//  Created by TanJian on 17/5/23.
//  Copyright © 2017年 Joshpell. All rights reserved.
//

#import "ViewController.h"
#import "tempViewController.h"
#import "TJRefresh.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 375, self.view.bounds.size.height ) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    
    [self.tableView addLoadMoreFooterWithHandle:^{
        
    }];
    
    [self.tableView addRefreshHeaderWithHandle:^{
        
    }];
    
#warning tips 正常界面的网络请求都是有回调的，成功，失败或者没网络等等情况，都是会调用结束刷新或加载的操作的，本demo没有加入这部分结束操作，提醒大家注意实际项目中记得加上，不是bug哦😯
    
    
}



#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [UITableViewCell new];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor lightGrayColor];
    
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
