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
 *  Description:  SledConfiguration.m
 *
 *  Notes:
 *
 ******************************************************************************/

#import "SledConfiguration.h"
#import "ui_config.h"

/* Antenna */
#define ZT_SLED_ANTENNA_POWER_MEASUREMENT_MULT                10
#define ZT_SLED_ANTENNA_POWER_MIN                             120
#define ZT_SLED_ANTENNA_POWER_MAX                             300
#define ZT_SLED_ANTENNA_POWER_STEP                            30

#define ZT_SLED_CFG_NAME_ANTENNA_TARI_MIN                     0
#define ZT_SLED_CFG_NAME_ANTENNA_TARI_MAX                     7
#define ZT_SLED_CFG_NAME_ANTENNA_TARI_STEP                    1

/* tag report */
#define ZT_SLED_CFG_NAME_TAG_REPORT_FIRST_SEEN_TIME            @"First Seen Time"
#define ZT_SLED_CFG_NAME_TAG_REPORT_LAST_SEEN_TIME             @"Last Seen Time"
#define ZT_SLED_CFG_NAME_TAG_REPORT_PC                         @"PC"
#define ZT_SLED_CFG_NAME_TAG_REPORT_RSSI                       @"RSSI"
#define ZT_SLED_CFG_NAME_TAG_REPORT_PHASE                      @"Phase"
#define ZT_SLED_CFG_NAME_TAG_REPORT_CHANNEL_IDX                @"Channel Index"
#define ZT_SLED_CFG_NAME_TAG_REPORT_TAG_SEEN_COUNT             @"Tag Seen Count"


/* regulatory */
#define ZT_SLED_CFG_NAME_REGULATORY_CHANNEL_4                  @"Channel 4 (865.70 MHz)"
#define ZT_SLED_CFG_NAME_REGULATORY_CHANNEL_7                  @"Channel 7 (866.30 MHz)"
#define ZT_SLED_CFG_NAME_REGULATORY_CHANNEL_10                 @"Channel 10 (866.90 MHz)"
#define ZT_SLED_CFG_NAME_REGULATORY_CHANNEL_13                 @"Channel 13 (867.50 MHz)"


/* trigger */
#define ZT_SLED_CFG_NAME_TRIGGER_START_IMMEDIATE               @"Immediate"
#define ZT_SLED_CFG_NAME_TRIGGER_START_PERIODIC                @"Periodic"
#define ZT_SLED_CFG_NAME_TRIGGER_START_HANDHELD                @"Handheld"

#define ZT_SLED_CFG_NAME_TRIGGER_STOP_IMMEDIATE                @"Immediate"
#define ZT_SLED_CFG_NAME_TRIGGER_STOP_DURATION                 @"Duration"
#define ZT_SLED_CFG_NAME_TRIGGER_STOP_TAG_OBSERVATION          @"Tag Observation"
#define ZT_SLED_CFG_NAME_TRIGGER_STOP_N_ATTEMPTS               @"N Attempts"
#define ZT_SLED_CFG_NAME_TRIGGER_STOP_HANDHELD                 @"Handheld"

@implementation zt_SledConfiguration

- (id)init
{
    self = [super init];
    if (nil != self)
    {
        _antennaPowerLevelsArray = [[NSMutableArray alloc] init];
        _antennaOptionsLinkProfile = [[NSMutableDictionary alloc] init];
        _antennaOptionsTari= [[NSMutableDictionary alloc] init];
        _antennaOptionsDoSelect= [[NSMutableDictionary alloc] init];
        _antennaAllLinkProfiles = [[NSMutableArray alloc] init];
        
        _mapperSLFlag =[[zt_EnumMapper alloc] initWithSLFLAGMapper];
        _mapperSession = [[zt_EnumMapper alloc] initWithSESSIONMapper];

        _mapperInventoryState = [[zt_EnumMapper alloc] initWithINVENTORYSTATEMapper];
        _mapperTagPopulation = [[zt_EnumMapper alloc] initWithTAGPPOPULATIONMapper];
        
        _mapperBeeper = [[zt_EnumMapper alloc] initWithBEEPERCONFIGMapper];
        _mapperTargetOption = [[zt_EnumMapper alloc] initWithSELECTTARGETMapperForPrefilters];
        
        _triggerStartOptions = [[NSMutableArray alloc] init];
        _triggerStopOptions = [[NSMutableArray alloc] init];
        _mapperTriggerType = [[zt_EnumMapper alloc] initWithTRIGGERTYPEMapper];
        
        _regionOptions = [[NSMutableArray alloc] init];
        _currentRegionChannelList = [[NSMutableArray alloc] init];
        
        _currentPrefilters = [[NSMutableArray alloc] init];
        _mapperAction = [[zt_EnumMapper alloc] initWithSELECTACTIONMapper];
        _mapperBankPrefilters = [[zt_EnumMapper alloc] initWithMEMORYBANKMapperForPrefilters];
        
        m_ConfigTagReportOptions = [[NSMutableArray alloc] init];
        _batchModeOptions = [[NSMutableArray alloc] init];
        
    }
    return self;
}

- (void)dealloc
{
    // Antenna dealloc
    if (nil != _antennaPowerLevelsArray)
    {
        [_antennaPowerLevelsArray release];
    }
    if (nil != _antennaOptionsLinkProfile)
    {
        [_antennaOptionsLinkProfile removeAllObjects];
        [_antennaOptionsLinkProfile release];
    }
    
    if (nil != _antennaOptionsTari)
    {
        [_antennaOptionsTari removeAllObjects];
        [_antennaOptionsTari release];
    }
    if (nil != _antennaOptionsDoSelect)
    {
        [_antennaOptionsDoSelect removeAllObjects];
        [_antennaOptionsDoSelect release];
    }
    
    if (nil != _antennaAllLinkProfiles)
    {
        [_antennaAllLinkProfiles removeAllObjects];
        [_antennaAllLinkProfiles release];
    }

    
    // Singulation dealloc
    if (nil != _mapperSLFlag)
    {
        [_mapperSLFlag release];
    }
    
    if (nil != _mapperSession)
    {
        [_mapperSession release];
    }
    
    if (nil != _mapperInventoryState)
    {
        [_mapperInventoryState release];
    }
    
    if (nil != _mapperTagPopulation)
    {
        [_mapperTagPopulation release];
    }
    
    // beeper
    if (nil != _mapperBeeper) {
        [_mapperBeeper release];
    }
    
    // trigger options
    if (nil != _mapperTriggerType)
    {
        [_mapperTriggerType release];
    }
    
    if (nil != _triggerStopOptions) {
        [_triggerStopOptions release];
    }
    
    if (nil != _triggerStartOptions)
    {
        [_triggerStartOptions release];
    }
    
    if(nil != _regionOptions)
    {
        [_regionOptions release];
    }
    if(nil != _currentRegionCode)
    {
        [_currentRegionCode release];
    }
    if(nil != _currentRegionChannelList)
    {
        [_currentRegionChannelList release];
    }
    
    if (nil !=_currentPrefilters)
    {
        [_currentPrefilters release];
    }
    if (nil !=_mapperTargetOption)
    {
        [_mapperTargetOption release];
    }
    if (nil !=_mapperAction)
    {
        [_mapperAction release];
    }
    if (nil !=_mapperBankPrefilters)
    {
        [_mapperBankPrefilters release];
    }
    
    // toDo delete later
    
    if (nil != m_ConfigTagReportOptions)
    {
        [m_ConfigTagReportOptions removeAllObjects];
        [m_ConfigTagReportOptions release];
    }
    
    //batch mode
    if(nil != _batchModeOptions)
    {
        [_batchModeOptions release];
    }


    [super dealloc];
}

