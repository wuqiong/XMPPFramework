//
//  MultiCast.m
//  TrustTextXMPP
//
//  Created by 戴维营教育 on 10/11/2014.
//  Copyright (c) 2014 戴维营教育. All rights reserved.
//

#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "XMPPMultiCast.h"
#import "XMPPLogging.h"
#import "XMPPMessage.h"
#import "NSXMLElement+XMPP.h"


#if DEBUG
static const int xmppLogLevel = XMPP_LOG_LEVEL_WARN; // | XMPP_LOG_FLAG_TRACE;
#else
static const int xmppLogLevel = XMPP_LOG_LEVEL_WARN;
#endif

@implementation XMPPMultiCast

- (id)init {
    return [self initWithDispatchQueue:NULL];
}

- (id)initWithDispatchQueue:(dispatch_queue_t)queue {
    if ((self = [super initWithDispatchQueue:queue])) {
    }
    return self;
}

- (BOOL)activate:(XMPPStream *)aXmppStream {
    if ([super activate:aXmppStream]) {
        return YES;
    }
    return NO;
}

- (void)deactivate {
    XMPPLogTrace();
    
    [super deactivate];
}

- (void)sendMessage:(NSString*)msg from:(XMPPJID*)fromJid withId:(NSString*)uuid toServer:(NSString*)serverJid forUsers:(NSArray*)jids {
    if ([msg length] == 0 || [jids count] == 0) {
        return;
    }
    
    dispatch_block_t block = ^{ @autoreleasepool {
        
        // Only supporting type of 'to' for now.
        XMPPLogTrace();
        // <message to='header1.org' from='a@header1.org/work'>
        //      <addresses xmlns='http://jabber.org/protocol/address'>
        //          <address type='to'  jid='to@header1.org'/>
        //          <address type='to'  jid='to@header2.org'/>
        //      </addresses>
        //      <body>Hello, World!</body>
        // </message>
        
        
        XMPPMessage *message = [XMPPMessage message];
        [message addAttributeWithName:@"id" stringValue:uuid];
        [message addAttributeWithName:@"to" stringValue:serverJid];
        [message addAttributeWithName:@"from" stringValue:fromJid.full];
        
        NSXMLElement *addresses = [NSXMLElement elementWithName:@"addresses" xmlns:@"http://jabber.org/protocol/address"];
        for (XMPPJID *jid in jids) {
            NSXMLElement *address = [NSXMLElement elementWithName:@"address"];
            [address addAttributeWithName:@"type" stringValue:@"to"];
            [address addAttributeWithName:@"jid" stringValue:jid.full];
            [addresses addChild:address];
        }
        [message addChild:addresses];
        
        NSXMLElement *body = [NSXMLElement elementWithName:@"body" stringValue:msg];
        [message addChild:body];
        
        NSXMLElement *receipt = [NSXMLElement elementWithName:@"request" xmlns:@"urn:xmpp:receipts"];
        [message addChild:receipt];
        
#if TRUSTCHIP_ENABLED
        NSXMLElement *trustChip = [NSXMLElement elementWithName:@"trustChip" stringValue:@"y"];
        [message addChild:trustChip];
#endif
        
        [xmppStream sendElement:message];
        
    }};
    
    if (dispatch_get_specific(moduleQueueTag))
        block();
    else
        dispatch_async(moduleQueue, block);
}


@end
