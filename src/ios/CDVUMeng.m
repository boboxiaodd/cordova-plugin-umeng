#import <Cordova/CDV.h>
#import "CDVUMeng.h"
#import <UMCommon/UMCommon.h>

@implementation CDVUMeng
- (void)pluginInitialize
{
    NSLog(@"--------------- init CDVUMeng -------- %@",[self settingForKey:@"umeng.key"]);
    NSDictionary * infoDic = NSBundle.mainBundle.infoDictionary;
    [UMConfigure initWithAppkey:[self settingForKey:@"umeng.key"] channel:[infoDic objectForKey:@"CFBundleIdentifier"]];
}


#pragma mark 公共方法

- (id)settingForKey:(NSString*)key
{
    return [self.commandDelegate.settings objectForKey:[key lowercaseString]];
}


@end