- (void)setupInitialConfiguration
{
    /* antenna settings */
    for (int value = ZT_SLED_CFG_NAME_ANTENNA_TARI_MIN; value <= ZT_SLED_CFG_NAME_ANTENNA_TARI_MAX ; value += ZT_SLED_CFG_NAME_ANTENNA_TARI_STEP) {
        [_antennaOptionsTari setObject:[NSString stringWithFormat:@"%d tari level", value] forKey:[NSNumber numberWithInt:value]];
    }
    
    [_antennaOptionsDoSelect setObject:@"Select" forKey:[NSNumber numberWithBool:YES]];
    [_antennaOptionsDoSelect setObject:@"Not Select" forKey:[NSNumber numberWithBool:NO]];

    /* tag report settings */
    
    _tagReportFirstSeenTime = NO;
    _tagReportLastSeenTime = NO;
    _tagReportPC = NO;
    _tagReportRSSI = YES;
    _tagReportPhase = NO;
    _tagReportChannelIdx = NO;
    _tagReportSeenCount = NO;
    _isUniqueTagsReport = [NSNumber numberWithBool:NO];
    
    /* power management settings */
    
    self.currentDpoEnable =  [NSNumber numberWithBool:YES]; /* enable DPO by default */
    
    /* beeper settings */
    
    _currentBeeperLevel = SRFID_BEEPERCONFIG_MEDIUM;
    
    /* prefilters settings */
    [self addEmptyPrefilterToArray:_currentPrefilters];
    [self addEmptyPrefilterToArray:_currentPrefilters];
    
    // delete above lines
    
    /* tag report settings */
    
    for (int i = 0; i < ZT_SLED_CFG_TAG_REPORT_COUNT; i++)
    {
        [m_ConfigTagReportOptions addObject:@""];
    }
    
    [m_ConfigTagReportOptions replaceObjectAtIndex:ZT_SLED_CFG_TAG_REPORT_CHANNEL_INDEX withObject:ZT_SLED_CFG_NAME_TAG_REPORT_CHANNEL_IDX];
    [m_ConfigTagReportOptions replaceObjectAtIndex:ZT_SLED_CFG_TAG_REPORT_FIRST_SEEN_TIME withObject:ZT_SLED_CFG_NAME_TAG_REPORT_FIRST_SEEN_TIME];
    [m_ConfigTagReportOptions replaceObjectAtIndex:ZT_SLED_CFG_TAG_REPORT_LAST_SEEN_TIME withObject:ZT_SLED_CFG_NAME_TAG_REPORT_LAST_SEEN_TIME];
    [m_ConfigTagReportOptions replaceObjectAtIndex:ZT_SLED_CFG_TAG_REPORT_PC withObject:ZT_SLED_CFG_NAME_TAG_REPORT_PC];
    [m_ConfigTagReportOptions replaceObjectAtIndex:ZT_SLED_CFG_TAG_REPORT_PHASE withObject:ZT_SLED_CFG_NAME_TAG_REPORT_PHASE];
    [m_ConfigTagReportOptions replaceObjectAtIndex:ZT_SLED_CFG_TAG_REPORT_RSSI withObject:ZT_SLED_CFG_NAME_TAG_REPORT_RSSI];
    [m_ConfigTagReportOptions replaceObjectAtIndex:ZT_SLED_CFG_TAG_REPORT_TAG_SEEN_COUNT withObject:ZT_SLED_CFG_NAME_TAG_REPORT_TAG_SEEN_COUNT];
    
    /* trigger settings */
    for (int i = 0; i < ZT_SLED_CFG_TRIGGER_START_COUNT; i++)
    {
        [_triggerStartOptions addObject:@""];
    }
    
    [_triggerStartOptions replaceObjectAtIndex:ZT_SLED_CFG_TRIGGER_START_HANDHELD withObject:ZT_SLED_CFG_NAME_TRIGGER_START_HANDHELD];
    [_triggerStartOptions replaceObjectAtIndex:ZT_SLED_CFG_TRIGGER_START_IMMEDIATE withObject:ZT_SLED_CFG_NAME_TRIGGER_START_IMMEDIATE];
    [_triggerStartOptions replaceObjectAtIndex:ZT_SLED_CFG_TRIGGER_START_PERIODIC withObject:ZT_SLED_CFG_NAME_TRIGGER_START_PERIODIC];
    
    for (int i = 0; i < ZT_SLED_CFG_TRIGGER_STOP_COUNT; i++)
    {
        [_triggerStopOptions addObject:@""];
    }
    
    [_triggerStopOptions replaceObjectAtIndex:ZT_SLED_CFG_TRIGGER_STOP_DURATION withObject:ZT_SLED_CFG_NAME_TRIGGER_STOP_DURATION];
    [_triggerStopOptions replaceObjectAtIndex:ZT_SLED_CFG_TRIGGER_STOP_HANDHELD withObject:ZT_SLED_CFG_NAME_TRIGGER_STOP_HANDHELD];
    [_triggerStopOptions replaceObjectAtIndex:ZT_SLED_CFG_TRIGGER_STOP_IMMEDIATE withObject:ZT_SLED_CFG_NAME_TRIGGER_STOP_IMMEDIATE];
    [_triggerStopOptions replaceObjectAtIndex:ZT_SLED_CFG_TRIGGER_STOP_N_ATTEMPTS withObject:ZT_SLED_CFG_NAME_TRIGGER_STOP_N_ATTEMPTS];
    [_triggerStopOptions replaceObjectAtIndex:ZT_SLED_CFG_TRIGGER_STOP_TAG_OBSERVATION withObject:ZT_SLED_CFG_NAME_TRIGGER_STOP_TAG_OBSERVATION];
    
    /* Batch Mode */
    
    [_batchModeOptions addObject:@""];
    [_batchModeOptions addObject:@""];
    [_batchModeOptions addObject:@""];
    [_batchModeOptions replaceObjectAtIndex:SRFID_BATCHMODECONFIG_DISABLE withObject:@"Disable"];
    [_batchModeOptions replaceObjectAtIndex:SRFID_BATCHMODECONFIG_AUTO withObject:@"Auto"];
    [_batchModeOptions replaceObjectAtIndex:SRFID_BATCHMODECONFIG_ENABLE withObject:@"Enable"];
    
    _currentBatchMode = 1;
    
 }

+ (NSNumber *)getKeyFromDictionary:(NSDictionary *)dictionary withValue:(NSString *)value
{
    NSDictionary *dic = [dictionary copy];
    NSArray *array = [dic allKeysForObject:value];
    [dic release];
    if([array count] == 1)
    {
        return array[0];
    }
    return nil;
}

#pragma mark - antenna
- (BOOL)setAntennaOptionsWithConfig:(srfidAntennaConfiguration *)config
{
    _currentAntennaLinkProfile = [config getLinkProfileIdx];
    _currentAntennaTari = [config getTari];
    _currentAntennaDoSelect = [config getDoSelect];
    float inputPowerLevel = [config getPower];
    
    _currentAntennaPowerLevel = inputPowerLevel;
    
    return YES;
}


- (BOOL)setAntennaOptionsWithPower:(float)power {
  _currentAntennaPowerLevel = power;
  return YES;
}


