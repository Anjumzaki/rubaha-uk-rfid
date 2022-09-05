/******************************************************************************
 *
 *       Copyright Zebra Technologies, Inc. 2014 - 2015
 *
 *       The copyright notice above does not evidence any
 *       actual or intended publication of such source code.
 *       The code contains Zebra Technologies
 *       Confidential Proprietary Information.
 *
 *
 *  Description:  AppConfiguration.m
 *
 *  Notes:
 *
 ******************************************************************************/

#import "AppConfiguration.h"
#import "RfidAppEngine.h"

@implementation zt_AppConfiguration

- (id)init
{
    self = [super init];
    if (nil != self)
    {
        m_SearchCriteria = [[NSMutableString alloc] initWithString:@""];
        m_SelectedInventoryIdx = -1;
        m_SelectedInventoryItem = nil;
        m_SelectedInventoryMemoryBankUI = SRFID_MEMORYBANK_NONE;
        m_TagIdAccess = [[NSMutableString alloc] initWithString:@""];
        m_TagIdLocationing = [[NSMutableString alloc] initWithString:@""];
    }
    return self;
}

- (void)dealloc
{
    if (nil != m_SearchCriteria)
    {
        [m_SearchCriteria release];
    }
    
    if (nil != m_SelectedInventoryItem)
    {
        [m_SelectedInventoryItem release];
    }
    
    if (nil != m_TagIdLocationing)
    {
        [m_TagIdLocationing release];
    }
    
    if (nil != m_TagIdAccess)
    {
        [m_TagIdAccess release];
    }
    
    [super dealloc];
}


- (void)loadAppConfiguration
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    
    /*
     NSUserDefaults returns 0 for number if the key doesn't exist
     Check that 0 is not a valid value for the parameter
     
     */
    
    int _app_exists = (int)[settings integerForKey:ZT_APP_CFG_APP_INSTALLED];
    
    if (_app_exists == 0)
    {
        /* no value => setup default values */
        [settings setInteger:1 forKey:ZT_APP_CFG_APP_INSTALLED];
        [settings setBool:YES forKey:ZT_APP_CFG_CONNECTION_AUTO_DETECTION];
        [settings setBool:NO forKey:ZT_APP_CFG_CONNECTION_AUTO_RECONNECTION];
        [settings setBool:NO forKey:ZT_APP_CFG_NOTIFICATION_AVAILABLE];
        [settings setBool:NO forKey:ZT_APP_CFG_NOTIFICATION_CONNECTION];
        [settings setBool:YES forKey:ZT_APP_CFG_NOTIFICATION_BATTERY];
        [settings setBool:NO forKey:ZT_APP_CFG_HOST_BEEPER_ENABLED];
        [settings setBool:NO forKey:ZT_APP_CFG_APP_DATA_EXPORT];
    }
    
    m_ConfigConnectionAutoDetection = [settings boolForKey:ZT_APP_CFG_CONNECTION_AUTO_DETECTION];
    m_ConfigConnectionAutoReconnection = [settings boolForKey:ZT_APP_CFG_CONNECTION_AUTO_RECONNECTION];
    m_ConfigHostBeeperEnabled = [settings boolForKey:ZT_APP_CFG_HOST_BEEPER_ENABLED];
    m_ConfigNotificationAvailable = [settings boolForKey:ZT_APP_CFG_NOTIFICATION_AVAILABLE];
    m_ConfigNotificationBattery = [settings boolForKey:ZT_APP_CFG_NOTIFICATION_BATTERY];
    m_ConfigNotificationConnection = [settings boolForKey:ZT_APP_CFG_NOTIFICATION_CONNECTION];
    m_ConfigDataExport = [settings boolForKey:ZT_APP_CFG_APP_DATA_EXPORT];
}

- (BOOL)getConfigConnectionAutoDetection
{
    return YES;
}

- (BOOL)getConfigConnectionAutoReconnection
{
    return m_ConfigConnectionAutoReconnection;
}

- (void)setConfigConnectionAutoReconnection:(BOOL)option
{
    if (option != m_ConfigConnectionAutoReconnection)
    {
        m_ConfigConnectionAutoReconnection = option;
        [[NSUserDefaults standardUserDefaults] setBool:m_ConfigConnectionAutoReconnection forKey:ZT_APP_CFG_CONNECTION_AUTO_RECONNECTION];
    }
}

- (BOOL)getConfigNotificationAvailable
{
    return m_ConfigNotificationAvailable;
}

- (void)setConfigNotificationAvailable:(BOOL)option
{
    if (option != m_ConfigNotificationAvailable)
    {
        m_ConfigNotificationAvailable = option;
        [[NSUserDefaults standardUserDefaults] setBool:m_ConfigNotificationAvailable forKey:ZT_APP_CFG_NOTIFICATION_AVAILABLE];
    }
}

