// 
// Core classes
// 

#import <Foundation/Foundation.h>
#if !TARGET_OS_IPHONE
#import <Cocoa/Cocoa.h>
#else
#import <UIKit/UIKit.h>
#endif
#import "XMPPJID.h"
#import "XMPPStream.h"
#import "XMPPElement.h"
#import "XMPPIQ.h"
#import "XMPPMessage.h"
#import "XMPPPresence.h"
#import "XMPPModule.h"

// 
// Authentication
// 

#import "XMPPSASLAuthentication.h"
#import "XMPPCustomBinding.h"
#import "XMPPDigestMD5Authentication.h"
#import "XMPPSCRAMSHA1Authentication.h"
#import "XMPPPlainAuthentication.h"
#import "XMPPXFacebookPlatformAuthentication.h"
#import "XMPPAnonymousAuthentication.h"
#import "XMPPDeprecatedPlainAuthentication.h"
#import "XMPPDeprecatedDigestAuthentication.h"

// 
// Categories
// 

#import "NSXMLElement+XMPP.h"