- (srfidAntennaConfiguration *)getAntennaConfig
{
    srfidAntennaConfiguration *config = [[[srfidAntennaConfiguration alloc] init] autorelease];
//    [config setPower:(_currentAntennaPowerLevel * ZT_SLED_ANTENNA_POWER_MEASUREMENT_MULT)];
    [config setPower:_currentAntennaPowerLevel];
    [config setLinkProfileIdx:_currentAntennaLinkProfile];
    
    /*
      find link profile and select min tari value
     */
//    for (srfidLinkProfile *profile in _antennaAllLinkProfiles)
//    {
//        if ([profile getRFModeIndex] == _currentAntennaLinkProfile)
//        {
//            _currentAntennaTari = [profile getMinTari];
//            NSLog(@"Antenna: tari updated for link profile %d: %d", [profile getRFModeIndex], _currentAntennaTari);
//            break;
//        }
//    }
    [config setTari:_currentAntennaTari];
    [config setDoSelect:_currentAntennaDoSelect];
    return config;
}

- (void)setLinkProfileOptions:(NSArray *)linkProfiles
{
    [_antennaAllLinkProfiles removeAllObjects];
    [_antennaAllLinkProfiles addObjectsFromArray:linkProfiles];
    
    for (int i=0; i < [linkProfiles count]; ++i) {
        srfidLinkProfile *profile = linkProfiles[i];
        
        [_antennaOptionsLinkProfile setObject:[NSString stringWithFormat:@"%d %@ %d %d %d %d",
                                               profile.getBDR,
                                               [self getModulationString:profile.getModulation],
                                               /*[self getForwardLinkModulation:profile.getFLModulation],*/
                                               profile.getPIE,
                                               profile.getMinTari,
                                               profile.getMaxTari,
                                               profile.getStepTari] forKey:[NSNumber numberWithInt:profile.getRFModeIndex]];
    }
}

- (NSArray *)getLinkProfileArray
{

    NSMutableArray *keys = [[[NSMutableArray alloc] initWithArray:[_antennaOptionsLinkProfile allKeys]] autorelease];
    [keys sortUsingSelector:@selector(compare:)];
    NSArray *linkProfiles = [_antennaOptionsLinkProfile objectsForKeys:keys notFoundMarker:[NSNull null]];
    return linkProfiles;
}

- (NSString *)getForwardLinkModulation:(SRFID_FORWARDLINKMODULATION)forward
{
    zt_EnumMapper *mapper = [[zt_EnumMapper alloc] initWithFORWARDLINKMODULATIONMapper];
    NSString *result = [mapper getStringByEnum:forward];
    [mapper release];
    return result;
}

- (NSString *)getModulationString:(SRFID_MODULATION)mod
{
    zt_EnumMapper *mapper = [[zt_EnumMapper alloc] initWithMODULATIONMapper];
    NSString *result = [mapper getStringByEnum:mod];
    [mapper release];
    return result;
}

- (BOOL)isAntennaConfigEqual:(zt_SledConfiguration *)sled
{
    if(_currentAntennaDoSelect != sled.currentAntennaDoSelect)
       return NO;
    if(_currentAntennaLinkProfile != sled.currentAntennaLinkProfile)
        return NO;
    if(_currentAntennaPowerLevel != sled.currentAntennaPowerLevel)
        return NO;
    if(_currentAntennaTari != sled.currentAntennaTari)
        return NO;
    
    return YES;
}

#pragma mark - dynamic power optimization settings

- (void)setDpoOptionsWithConfig:(srfidDynamicPowerConfig *)config
{
    self.currentDpoEnable = [NSNumber numberWithBool:[config getDynamicPowerOptimizationEnabled]];
}

- (srfidDynamicPowerConfig *)getDpoConfig
{
    srfidDynamicPowerConfig *config = [[[srfidDynamicPowerConfig alloc] init] autorelease];
    [config setDynamicPowerOptimizationEnabled:[self.currentDpoEnable boolValue]];
    
    return config;
}

- (BOOL)isDpoConfigEqual:(zt_SledConfiguration *)sled
{
    if([self.currentDpoEnable boolValue] != [sled.currentDpoEnable boolValue])
        return NO;
    
    return YES;
}

#pragma mark - singulation settings

- (BOOL)setSingulationOptionsWithConfig:(srfidSingulationConfig *)config
{
    _currentSLFLag = [config getSLFlag];
    _currentSession = [config getSession];
    _currentInventoryState = [config getInventoryState];
    _currentTagPopulation = [config getTagPopulation];
    if (NSNotFound == [_mapperTagPopulation getIndxByEnum:_currentTagPopulation])
    {
        /* one of not-supported by app values retrieved from reader */
        _currentTagPopulation = [_mapperTagPopulation getEnumByIndx:0];
        return NO;
    }
    return YES;
}

- (srfidSingulationConfig *)getSingulationConfig
{
    srfidSingulationConfig *config = [[[srfidSingulationConfig alloc] init] autorelease];
    [config setSlFlag:_currentSLFLag];
    [config setSession:_currentSession];
    [config setInventoryState:_currentInventoryState];
    [config setTagPopulation:_currentTagPopulation];
    return config;
}

- (BOOL)isSingulationConfigEqual:(zt_SledConfiguration *)sled
{
    if(_currentSession != sled.currentSession)
        return NO;
    if(_currentInventoryState != sled.currentInventoryState)
        return NO;
    if(_currentSLFLag != sled.currentSLFLag)
        return NO;
    if(_currentTagPopulation != sled.currentTagPopulation)
        return NO;
    return YES;
}

- (BOOL)isSingulationConfigValid
{
    if ([self checkForMin:ZT_SLED_CFG_NAME_SINGULATION_TAG_POPULATION_MIN forMax:ZT_SLED_CFG_NAME_SINGULATION_TAG_POPULATION_MAX withValue:_currentTagPopulation])
        return YES;
    else
        return NO;
}

/* Tag Report */

- (void)setTagReportOptionsWithConfig:(srfidTagReportConfig *)config
{
    _tagReportChannelIdx = [config getIncChannelIdx];
    _tagReportFirstSeenTime = [config getIncFirstSeenTime];
    _tagReportLastSeenTime = [config getIncLastSeenTime];
    _tagReportPC = [config getIncPC];
    _tagReportPhase = [config getIncPhase];
    _tagReportRSSI = [config getIncRSSI];
    _tagReportSeenCount = [config getIncTagSeenCount];
    /* nrv364: disable not used fields */
    _tagReportFirstSeenTime = NO;
    _tagReportLastSeenTime = NO;
   // _tagReportSeenCount = NO;
}

- (srfidTagReportConfig *)getTagReportConfig
{
    srfidTagReportConfig *config = [[[srfidTagReportConfig alloc] init] autorelease];
    [config setIncChannelIdx:_tagReportChannelIdx];
    [config setIncFirstSeenTime:_tagReportFirstSeenTime];
    [config setIncLastSeenTime:_tagReportLastSeenTime];
    [config setIncPC:_tagReportPC];
    [config setIncPhase:_tagReportPhase];
    [config setIncRSSI:_tagReportRSSI];
    [config setIncTagSeenCount:_tagReportSeenCount];
    return config;
}

- (srfidReportConfig *)getReportConfig
{
    srfidReportConfig *config = [[[srfidReportConfig alloc] init] autorelease];
    [config setIncChannelIndex:_tagReportChannelIdx];
    [config setIncFirstSeenTime:_tagReportFirstSeenTime];
    [config setIncLastSeenTime:_tagReportLastSeenTime];
    [config setIncPC:_tagReportPC];
    [config setIncPhase:_tagReportPhase];
    [config setIncRSSI:_tagReportRSSI];
    [config setIncTagSeenCount:_tagReportSeenCount];
    return config;
}

- (srfidReportConfig *)getReportConfigAllOff
{
    srfidReportConfig *config = [[[srfidReportConfig alloc] init] autorelease];
    [config setIncChannelIndex:NO];
    [config setIncFirstSeenTime:NO];
    [config setIncLastSeenTime:NO];
    [config setIncPC:NO];
    [config setIncPhase:NO];
    [config setIncRSSI:NO];
    [config setIncTagSeenCount:NO];
    return config;

}

