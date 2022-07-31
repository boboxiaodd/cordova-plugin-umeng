#import <Cordova/CDV.h>
#import "CDVUMeng.h"
#import <UMCommon/UMCommon.h>
#import <UMVerify/UMVerify.h>

@implementation CDVUMeng
- (void)pluginInitialize
{
    NSLog(@"--------------- init CDVUMeng -------- %@",[self settingForKey:@"umeng.key"]);
    NSDictionary * infoDic = NSBundle.mainBundle.infoDictionary;
    [UMConfigure initWithAppkey:[self settingForKey:@"umeng.key"] channel:[infoDic objectForKey:@"CFBundleIdentifier"]];
    [UMCommonHandler setVerifySDKInfo:[self settingForKey:@"umeng.verify"] complete:^(NSDictionary * _Nonnull resultDic) {
        NSLog(@"%@",resultDic);
    }];
}

-(void)open_one_key_auth:(CDVInvokedUrlCommand *)command
{
    NSDictionary *options = [command.arguments objectAtIndex: 0];
    NSString * strTitle = [options valueForKey:@"title"];

    UMCustomModel * modal = [[UMCustomModel alloc] init];

    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSForegroundColorAttributeName] = [UIColor blackColor];
    NSMutableAttributedString * title = [[NSMutableAttributedString alloc] initWithString: strTitle attributes:attributes];

    modal.navTitle = title;
    modal.privacyAlignment = NSTextAlignmentCenter;
    modal.navColor = [UIColor whiteColor];
    modal.checkBoxIsChecked = YES;
    modal.logoImage = [UIImage imageNamed:@"logo"];
    [UMCommonHandler accelerateLoginPageWithTimeout:10.0 complete:^(NSDictionary * _Nonnull resultDic) {
        if([[resultDic valueForKey:@"resultCode"] intValue] == 600000){
            [UMCommonHandler getLoginTokenWithTimeout:10.0 controller:self.viewController model:modal complete:^(NSDictionary * _Nonnull resultDic) {
                [self send_event:command withMessage:resultDic Alive:YES State:YES];
            }];
        }else{
            [self send_event:command withMessage:resultDic Alive:NO State:YES];
        }

    }];
}
-(void)close_one_key_auth:(CDVInvokedUrlCommand *)command
{
    [UMCommonHandler cancelLoginVCAnimated:YES complete:^{
        [self send_event:command withMessage:@{@"event": @"complete"} Alive:NO State:YES];
    }];
}

#pragma mark 公共方法

- (void)send_event:(CDVInvokedUrlCommand *)command withMessage:(NSDictionary *)message Alive:(BOOL)alive State:(BOOL)state{
    if(!command) return;
    CDVPluginResult* res = [CDVPluginResult resultWithStatus: (state ? CDVCommandStatus_OK : CDVCommandStatus_ERROR) messageAsDictionary:message];
    if(alive) [res setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult: res callbackId: command.callbackId];
}

- (id)settingForKey:(NSString*)key
{
    return [self.commandDelegate.settings objectForKey:[key lowercaseString]];
}


@end