- (BOOL)getConfigNotificationConnection
{
    return m_ConfigNotificationConnection;
}

- (void)setConfigNotificationConnection:(BOOL)option
{
    if (option != m_ConfigNotificationConnection)
    {
        m_ConfigNotificationConnection = option;
        [[NSUserDefaults standardUserDefaults] setBool:m_ConfigNotificationConnection forKey:ZT_APP_CFG_NOTIFICATION_CONNECTION];
    }
}

- (BOOL)getConfigNotificationBattery
{
    return m_ConfigNotificationBattery;
}

- (void)setConfigNotificationBattery:(BOOL)option
{
    if (option != m_ConfigNotificationBattery)
    {
        m_ConfigNotificationBattery = option;
        [[NSUserDefaults standardUserDefaults] setBool:m_ConfigNotificationBattery forKey:ZT_APP_CFG_NOTIFICATION_BATTERY];
        if (NO == option)
        {
            /* nrv364: reset stored critical/low battery status when notifications are disabled */
            [[zt_RfidAppEngine sharedAppEngine] resetBatteryStatusString];
        }
    }
}

- (BOOL)getConfigHostBeeperEnabled
{
    return m_ConfigHostBeeperEnabled;
}

- (void)setConfigHostBeeperEnabled:(BOOL)option
{
    if (option != m_ConfigHostBeeperEnabled)
    {
        m_ConfigHostBeeperEnabled = option;
        [[NSUserDefaults standardUserDefaults] setBool:m_ConfigHostBeeperEnabled forKey:ZT_APP_CFG_HOST_BEEPER_ENABLED];
    }
}

- (BOOL)getConfigDataExport
{
    return m_ConfigDataExport;
}

- (void)setConfigDataExport:(BOOL)option
{
    if (option != m_ConfigDataExport) {
        m_ConfigDataExport = option;
        [[NSUserDefaults standardUserDefaults] setBool:m_ConfigDataExport forKey:ZT_APP_CFG_APP_DATA_EXPORT];
    }
}

- (NSString*)getConfigAsciiPassword:(int)reader_id
{
    NSString *key = [NSString stringWithFormat:@"%@_readerid_%d_", ZT_APP_CFG_READER_ASCII_PASSWORD, reader_id];
    NSString *pwd = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:key];
    return pwd;
}

- (void)setConfigAsciiPassword:(NSString*)password forReader:(int)reader_id
{
    NSString *key = [NSString stringWithFormat:@"%@_readerid_%d_", ZT_APP_CFG_READER_ASCII_PASSWORD, reader_id];
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:key];
}


- (void)setTagSearchCriteria:(NSString*)criteria
{
    [m_SearchCriteria setString:criteria];
}

- (NSString*)getTagSearchCriteria
{
    return [NSString stringWithString:m_SearchCriteria];
}

- (zt_InventoryItem *)getSelectedInventoryItem
{
    return m_SelectedInventoryItem;
}

- (int)getSelectedInventoryItemIndex
{
    return m_SelectedInventoryIdx;
}

- (void)setSelectedInventoryItem:(zt_InventoryItem *)item withIdx:(int)index
{
    m_SelectedInventoryItem = [item retain];
    m_SelectedInventoryIdx = index;
}

- (void)clearSelectedItem
{
    if (nil != m_SelectedInventoryItem) {
        [m_SelectedInventoryItem release];
        m_SelectedInventoryItem = nil;
    }
    
    m_SelectedInventoryIdx = -1;
}

- (SRFID_MEMORYBANK)getSelectedInventoryMemoryBankUI
{
    return m_SelectedInventoryMemoryBankUI;
}

- (void)setSelectedInventoryMemoryBankUI:(SRFID_MEMORYBANK)val
{
    m_SelectedInventoryMemoryBankUI = val;
}

- (NSString*)getTagIdLocationing
{
    return [NSString stringWithString:m_TagIdLocationing];
}

- (void)setTagIdLocationing:(NSString*)val
{
    [m_TagIdLocationing setString:val];
}

- (void)clearTagIdLocationingGracefully
{
    NSString *selected_tag_id = [m_SelectedInventoryItem getTagId];
    if (NSOrderedSame == [m_TagIdLocationing caseInsensitiveCompare:selected_tag_id])
    {
        [m_TagIdLocationing setString:@""];
    }
}

- (NSString*)getTagIdAccess
{
    return [NSString stringWithString:m_TagIdAccess];
}

- (void)setTagIdAccess:(NSString*)val
{
    [m_TagIdAccess setString:val];
}
- (void)clearTagIdAccessGracefully
{
    NSString *selected_tag_id = [m_SelectedInventoryItem getTagId];
    if (NSOrderedSame == [m_TagIdAccess caseInsensitiveCompare:selected_tag_id])
    {
        [m_TagIdAccess setString:@""];
    }
}

@end