- (BOOL)isTagReporConfigEqual:(zt_SledConfiguration *)sled
{
    if(_tagReportChannelIdx != sled.tagReportChannelIdx)
        return NO;
    if(_tagReportFirstSeenTime != sled.tagReportFirstSeenTime)
        return NO;
    if(_tagReportLastSeenTime != sled.tagReportLastSeenTime)
        return NO;
    if(_tagReportPC != sled.tagReportPC)
        return NO;
    if(_tagReportPhase != sled.tagReportPhase)
        return NO;
    if(_tagReportRSSI != sled.tagReportRSSI)
        return NO;
    if(_tagReportSeenCount != sled.tagReportSeenCount)
       return NO;
    if(_currentBatchMode != sled.currentBatchMode)
        return NO;
    
    return YES;
}

/* beeper */

- (void)setBeeperOptionsWithConfig:(SRFID_BEEPERCONFIG)config
{
    if (SRFID_BEEPERCONFIG_HIGH == config)
    {
        _currentBeeperEnable = YES;
        _currentBeeperLevel = SRFID_BEEPERCONFIG_HIGH;
    }
    else if (SRFID_BEEPERCONFIG_MEDIUM == config)
    {
        _currentBeeperEnable = YES;
        _currentBeeperLevel = SRFID_BEEPERCONFIG_MEDIUM;
    }
    else if (SRFID_BEEPERCONFIG_LOW == config)
    {
        _currentBeeperEnable = YES;
        _currentBeeperLevel = SRFID_BEEPERCONFIG_LOW;
    }
    else if (SRFID_BEEPERCONFIG_QUIET == config)
    {
        _currentBeeperEnable = NO;
        /* don't override UI level for disabled beeper */
        //_currentBeeperLevel = SRFID_BEEPERCONFIG_MEDIUM;
    }
}

- (SRFID_BEEPERCONFIG)getBeeperConfig
{
    SRFID_BEEPERCONFIG beeper = SRFID_BEEPERCONFIG_QUIET;
    
    if (YES == _currentBeeperEnable)
    {
        switch (_currentBeeperLevel) {
            case SRFID_BEEPERCONFIG_HIGH:
                beeper = SRFID_BEEPERCONFIG_HIGH;
                break;
            case SRFID_BEEPERCONFIG_MEDIUM:
                beeper = SRFID_BEEPERCONFIG_MEDIUM;
                break;
            case SRFID_BEEPERCONFIG_LOW:
                beeper = SRFID_BEEPERCONFIG_LOW;
                break;
            case SRFID_BEEPERCONFIG_QUIET:
                beeper = SRFID_BEEPERCONFIG_QUIET;
                break;
        }
    }
    
    return beeper;
}

- (BOOL)isBeeperConfigEqual:(zt_SledConfiguration *)sled
{
    if (_currentBeeperEnable != sled.currentBeeperEnable)
    {
        return NO;
    }
    
    if (YES == sled.currentBeeperEnable)
    {
        if (_currentBeeperLevel != sled.currentBeeperLevel)
        {
            return NO;
        }
    }
    return YES;
}

#pragma mark - trigger settings
- (void)setStartTriggerOptionWithConfig:(srfidStartTriggerConfig *)config
{
    BOOL onHandheldTrigger = [config getStartOnHandheldTrigger];
    _currentStartTriggerType = [config getTriggerType];
    BOOL repeat = [config getRepeatMonitoring];
    
    if (onHandheldTrigger)
    {
        _currentStartTriggerOption = ZT_SLED_CFG_TRIGGER_START_HANDHELD;
        _currentStartDelay = 0;
    }
    else if (repeat)
    {
        _currentStartTriggerOption = ZT_SLED_CFG_TRIGGER_START_PERIODIC;
        _currentStartDelay = [config getStartDelay];
    }
    else
    {
        _currentStartTriggerOption = ZT_SLED_CFG_TRIGGER_START_IMMEDIATE;
        _currentStartDelay = 0;
        
    }
}

- (void)setStopTriggerOptionWithConfig:(srfidStopTriggerConfig *)config
{
    BOOL onHanheldTrigger = [config getStopOnHandheldTrigger];
    _currentStopTriggerType = [config getTriggerType];
    BOOL onTagCount = [config getStopOnTagCount];
    BOOL onTimeout = [config getStopOnTimeout];
    BOOL onInventoryCount = [config getStopOnInventoryCount];
    _currentStopInventoryCount =[config getStopInventoryCount];
    //    _currentStopOnAccessCount  = [config getStopOnAccessCount];
    //    _currentStopAccessCount = [NSNumber numberWithInt:[config getStopAccessCount]];
    
    int timeout = 0;
    if (YES == onTimeout)
    {
        timeout = [config getStopTimeout];
    }
    
    if (YES == onHanheldTrigger)
    {
        _currentStopTriggerOption = ZT_SLED_CFG_TRIGGER_STOP_HANDHELD;
        _currentStopTagCount = 0;
        _currentStopTimeout = timeout;
        _currentStopInventoryCount = 0;
    }
    else if (YES == onTagCount)
    {
        _currentStopTriggerOption = ZT_SLED_CFG_TRIGGER_STOP_TAG_OBSERVATION;
        _currentStopTagCount = [config getStopTagCount];
        _currentStopTimeout = timeout;
        _currentStopInventoryCount = 0;
    }
    else if (YES == onInventoryCount)
    {
        _currentStopTriggerOption = ZT_SLED_CFG_TRIGGER_STOP_N_ATTEMPTS;
        _currentStopTagCount = 0;
        _currentStopTimeout = timeout;
        _currentStopInventoryCount =[config getStopInventoryCount];
    }
    else if (YES == onTimeout)
    {
        _currentStopTriggerOption = ZT_SLED_CFG_TRIGGER_STOP_DURATION;
        _currentStopTagCount = 0;
        _currentStopTimeout = timeout;
        _currentStopInventoryCount = 0;
    }
    else
    {
        _currentStopTriggerOption = ZT_SLED_CFG_TRIGGER_START_IMMEDIATE;
        _currentStopTagCount = 0;
        _currentStopTimeout = 0;
        _currentStopInventoryCount = 0;
    }
}

- (srfidStartTriggerConfig *)getStartTriggerConfig
{
    srfidStartTriggerConfig *config = [[[srfidStartTriggerConfig alloc] init] autorelease];
    [config setTriggerType:_currentStartTriggerType];
    
    switch (_currentStartTriggerOption) {
        case ZT_SLED_CFG_TRIGGER_START_IMMEDIATE:
            [config setStartOnHandheldTrigger:NO];
            [config setRepeatMonitoring:NO];
            [config setStartDelay:0];
            break;
        
        case ZT_SLED_CFG_TRIGGER_START_PERIODIC:
            [config setStartOnHandheldTrigger:NO];
            [config setRepeatMonitoring:YES];
            [config setStartDelay:(unsigned int)_currentStartDelay];
            break;
        
        case ZT_SLED_CFG_TRIGGER_START_HANDHELD:
            [config setStartOnHandheldTrigger:YES];
            [config setRepeatMonitoring:YES]; /* nrv364 */
            [config setStartDelay:0];
            break;
        default:
            break;
    }
    return config;
}

