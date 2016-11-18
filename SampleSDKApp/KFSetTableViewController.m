//
//  ViewController.m
//  SampleSDKApp
//
//  Created by admin on 15/2/2.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "KFSetTableViewController.h"
#import "KFSetTableViewCell.h"
#import "KFPersonTableViewController.h"

#import "KF5SDKTicket.h"
#import "KF5SDKDoc.h"
#import "KF5SDKChat.h"

#define KFColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface KFCellData : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imageName;

+(instancetype)cellDataWithTitle:(NSString *)title imageName:(NSString *)imageName;

@end

@implementation KFCellData
+ (instancetype)cellDataWithTitle:(NSString *)title imageName:(NSString *)imageName
{
    KFCellData *data = [[KFCellData alloc]init];
    data.title = title;
    data.imageName = imageName;
    return data;
}
@end

@interface KFSetTableViewController ()<UIAlertViewDelegate>

@property (nonatomic, strong) NSArray *cellDataList;

@end

@implementation KFSetTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
    self.tableView.tableHeaderView = headerView;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.tableView setSeparatorColor:KFColorFromRGB(0xdddddd)];
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, headerView.frame.size.width, 116)];
    topView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    topView.backgroundColor = KFColorFromRGB(0xf2f5f9);
    [headerView addSubview:topView];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(64, 41, 200, 19)];
    label1.font = [UIFont systemFontOfSize:14.f];
    label1.backgroundColor = [UIColor clearColor];
    label1.text = @"欢迎使用逸创云客服SDK";
    label1.textColor = KFColorFromRGB(0x3e4245);
    [topView addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(64, 60, 250, 19)];
    label2.textColor = KFColorFromRGB(0x45d8d0);
    label2.font = [UIFont systemFontOfSize:11.f];
    label2.text = @"以下是展示逸创云客服SDK功能的按钮";
    [topView addSubview:label2];
    
    self.cellDataList = @[
                          [KFCellData cellDataWithTitle:@"帮助中心" imageName:@"icon_document"],
                          [KFCellData cellDataWithTitle:@"反馈问题" imageName:@"icon_request"],
                          [KFCellData cellDataWithTitle:@"查看反馈" imageName:@"icon_ticketList"],
                          [KFCellData cellDataWithTitle:@"即时交谈" imageName:@"icon_chat"]
                          ];
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  [[UIScreen mainScreen] bounds].size.height > 1136 ? 106 : 72;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellDataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    KFSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[KFSetTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    KFCellData *data = self.cellDataList[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:data.imageName];
    cell.textLabel.text = data.title;
    cell.textLabel.font = [UIFont systemFontOfSize:18.f];
    cell.textLabel.textColor = KFColorFromRGB(0x424345);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (![self checkLogin]) return;
    
    switch (indexPath.row) {
        case 0:
            [self helpCenter];
            break;
        case 1:
            [self request];
            break;
        case 2:
            [self requestList];
            break;
        case 3:
            [self chat];
            break;
        default:
            break;
    }
}

- (BOOL)checkLogin
{
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults]objectForKey:kUserDefaultUserInfo];
    
    BOOL isLogin = ((NSNumber *)[userInfo objectForKey:KKeyIsLogin]).boolValue;
    if (!isLogin) {
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有登录,请先登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil]show];
    }
    return isLogin;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        KFPersonTableViewController *preson = (KFPersonTableViewController*)[storyboard instantiateViewControllerWithIdentifier:@"KFPersonTableViewController"];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:preson animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
}

// 帮助中心
- (void)helpCenter {
    
    self.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:[[KFCategorieListViewController alloc] init] animated:YES];
    
    self.hidesBottomBarWhenPushed = NO;
}
// 反馈问题
- (void)request {
    
    self.hidesBottomBarWhenPushed = YES;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[KFCreateTicketViewController alloc] init]];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
    self.hidesBottomBarWhenPushed = NO;

}

// 反馈列表
- (void)requestList {
    
    self.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:[[KFTicketListViewController alloc] init] animated:YES];
    
    self.hidesBottomBarWhenPushed = NO;

}
// 聊天
- (void)chat{
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:[[KFChatViewController alloc]init] animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark 用于将cell分割线补全
-(void)viewDidLayoutSubviews {
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 88, 0, 30)];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 54, 0, 30)];
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 88, 0, 30)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 54, 0, 30)];
    }
}

@end