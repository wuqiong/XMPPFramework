//
//  MultiCast.h
//  TrustTextXMPP
//
//  Created by 戴维营教育 on 10/11/2014.
//  Copyright (c) 2014 戴维营教育. All rights reserved.
//
//  This is a quick and dirty implementation of http://xmpp.org/extensions/xep-0033.html
//  This is not a full implementation.  It assumes that the server supports the extension.

#import <Foundation/Foundation.h>
#import "XMPP.h"

@interface XMPPMultiCast : XMPPModule {
}

- (void)sendMessage:(NSString*)msg from:(XMPPJID*)fromJid withId:(NSString*)uuid toServer:(NSString*)serverJid forUsers:(NSArray*)jids;

@end