- (srfidStopTriggerConfig *)getStopTriggerConfig
{
    srfidStopTriggerConfig *config = [[[srfidStopTriggerConfig alloc] init] autorelease];
    [config setTriggerType:_currentStopTriggerType];
    
    
    // onAccessCount is not used now, so it is not changed
    //[config setStopOnAccessCount:_currentStopOnAccessCount];
    //[config setStopAccessCount:[_currentStopAccessCount intValue]];
    
    
    switch (_currentStopTriggerOption) {
        case ZT_SLED_CFG_TRIGGER_STOP_IMMEDIATE:
            [config setStopOnHandheldTrigger:NO];
            [config setStopOnTagCount:NO];
            [config setStopOnTimeout:NO];
            [config setStopOnInventoryCount:NO];
            [config setStopTagCount:0];
            [config setStopTimout:0];
            [config setStopInventoryCount:0];
            break;
        case ZT_SLED_CFG_TRIGGER_STOP_HANDHELD:
            [config setStopOnHandheldTrigger:YES];
            [config setStopOnTagCount:NO];
            [config setStopOnTimeout:YES];
            [config setStopOnInventoryCount:NO];
            [config setStopTagCount:0];
            [config setStopTimout:(unsigned int)_currentStopTimeout];
            [config setStopInventoryCount:0];

            break;
        case ZT_SLED_CFG_TRIGGER_STOP_DURATION:
            [config setStopOnHandheldTrigger:NO];
            [config setStopOnTagCount:NO];
            [config setStopOnTimeout:YES];
            [config setStopOnInventoryCount:NO];
            [config setStopTagCount:0];
            [config setStopTimout:(unsigned int)_currentStopTimeout];
            [config setStopInventoryCount:0];

            break;
        case ZT_SLED_CFG_TRIGGER_STOP_TAG_OBSERVATION:
            [config setStopOnHandheldTrigger:NO];
            [config setStopOnTagCount:YES];
            [config setStopOnTimeout:YES];
            [config setStopOnInventoryCount:NO];
            [config setStopTagCount:(unsigned int)_currentStopTagCount];
            [config setStopTimout:(unsigned int)_currentStopTimeout];
            [config setStopInventoryCount:0];
            break;
            
        case ZT_SLED_CFG_TRIGGER_STOP_N_ATTEMPTS:
            [config setStopOnHandheldTrigger:NO];
            [config setStopOnTagCount:NO];
            [config setStopOnTimeout:YES];
            [config setStopOnInventoryCount:YES];
            [config setStopTagCount:0];
            [config setStopTimout:(unsigned int)_currentStopTimeout];
            [config setStopInventoryCount:(unsigned int)_currentStopInventoryCount];
            break;
            
        default:
            break;
    }
    return config;
}

- (BOOL)isStartTriggerConfigEqual:(zt_SledConfiguration *)sled
{
    if (_currentStartTriggerOption != sled.currentStartTriggerOption)
        return NO;
    
    switch (_currentStartTriggerOption) {
        case ZT_SLED_CFG_TRIGGER_START_HANDHELD:
            if (_currentStartTriggerType != sled.currentStartTriggerType)
                return NO;
            break;
        
        case ZT_SLED_CFG_TRIGGER_START_PERIODIC:
            if (_currentStartDelay != sled.currentStartDelay)
                return NO;
            break;
            
        default:
            break;
    }
    
    return YES;
}

- (BOOL)isStartTriggerConfigValid
{
       switch (_currentStartTriggerOption) {
        case ZT_SLED_CFG_TRIGGER_START_PERIODIC:
            return [self checkForMinLL:ZT_TRIGGER_MIN forMax:ZT_TRIGGER_MAX withValue:_currentStartDelay];
            break;
            
        default:
            break;
    }
    
    return YES;
}
- (BOOL)isStopTriggerConfigEqual:(zt_SledConfiguration *)sled
{
    if (_currentStopTriggerOption != sled.currentStopTriggerOption)
        return NO;
    
    switch (_currentStopTriggerOption) {
        case ZT_SLED_CFG_TRIGGER_STOP_HANDHELD:
            if (_currentStopTriggerType != sled.currentStopTriggerType)
                return NO;
            if (_currentStopTimeout != sled.currentStopTimeout)
                return NO;
            break;
        case ZT_SLED_CFG_TRIGGER_STOP_DURATION:
            if (_currentStopTimeout != sled.currentStopTimeout)
                return NO;
            break;
        case ZT_SLED_CFG_TRIGGER_STOP_TAG_OBSERVATION:
            if (_currentStopTagCount != sled.currentStopTagCount)
                return NO;
            if (_currentStopTimeout != sled.currentStopTimeout)
                return NO;
            break;
            
        case ZT_SLED_CFG_TRIGGER_STOP_N_ATTEMPTS:
            if (_currentStopInventoryCount != sled.currentStopInventoryCount)
                return NO;
            if (_currentStopTimeout != sled.currentStopTimeout)
                return NO;
            break;
            
        default:
            break;
    }
    
    return YES;
}

- (BOOL)isStopTriggerConfigValid
{
    switch (_currentStopTriggerOption) {
        case ZT_SLED_CFG_TRIGGER_STOP_HANDHELD:
            if (![self checkForMinLL:ZT_TRIGGER_MIN forMax:ZT_TRIGGER_MAX withValue:_currentStopTimeout])
                return NO;
            break;
            
        case ZT_SLED_CFG_TRIGGER_STOP_DURATION:
            if (![self checkForMinLL:ZT_TRIGGER_MIN forMax:ZT_TRIGGER_MAX withValue:_currentStopTimeout])
                return NO;
            break;
            
        case ZT_SLED_CFG_TRIGGER_STOP_TAG_OBSERVATION:
            if (![self checkForMinLL:ZT_TRIGGER_MIN forMax:ZT_TRIGGER_MAX withValue:_currentStopTagCount])
                return NO;
            if (![self checkForMinLL:ZT_TRIGGER_MIN forMax:ZT_TRIGGER_MAX withValue:_currentStopTimeout])
                return NO;
            break;
            
        case ZT_SLED_CFG_TRIGGER_STOP_N_ATTEMPTS:
            if (![self checkForMinLL:ZT_TRIGGER_MIN forMax:ZT_TRIGGER_MAX withValue:_currentStopInventoryCount])
                return NO;
            if (![self checkForMinLL:ZT_TRIGGER_MIN forMax:ZT_TRIGGER_MAX withValue:_currentStopTimeout])
                return NO;
            break;
            
        default:
            break;
    }
    
    return YES;
}


- (BOOL)isStartTriggerRepeatMonitoring;
{
    return (ZT_SLED_CFG_TRIGGER_START_IMMEDIATE != _currentStartTriggerOption);
}

- (BOOL)isStartTriggerPeriodic
{
    return (ZT_SLED_CFG_TRIGGER_START_PERIODIC == _currentStartTriggerOption);
}

- (BOOL)isStartTriggerImmediate
{
    return (ZT_SLED_CFG_TRIGGER_START_IMMEDIATE == _currentStartTriggerOption);
}

- (BOOL)isStartTriggerHandheld
{
    return (ZT_SLED_CFG_TRIGGER_START_HANDHELD == _currentStartTriggerOption);
}

- (BOOL)isStopTriggerHandheld
{
    return (ZT_SLED_CFG_TRIGGER_STOP_HANDHELD == _currentStopTriggerOption);
}

- (BOOL)isStopTriggerImmediate
{
    return (ZT_SLED_CFG_TRIGGER_STOP_IMMEDIATE == _currentStopTriggerOption);
}


#pragma mark - regulatory settings
-(void)setRegions:(NSMutableArray *)regionOptions
{
    if (_regionOptions == regionOptions) {
        return;
    }
    
    NSMutableArray *oldValue = _regionOptions;
    
    if (regionOptions != nil)
    {
        _regionOptions = [regionOptions copy];
    }
    else
    {
        _regionOptions = nil;
    }
    
    if (oldValue != nil)
    {
        [oldValue release];
    }
}

