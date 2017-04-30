//
//  MultipeerConnectivity.h
//  GzmDemo
//
//  Created by gzm on 2017/3/27.
//  Copyright © 2017年 gzm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>


@protocol MultipeerConnectivityToolDelegate;

@interface MultipeerConnectivityTool : NSObject

@property (nonatomic, strong) MCSession *session;

@property (nonatomic, weak) id <MultipeerConnectivityToolDelegate> delegate;


/**
 advertiserAssistant 启动
 */
- (void)advertiserAssistantStart;


/**
 给指定peer发送信息

 @param data 信息 nsData
 @param peerIDs 发送对象
 */
- (void)sendData:(NSData *)data peers:(NSArray<MCPeerID *> *)peerIDs;


@end


@protocol MultipeerConnectivityToolDelegate <NSObject>


/**
 收到信息后回调

 @param data 接受到的信息
 @param session session
 @param peerID 发送者
 */
- (void)multipeerConnectivityToolDidReceiveData:(NSData *)data
                                        session:(MCSession *)session
                                       fromPeer:(MCPeerID *)peerID;




- (void)multipeerConnectivityToolDidFinishReceivingResourceWithName:(NSString *)resourceName
                                                            session:(MCSession *)session
                                                           fromPeer:(MCPeerID *)peerID
                                                              atURL:(NSURL *)localURL
                                                          withError:(NSError *)error;


/**
 发现周围设备

 @param browser browser
 @param peerID 被发现者
 @param info 对方发过来的信息
 */
- (void)multipeerConnectivityToolDiscoveryBrowser:(MCNearbyServiceBrowser *)browser
                                        foundPeer:(MCPeerID *)peerID
                                withDiscoveryInfo:(NSDictionary<NSString *,NSString *> *)info;
@end
