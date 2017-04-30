//
//  MultipeerConnectivity.m
//  GzmDemo
//
//  Created by gzm on 2017/3/27.
//  Copyright © 2017年 gzm. All rights reserved.
//

#import "MultipeerConnectivityTool.h"


static NSString * const kServiceType = @"gzm-service";

@interface MultipeerConnectivityTool()<MCSessionDelegate,MCAdvertiserAssistantDelegate,MCNearbyServiceBrowserDelegate,MCNearbyServiceAdvertiserDelegate>

@property (nonatomic, strong) MCAdvertiserAssistant *advertiserAssistant;

@end

@implementation MultipeerConnectivityTool

#pragma mark public method

- (void)advertiserAssistantStart {
    [self.advertiserAssistant start];
}

- (void)sendData:(NSData *)data peers:(NSArray<MCPeerID *> *)peerIDs {
    [self.session sendData:data toPeers:peerIDs withMode:MCSessionSendDataReliable error:nil];
}

#pragma mark life cycle
- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (MCSession *)session {
    if (!_session) {
        MCPeerID *peer = [[MCPeerID alloc] initWithDisplayName:[UIDevice currentDevice].name];
        _session = [[MCSession alloc] initWithPeer:peer securityIdentity:nil encryptionPreference:MCEncryptionNone];
        _session.delegate = self;
    }
    return _session;
}

- (MCAdvertiserAssistant *)advertiserAssistant {
    if (!_advertiserAssistant) {
        _advertiserAssistant = [[MCAdvertiserAssistant alloc] initWithServiceType:kServiceType discoveryInfo:[[NSDictionary alloc]init] session:self.session];
        _advertiserAssistant.delegate = self;
    }
    return _advertiserAssistant;
}

#pragma mark - delegate

//发现用户
- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary<NSString *,NSString *> *)info{
//    [nearbyServiceBrowser invitePeer:peerID toSession:session withContext:dataInfo timeout:20];
    [self.delegate multipeerConnectivityToolDiscoveryBrowser:browser foundPeer:peerID withDiscoveryInfo:info];
}

//接收邀请
- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL accept, MCSession * session))invitationHandler{
    
    invitationHandler(YES,_session);
    
}

// 失去连接
- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID {

}

// MCSessionDelegate

- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {

}

// 收到信息回调
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate multipeerConnectivityToolDidReceiveData:data session:session fromPeer:peerID];
    });
}

// 收到stream
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {

}

- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {
    [self.delegate multipeerConnectivityToolDidFinishReceivingResourceWithName:resourceName session:session fromPeer:peerID atURL:localURL withError:error];
}

//消息返回
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{
    switch (state) {
        case MCSessionStateNotConnected:{
            NSLog(@"失去连接");
            break;
        }
        case MCSessionStateConnecting:{
            NSLog(@"正在连接");
            break;
        }
        case MCSessionStateConnected:{
            NSLog(@"开始连接");
            break;
        }
    }
    NSLog(@"%@",peerID.displayName);
}


@end