-(void)setSupportedRegions:(NSMutableArray *)supportedRegions
{
    if (_supportedRegions == supportedRegions) {
        return;
    }
    NSMutableArray *oldValue = _supportedRegions;
    if (supportedRegions != nil)
    {
        _supportedRegions = [supportedRegions copy];
    }
    else
    {
        _supportedRegions = nil;
    }
    if (oldValue != nil)
    {
        [oldValue release];
    }
}

- (void)setRegulatoryOptionsWithConfig:(srfidRegulatoryConfig *)config
{
    NSMutableArray *oldValue = _currentRegionChannelList;
    _currentRegionChannelList = [[config getEnabledChannelsList] mutableCopy];
    [oldValue release];
    
    NSString * oldCode = _currentRegionCode;
    _currentRegionCode = [[config getRegionCode] copy];
    [oldCode release];
    
    /* nrv364: app is not aware of hopping configuration */
    _currentRegionHoppingEnabled = (SRFID_HOPPINGCONFIG_ENABLED == [config getHoppingConfig]);
}

- (srfidRegulatoryConfig *)getRegulatoryConfig
{
    srfidRegulatoryConfig *config = [[[srfidRegulatoryConfig alloc] init] autorelease];
    
    [config setRegionCode:_currentRegionCode];
   
    /* nrv364: does NOT change hopping configuration from app */
    /* otherwise update & use _currentRegionHoppingEnabled */
    [config setHoppingConfig:SRFID_HOPPINGCONFIG_DEFAULT];
    
    /* nrv364: reader responds with "Hopping configuration is not supported" if we send
     setregulatory ASCII with enabled channels list for regions w/o hopping
     configuration enabled */
    
    if (NSOrderedSame != [_currentRegionCode caseInsensitiveCompare:@"NA"])
    {
        int idx = [self indexOfCurrentRegion];
        if (idx >= 0)
        {
            zt_RegionData *rdata = (zt_RegionData*)[_regionOptions objectAtIndex:idx];
            if (YES == rdata.hoppingConfigurable)
            {
                [config setEnabledChannelsList:_currentRegionChannelList];
            }
        }
    }
    
    return config;
}

- (BOOL)isRegulatoryConfigEqual:(zt_SledConfiguration *)sled
{
    if (![_currentRegionCode isEqualToString:sled.currentRegionCode]) {
        return NO;
    }
    
    /* nrv364 compare enabled channels */
    
    /* count */
    if ([_currentRegionChannelList count] != [sled.currentRegionChannelList count])
    {
        return NO;
    }
    
    /* 2nd contains each elem from 1st */
    
    BOOL found = NO;
    for (NSString *_ch1 in _currentRegionChannelList)
    {
        found = NO;
        for (NSString *_ch2 in sled.currentRegionChannelList)
        {
            if (YES == [_ch1 isEqualToString:_ch2])
            {
                found = YES;
                break;
            }
        }
        if (NO == found)
        {
            return NO;
        }
    }
    
    
    return YES;
}

- (int)indexOfCurrentRegion
{
    for (int i = 0; i < [_regionOptions count]; i++)
    {
        zt_RegionData *region = [_regionOptions objectAtIndex:i];
                    
        if ([_currentRegionCode isEqualToString:region.regionCode])
        {
            return i;
        }
    }
    
    return -1;
}

- (int)indexOfRegionWithName:(NSString *)name
{
    for (int i = 0; i < [_regionOptions count]; i++)
    {
        zt_RegionData *region = [_regionOptions objectAtIndex:i];
        
        if ([name isEqualToString:region.regionName])
        {
            return i;
        }
    }
    
    return -1;
}

- (BOOL)isChannelEnabled:(NSString*)channel forRegion:(NSString*)region_code;
{
    
    zt_RegionData *rdata = (zt_RegionData*)[_regionOptions objectAtIndex:[self indexOfCurrentRegion]];
    
    if (YES == [[rdata regionCode] isEqualToString:region_code])
    {
        for (NSString *enabled_channel in _currentRegionChannelList)
        {
            if (YES == [enabled_channel isEqualToString:channel])
            {
                return YES;
            }
        }
    }
    
    return NO;
}

- (void)fillCurrentRegionChannelsListDefault
{
    zt_RegionData *rdata = (zt_RegionData*)[_regionOptions objectAtIndex:[self indexOfCurrentRegion]];
    [_currentRegionChannelList removeAllObjects];
    /* nrb364:
      - enable all supported channels for regions w/o hopping configuration enabled
      - disable all supported channels to allow user selection for regions w/ hopping configuration enabled */
    if (NO == rdata.hoppingConfigurable)
    {
        [_currentRegionChannelList addObjectsFromArray:[rdata supporteChannels]];
    }
}

- (void)enableCurrentRegionChannel:(NSString*)channel
{
    BOOL already_enabled = NO;
    
    for (NSString *_ch in _currentRegionChannelList)
    {
        if (YES == [channel isEqualToString:_ch])
        {
            already_enabled = YES;
            break;
        }
    }
    
    if (NO == already_enabled)
    {
        [_currentRegionChannelList addObject:channel];
    }
}

- (void)disableCurrentRegionChannel:(NSString*)channel
{
    int idx_to_remove = -1;
    int i = 0;
    for (NSString *_ch in _currentRegionChannelList)
    {
        if (YES == [channel isEqualToString:_ch])
        {
            idx_to_remove = i;
            break;
        }
        i++;
    }
    
    if (-1 != idx_to_remove)
    {
        [_currentRegionChannelList removeObjectAtIndex:idx_to_remove];
    }
}

#pragma mark - capabilities
- (void)setCapabilityOptionWithInfo:(srfidReaderCapabilitiesInfo *)info
{
    if (_readerSerialNumber != nil) {
        [_readerSerialNumber release];
        [_readerModel release];
        [_readerManufacturer release];
        [_readerManufacturingDate release];
        [_readerScannerName release];
        [_readerAsciiVersion release];
        [_readerAirProtocolVersion release];
        [_readerBTAddress release];
    }
    
    _readerSerialNumber = [[info getSerialNumber] retain];
    _readerModel = [[info getModel] retain];
    _readerManufacturer = [[info getManufacturer] retain];
    _readerManufacturingDate = [[info getManufacturingDate] retain];
    _readerScannerName = [[info getScannerName] retain];
    _readerAsciiVersion = [[info getAsciiVersion] retain];
    _readerSelectFilterNum = [info getSelectFilterNum];
    _readerMinPower = [info getMinPower] ;
    _readerMaxPower = [info getMaxPower];
    _readerPowerStep = [info getPowerStep];
    _readerAirProtocolVersion = [[info getAirProtocolVersion] retain];
    _readerBTAddress = [[info getBDAddress] retain];
    _readerMaxAccessSequence = [info getMaxAccessSequence];
    
    
    if (0 == _readerMinPower)
    {
        _readerMinPower = ZT_SLED_ANTENNA_POWER_MIN;
    }
    
    if (0 == _readerMaxPower)
    {
        _readerMaxPower = ZT_SLED_ANTENNA_POWER_MAX;
    }
    
    // options for antenna
    [_antennaPowerLevelsArray removeAllObjects];
    for (float value = _readerMinPower; value <= _readerMaxPower ; value += ZT_SLED_ANTENNA_POWER_STEP) {
        [_antennaPowerLevelsArray addObject:[NSNumber numberWithFloat:(value / ZT_SLED_ANTENNA_POWER_MEASUREMENT_MULT)]];
    }
}

