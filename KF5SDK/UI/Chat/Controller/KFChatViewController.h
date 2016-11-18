//
//  KFChatViewController.h
//  Pods
//
//  Created by admin on 16/10/9.
//
//

#import "KFBaseViewController.h"

@interface KFChatViewController : KFBaseViewController

/**
 *  当退出KFChatViewController时是否断开连接,默认为YES
 *
 *  如果设置为NO,则需要在合适的位置调用[[KFChatManager sharedChatManager] setUserOffline]方法关闭与服务器的连接
 */
@property (nonatomic, assign) BOOL isDisConnectWhenDelloc;
/**
 *  当没有客服在线时是否弹出alertView,默认为YES
 *
 *  注:当设置为NO时,noAgentAlertShowTitle,agentBusyAlertShowTitle和noAgentAlertActionBlock将失效
 */
@property (nonatomic, assign) BOOL isShowAlertWhenNoAgent;
/**
 *  当没有客服在线或取消排队留言时,弹出alertView,点击"确定"按钮的事件处理,默认跳转到反馈工单界面
 */
@property (nonatomic, copy) void (^noAgentAlertActionBlock)();

/**
 每次拉取的历史数量,默认20
 */
@property (nonatomic, assign) NSInteger limit;

@end