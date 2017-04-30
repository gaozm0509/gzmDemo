//
//  ZMBrowserViewController.m
//  GzmDemo
//
//  Created by gzm on 2017/3/27.
//  Copyright © 2017年 gzm. All rights reserved.
//

#import "ZMBrowserViewController.h"
#import "MultipeerConnectivityTool.h"

static NSString * const kServiceType = @"gzm-service";
static CGFloat kInputTextViewHeight = 50;

@interface ZMBrowserViewController ()<MCBrowserViewControllerDelegate,UITextViewDelegate,MultipeerConnectivityToolDelegate>

@property (nonatomic, strong) UIButton *addPeerButton;
@property (nonatomic, strong) UITextView *inputTextView;
@property (nonatomic, strong) UITextView *showReceiveDataTextView;

@property (nonatomic, strong) MultipeerConnectivityTool *multipeerConnectivityTool;

@end

@implementation ZMBrowserViewController

#pragma mark - life cycle

- (void)dealloc {
    NSLog(@"%s",__func__);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubViews];
    [self setupDatas];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - getter

- (UIButton *)addPeerButton {
    if (!_addPeerButton) {
        _addPeerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        UIImage *image = [UIImage imageNamed:@"Icon_add_peer"];
        [_addPeerButton setImage:image forState:UIControlStateNormal];
        _addPeerButton.tag = 1001;
        [_addPeerButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addPeerButton;
}

- (UITextView *)inputTextView {
    if (!_inputTextView) {
        _inputTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, ScreenHeight - kInputTextViewHeight, ScreenWidth, kInputTextViewHeight)];
        _inputTextView.layer.borderColor = [UIColor blackColor].CGColor;
        _inputTextView.layer.borderWidth = 0.5;
        _inputTextView.delegate = self;
        _inputTextView.textColor = [UIColor blackColor];
        _inputTextView.returnKeyType = UIReturnKeySend;
    }
    return _inputTextView;
}

- (UITextView *)showReceiveDataTextView {
    if (!_showReceiveDataTextView) {
        _showReceiveDataTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, kNavBarViewHeight, ScreenWidth, ScreenHeight - kNavBarViewHeight - kInputTextViewHeight)];
        _showReceiveDataTextView.editable = NO;
        _showReceiveDataTextView.textColor = [UIColor blackColor];
        _showReceiveDataTextView.font = [UIFont systemFontOfSize:20];
    }
    return _showReceiveDataTextView;
}

#pragma mark - setter


#pragma mark - delegate
#pragma mark MCBrowserViewControllerDelegate

// 比配完成回调
- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController {
    NSLog(@"匹配完成");
    [browserViewController dismissViewControllerAnimated:YES completion:nil];
    self.title = browserViewController.session.myPeerID.displayName;
}

// 取消匹配回调
- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController {
    [browserViewController dismissViewControllerAnimated:YES completion:nil];
}

// 匹配失败回调
- (void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error{
    NSLog(@"%@",error);
}


#pragma mark MultipeerConnectivityToolDelegate

// 发现附近的设备
- (void)multipeerConnectivityToolDiscoveryBrowser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary<NSString *,NSString *> *)info {
    MCSession *session = [[MCSession alloc]initWithPeer:peerID];
    NSString *infoStr = @"链接我吧";
    NSData *dataInfo = [infoStr dataUsingEncoding:NSUTF8StringEncoding];
    // 发送邀请
    [browser invitePeer:peerID toSession:session withContext:dataInfo timeout:20];
}


// 收到信息回调
- (void)multipeerConnectivityToolDidReceiveData:(NSData *)data session:(MCSession *)session fromPeer:(MCPeerID *)peerID {
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    self.showReceiveDataTextView.text = [NSString stringWithFormat:@"%@%@\n\n",self.showReceiveDataTextView.text,str];
}

- (void)multipeerConnectivityToolDidFinishReceivingResourceWithName:(NSString *)resourceName session:(MCSession *)session fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {
    self.inputTextView = nil;
}

#pragma mark UITextViewDelegate

// 点击return键
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        self.showReceiveDataTextView.text = [NSString stringWithFormat:@"%@%@\n\n",self.showReceiveDataTextView.text,self.inputTextView.text];
        NSData *data = [[NSString stringWithFormat:@"%@:%@",self.multipeerConnectivityTool.session.myPeerID.displayName,textView.text] dataUsingEncoding:NSUTF8StringEncoding];
        [self.multipeerConnectivityTool sendData:data peers:self.multipeerConnectivityTool.session.connectedPeers];
        textView.text = nil;
        return NO;
    }
    
    return YES;
}

#pragma mark - event

- (void)click:(UIButton *)button {
    switch (button.tag) {
        case 1001:{
            // 点击添加朋友按钮
            MCBrowserViewController *vc = [[MCBrowserViewController alloc] initWithServiceType:kServiceType session:self.self.multipeerConnectivityTool.session];
            [self presentViewController:vc animated:YES completion:nil];
            vc.delegate = self;
            
            break;
        }
        default:
            break;
    }
}

#pragma mark - pravit method


- (void)setupDatas {
    self.multipeerConnectivityTool = [[MultipeerConnectivityTool alloc] init];
    self.multipeerConnectivityTool.delegate = self;
    [self.multipeerConnectivityTool advertiserAssistantStart];
}

- (void)setupSubViews {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.addPeerButton];
    [self.view addSubview:self.inputTextView];
    [self.view addSubview:self.showReceiveDataTextView];
}


@end