#pragma mark - version
- (void)setReaderVersionWithInfo:(srfidReaderVersionInfo *)info
{
    if(_readerBluetoothVersion != nil)
    {
        [_readerDeviceVersion release];
        [_readerBluetoothVersion release];
        [_readerNGEVersion release];
        [_readerPL33 release];
    }
    
    _readerDeviceVersion = [[info getDeviceVersion] retain];
    _readerBluetoothVersion = [[info getBluetoothVersion] retain];
    _readerNGEVersion = [[info getNGEVersion] retain];
    _readerPL33 = [[info getPL33] retain];
}

#pragma mark - prefilters

-(void)setPrefiltersFromConfig:(NSMutableArray *)prefiltersFromReader
{
    NSMutableArray *prefilters = [zt_SledConfiguration getPrefiltersArrayCopy:prefiltersFromReader];
//    NSMutableArray *prefilters = prefiltersFromReader;
    int size = (int)[prefilters count];
    if (size > 2)
    {
        for (int i = 2; i < size ; i++)
        {
            [prefilters removeObjectAtIndex:i];
        }
    }
    
    if (size == 0) {
        // keep default option
        _applyFirstFilter = NO;
        _applySecondFilter = NO;
    }
    else if ([prefilters count] == 1)
    {
        // check is it first or second filter in UI
        if ([zt_SledConfiguration isPrefilterEqual:prefilters[0] withPrefilter:_currentPrefilters[0]])
        {
            [_currentPrefilters replaceObjectAtIndex:0 withObject:[prefilters objectAtIndex:0]];
            _applyFirstFilter = YES;
            _applySecondFilter = NO;
        }
        else if([zt_SledConfiguration isPrefilterEqual:prefilters[0] withPrefilter:_currentPrefilters[1]])
        {
            [_currentPrefilters replaceObjectAtIndex:1 withObject:[prefilters objectAtIndex:0]];
            _applyFirstFilter = NO;
            _applySecondFilter = YES;
        }
        else
        {
            [_currentPrefilters replaceObjectAtIndex:0 withObject:[prefilters objectAtIndex:0]];
            _applyFirstFilter = YES;
            _applySecondFilter = NO;
        }
        
    }
    else if([prefilters count] == 2)
    {
        int pref1idx = -1;
        if ([zt_SledConfiguration isPrefilterEqual:prefilters[0] withPrefilter:_currentPrefilters[0]])
        {
            [_currentPrefilters replaceObjectAtIndex:0 withObject:[prefilters objectAtIndex:0]];
            pref1idx = 0;
        }
        else if([zt_SledConfiguration isPrefilterEqual:prefilters[0] withPrefilter:_currentPrefilters[1]])
        {
            [_currentPrefilters replaceObjectAtIndex:1 withObject:[prefilters objectAtIndex:0]];
            pref1idx = 1;
        }
        
        if (pref1idx != -1) {
            if (pref1idx == 0)
            {
                [_currentPrefilters replaceObjectAtIndex:1 withObject:[prefilters objectAtIndex:1]];
            }
            else if(pref1idx == 1)
            {
                [_currentPrefilters replaceObjectAtIndex:0 withObject:[prefilters objectAtIndex:1]];
            }
            _applyFirstFilter = YES;
            _applySecondFilter = YES;
        }
        else
        {
            int pref2idx = -1;
            if ([zt_SledConfiguration isPrefilterEqual:prefilters[1] withPrefilter:_currentPrefilters[0]])
            {
                [_currentPrefilters replaceObjectAtIndex:0 withObject:[prefilters objectAtIndex:1]];
                pref2idx = 0;
            }
            else if ([zt_SledConfiguration isPrefilterEqual:prefilters[1] withPrefilter:_currentPrefilters[1]])
            {
                [_currentPrefilters replaceObjectAtIndex:1 withObject:[prefilters objectAtIndex:1]];
                pref2idx = 1;
            }
            
            if (pref2idx != -1) {
                if (pref2idx == 0) {
                    [_currentPrefilters replaceObjectAtIndex:1 withObject:[prefilters objectAtIndex:0]];
                }
                if (pref2idx == 1) {
                    [_currentPrefilters replaceObjectAtIndex:0 withObject:[prefilters objectAtIndex:0]];
                }
                _applyFirstFilter = YES;
                _applySecondFilter = YES;
            }
            else
            {
                [_currentPrefilters replaceObjectAtIndex:0 withObject:[prefilters objectAtIndex:0]];
                [_currentPrefilters replaceObjectAtIndex:1 withObject:[prefilters objectAtIndex:1]];
                _applyFirstFilter = YES;
                _applySecondFilter = YES;
            }
        }
    }
    
    //[prefilters release];
}

+ (NSMutableArray*)getPrefiltersArrayCopy:(NSMutableArray *)array
{
    NSMutableArray *newArray = [[[NSMutableArray alloc] initWithCapacity:[array count]] autorelease];
    for (int i=0; i < [array count]; i++)
    {
        srfidPreFilter *emptyPrefilter = [[srfidPreFilter alloc] init];
        [emptyPrefilter setTarget:[array[i] getTarget]];
        [emptyPrefilter setAction:[array[i] getAction]];
        [emptyPrefilter setMemoryBank:[array[i] getMemoryBank]];
        [emptyPrefilter setMaskStartPos:[array[i] getMaskStartPos]];
        [emptyPrefilter setMatchPattern:[[array[i] getMatchPattern] copy]];
        [newArray addObject:emptyPrefilter];
        [emptyPrefilter release];
    }
    return newArray;
}

- (void)addEmptyPrefilterToArray:(NSMutableArray *)array
{
    srfidPreFilter *emptyPrefilter = [[srfidPreFilter alloc] init];
    [emptyPrefilter setTarget:SRFID_SELECTTARGET_S0];
    [emptyPrefilter setAction:SRFID_SELECTACTION_INV_A__OR__ASRT_SL];
    [emptyPrefilter setMemoryBank:SRFID_MEMORYBANK_USER];
    [emptyPrefilter setMaskStartPos:0];
    [emptyPrefilter setMatchPattern:@""];
    [array addObject:emptyPrefilter];
    [emptyPrefilter release];
}

-(BOOL)prefilterEnabled
{
    if (_currentPrefilterIndex == 0)
    {
        return _applyFirstFilter;
    }
    else if (_currentPrefilterIndex == 1)
    {
        return _applySecondFilter;
    }
    return NO;
}

-(NSString *)prefilterTagPattern
{
    if ([_currentPrefilters count] <= _currentPrefilterIndex) {
        return @"";
    }
    
    srfidPreFilter *prefilter = [_currentPrefilters objectAtIndex:_currentPrefilterIndex];
    
    NSString *tagPattern = [prefilter getMatchPattern];
    
    return tagPattern;
}

-(NSString *)prefilterTagert
{
    if ([_currentPrefilters count] <= _currentPrefilterIndex) {
        return nil;
    }
    
    srfidPreFilter *prefilter = [_currentPrefilters objectAtIndex:_currentPrefilterIndex];
    
    SRFID_SELECTTARGET target = [prefilter getTarget];
    
    NSString *targetStr = [[_mapperTargetOption getDictionary] objectForKey:[NSNumber numberWithInt:target]];
    
    return targetStr;
}

-(NSString *)prefilterAction
{
    if ([_currentPrefilters count] <= _currentPrefilterIndex) {
        return nil;
    }
    
    srfidPreFilter *prefilter = [_currentPrefilters objectAtIndex:_currentPrefilterIndex];
    
    SRFID_SELECTACTION action = [prefilter getAction];
    
    NSString *actionStr = [[_mapperAction getDictionary] objectForKey:[NSNumber numberWithInt:action]];
    
    return actionStr;
}

