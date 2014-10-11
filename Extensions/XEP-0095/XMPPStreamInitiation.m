//
//  XMPPStreamInitiation.m
//  TrustTextXMPP
//
//  Created by 戴维营教育 on 10/11/2014.
//  Copyright (c) 2014 戴维营教育. All rights reserved.
//

#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "XMPPStreamInitiation.h"
#import "XMPPLogging.h"
#import "XMPPMessage.h"
#import "NSXMLElement+XMPP.h"

#if DEBUG
static const int xmppLogLevel = XMPP_LOG_LEVEL_WARN; // | XMPP_LOG_FLAG_TRACE;
#else
static const int xmppLogLevel = XMPP_LOG_LEVEL_WARN;
#endif

@implementation XMPPStreamInitiation

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


#pragma mark XMPPStream Delegate

// When we receive disco#info, we must advertise what we support.  IM clients like
// Apple's iMessage won't even show you the option to share files if you don't reply
// back with the features below.
- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)inIq
{
    NSString *type = [inIq type];
    if ([@"get" isEqualToString:type]) {
        NSXMLElement *query = [inIq childElement];
        NSString *xmlns = [query xmlns];
        if ([@"http://jabber.org/protocol/disco#info" isEqualToString:xmlns]) {
            
            NSString *iqId = [inIq attributeStringValueForName:@"id"];
            NSString *from = [inIq fromStr];
            NSString *to = [inIq toStr];
            
            NSXMLElement *element = [NSXMLElement elementWithName:@"query" xmlns:@"http://jabber.org/protocol/disco#info"];
            
            NSXMLElement *identity = [NSXMLElement elementWithName:@"identity"];
            [identity addAttributeWithName:@"category" stringValue:@"client"];
            [identity addAttributeWithName:@"type" stringValue:@"phone"];
            [element addChild:identity];
            
            
            NSXMLElement *feature = [NSXMLElement elementWithName:@"feature"];
            [feature addAttributeWithName:@"var" stringValue:@"http://jabber.org/protocol/si"];
            [element addChild:feature];
            
            NSXMLElement *feature2 = [NSXMLElement elementWithName:@"feature"];
            [feature2 addAttributeWithName:@"var" stringValue:@"http://jabber.org/protocol/si/profile/file-transfer"];
            [element addChild:feature2];
            
            
            NSXMLElement *feature3 = [NSXMLElement elementWithName:@"feature"];
            [feature3 addAttributeWithName:@"var" stringValue:@"http://jabber.org/protocol/bytestreams"];
            [element addChild:feature3];
            
            NSXMLElement *feature4 = [NSXMLElement elementWithName:@"feature"];
            [feature4 addAttributeWithName:@"var" stringValue:@"http://jabber.org/protocol/ibb"];
            [element addChild:feature4];
            
            XMPPIQ *iq = [XMPPIQ iqWithType:@"result" elementID:iqId child:element];
            [iq addAttributeWithName:@"from" stringValue:to];
            [iq addAttributeWithName:@"to" stringValue:from];
            
            [xmppStream sendElement:iq];
            return YES;
        }
    }
    return NO;
}



@end
