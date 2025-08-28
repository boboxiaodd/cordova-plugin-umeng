#import <Cordova/CDV.h>
#import "CDVUMeng.h"
#import <UMCommon/UMCommon.h>
#import <UMAPM/UMCrashConfigure.h>

@implementation CDVUMeng
- (void)pluginInitialize
{
    NSLog(@"--------------- init CDVUMeng -------- %@",[self settingForKey:@"umeng.key"]);
    NSDictionary * infoDic = NSBundle.mainBundle.infoDictionary;
    [UMConfigure initWithAppkey:[self settingForKey:@"umeng.key"] channel:[infoDic objectForKey:@"CFBundleIdentifier"]];
}
- (void)getUMID:(CDVInvokedUrlCommand *)command{
    NSString *uid = UMConfigure.umidString;
    [self send_event:command withMessage:@{@"umid":uid} Alive:NO State:YES];
}

- (void)setUId:(CDVInvokedUrlCommand *)command{
    NSDictionary *options = [command.arguments objectAtIndex: 0];
    NSString *uid = [options valueForKey:@"uid"];
    [UMCrashConfigure setCrashCBBlock:^NSString * _Nullable{
        return uid;
    }];
}

#pragma mark 公共方法

- (id)settingForKey:(NSString*)key
{
    return [self.commandDelegate.settings objectForKey:[key lowercaseString]];
}
- (void)send_event:(CDVInvokedUrlCommand *)command withMessage:(NSDictionary *)message Alive:(BOOL)alive State:(BOOL)state{
    CDVPluginResult* res = [CDVPluginResult resultWithStatus: (state ? CDVCommandStatus_OK : CDVCommandStatus_ERROR) messageAsDictionary:message];
    if(alive) [res setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult: res callbackId: command.callbackId];
}


@end