-(NSString *)prefilterMemoryBank
{
    if ([_currentPrefilters count] <= _currentPrefilterIndex) {
        return nil;
    }
    
    srfidPreFilter *prefilter = [_currentPrefilters objectAtIndex:_currentPrefilterIndex];
    SRFID_MEMORYBANK memoryBank = [prefilter getMemoryBank];
    NSString *memoryStr = [[_mapperBankPrefilters getDictionary] objectForKey:[NSNumber numberWithInt:memoryBank]];
    return memoryStr;
}

-(NSNumber *)prefilterOffset
{
    if ([_currentPrefilters count] <= _currentPrefilterIndex) {
        return nil;
    }
    
    srfidPreFilter *prefilter = [_currentPrefilters objectAtIndex:_currentPrefilterIndex];
    NSNumber *offset = [NSNumber numberWithInt:[prefilter getMaskStartPos]];
    return offset;
}

- (void)setPrefilterEnabled:(BOOL)value
{
    if(_currentPrefilterIndex == 0)
    {
        _applyFirstFilter = value;
    }
    else if(_currentPrefilterIndex == 1)
    {
        _applySecondFilter = value;
    }
    
}
- (void)setPrefilterTagPattern:(NSString *)value
{
    srfidPreFilter *prefilter = [_currentPrefilters objectAtIndex:_currentPrefilterIndex];
    [prefilter setMatchPattern:value];
    
}
- (void)setPrefilterTarget:(NSString *)value
{
    srfidPreFilter *prefilter = [_currentPrefilters objectAtIndex:_currentPrefilterIndex];
    SRFID_SELECTTARGET target = [[zt_SledConfiguration getKeyFromDictionary:[_mapperTargetOption getDictionary] withValue:value] intValue];
    [prefilter setTarget:target];
}

- (void)setPrefilterAction:(NSString *)value
{
    srfidPreFilter *prefilter = [_currentPrefilters objectAtIndex:_currentPrefilterIndex];
    SRFID_SELECTACTION action = [[zt_SledConfiguration getKeyFromDictionary:[_mapperAction getDictionary] withValue:value] intValue];
    [prefilter setAction:action];
}
- (void)setPrefilterMemoryBank:(NSString *)value
{
    srfidPreFilter *prefilter = [_currentPrefilters objectAtIndex:_currentPrefilterIndex];
    SRFID_MEMORYBANK bank = [[zt_SledConfiguration getKeyFromDictionary:[_mapperBankPrefilters getDictionary] withValue:value]intValue];
    [prefilter setMemoryBank:bank];
    
}
- (void)setPrefilterOffset:(NSNumber *)value
{
    srfidPreFilter *prefilter = [_currentPrefilters objectAtIndex:_currentPrefilterIndex];
    [prefilter setMaskStartPos:[value intValue]];
}

- (void)copyFirstFilerConfig:(srfidPreFilter*)prefilter
{
    srfidPreFilter *emptyPrefilter = _currentPrefilters[0];
    [emptyPrefilter setTarget:[prefilter getTarget]];
    [emptyPrefilter setAction:[prefilter getAction]];
    [emptyPrefilter setMemoryBank:[prefilter getMemoryBank]];
    [emptyPrefilter setMaskStartPos:[prefilter getMaskStartPos]];
    [emptyPrefilter setMatchPattern:[[prefilter getMatchPattern] copy]];
}
- (void)copySecondFilterConfig:(srfidPreFilter*)prefilter;
{
    srfidPreFilter *emptyPrefilter = _currentPrefilters[1];
    [emptyPrefilter setTarget:[prefilter getTarget]];
    [emptyPrefilter setAction:[prefilter getAction]];
    [emptyPrefilter setMemoryBank:[prefilter getMemoryBank]];
    [emptyPrefilter setMaskStartPos:[prefilter getMaskStartPos]];
    [emptyPrefilter setMatchPattern:[[prefilter getMatchPattern] copy]];
}

+ (BOOL)isPrefilterEqual:(srfidPreFilter*)prefilterOne withPrefilter:(srfidPreFilter*)prefilterTwo
{
    if ([prefilterOne getAction] != [prefilterTwo getAction])
    {
        return NO;
    }
    if ([prefilterOne getMaskStartPos] != [prefilterTwo getMaskStartPos])
    {
        return NO;
    }
    if (![[prefilterOne getMatchPattern] isEqualToString:[prefilterTwo getMatchPattern]])
    {
        return NO;
    }
    if ([prefilterOne getMemoryBank] != [prefilterTwo getMemoryBank])
    {
        return NO;
    }
    if ([prefilterOne getTarget] != [prefilterTwo getTarget])
    {
        return NO;
    }
    
    return YES;
}

- (BOOL)isPrefilterValid:(srfidPreFilter *)prefilter
{
    int offset = [prefilter getMaskStartPos];
    if (offset < ZT_PREFILTERS_OFFSET_MIN || offset > ZT_PREFILTERS_OFFSET_MAX)
    {
        return NO;
    }
    return YES;
}

#pragma mark - old methods

/* tag report settings */

- (NSArray*)getConfigTagReportOptions
{
    return m_ConfigTagReportOptions;
}

#pragma mark - helper methods

- (BOOL)checkForMin:(int)min forMax:(int)max withValue:(int)value
{
    if (value < min || value > max) {
        return NO;
    }
    return YES;
}

- (BOOL)checkForMinLL:(long long)min forMax:(long long)max withValue:(long long)value
{
    if (value < min || value > max) {
        return NO;
    }
    return YES;
}

#pragma mark - Batch Mode Settings

-(void) setBatchModeOptionsWithConfig:(SRFID_BATCHMODECONFIG)config
{
    if (SRFID_BATCHMODECONFIG_ENABLE == config)
    {
        _currentBatchMode = SRFID_BATCHMODECONFIG_ENABLE;
    }
    else if (SRFID_BATCHMODECONFIG_AUTO == config)
    {
        _currentBatchMode = SRFID_BATCHMODECONFIG_AUTO;
    }
    else if (SRFID_BATCHMODECONFIG_DISABLE == config)
    {
        _currentBatchMode = SRFID_BATCHMODECONFIG_DISABLE;
    }
}


-(SRFID_BATCHMODECONFIG) getBatchModeConfig
{
    SRFID_BATCHMODECONFIG batchMode = SRFID_BATCHMODECONFIG_AUTO;
    
    switch (_currentBatchMode) {
        case SRFID_BATCHMODECONFIG_ENABLE:
            batchMode = SRFID_BATCHMODECONFIG_ENABLE;
            break;
        case SRFID_BATCHMODECONFIG_AUTO:
            batchMode = SRFID_BATCHMODECONFIG_AUTO;
            break;
        case SRFID_BATCHMODECONFIG_DISABLE:
            batchMode = SRFID_BATCHMODECONFIG_DISABLE;
            break;
    }
    
    return batchMode;
}


-(BOOL) isBatchModeConfigEqual:(zt_SledConfiguration *)sled
{
    if(_currentBatchMode != sled.currentBatchMode)
    {
        return NO;
    }
    return YES;
}

#pragma mark --- UniqueTags Report
-(void) setUniqueTagsReport : (srfidUniqueTagsReport *)config{
  self.isUniqueTagsReport = [NSNumber numberWithBool:[config getUniqueTagsReportEnabled]];
}
-(srfidUniqueTagsReport *) getUniqueTagsReport{
    srfidUniqueTagsReport *config = [[[srfidUniqueTagsReport alloc] init] autorelease];
    [config setUniqueTagsReportEnabled:[self.isUniqueTagsReport boolValue]];
    
    return config;
}
- (BOOL) isUniqueTagsReportEqual: (zt_SledConfiguration *)sled{
    if(_isUniqueTagsReport != sled.isUniqueTagsReport)
        return NO;
    
    return YES;
}


@end
