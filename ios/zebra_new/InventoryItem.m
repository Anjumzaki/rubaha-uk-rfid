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
 *  Description:  RfidInventoryItem.m
 *
 *  Notes:
 *
 ******************************************************************************/

#import "InventoryItem.h"

@implementation zt_InventoryItem

- (id)initWithTagData:(srfidTagData*)tagData
{
    self = [super init];
    if (nil != self)
    {
        m_TagData = [[srfidTagData alloc] init];
        [m_TagData setTagId:[tagData getTagId]];
        [m_TagData setFirstSeenTime:[tagData getFirstSeenTime]];
        [m_TagData setLastSeenTime:[tagData getLastSeenTime]];
        [m_TagData setPC:[tagData getPC]];
        [m_TagData setPeakRSSI:[tagData getPeakRSSI]];
        [m_TagData setPhaseInfo:[tagData getPhaseInfo]];
        [m_TagData setChannelIndex:[tagData getChannelIndex]];
        [m_TagData setTagSeenCount:[tagData getTagSeenCount]];
        [m_TagData setOpCode:[tagData getOpCode]];
        [m_TagData setOperationSucceed:[tagData getOperationSucceed]];
        [m_TagData setOperationStatus:[tagData getOperationStatus]];
        [m_TagData setMemoryBank:[tagData getMemoryBank]];
        [m_TagData setMemoryBankData:[tagData getMemoryBankData]];
        [m_TagData setPermaLockData:[tagData getPermaLockData]];
        
        m_Count = 0;
    }
    
    return self;
}

- (void)dealloc
{
    if (nil != m_TagData)
    {
        [m_TagData release];
    }
    
    [super dealloc];
}

- (srfidTagData*)getTagData
{
    return m_TagData;
}

- (int)getCount
{
    return m_Count;
}

- (void)incCount
{
    m_Count++;
}

- (void)incCountBySeenCount:(int) tagSeenCount
{
    m_Count += tagSeenCount;
}

- (NSString*)getTagId
{
    return [m_TagData getTagId];
}

- (NSString*)getPC
{
    return [m_TagData getPC];
}

- (short)getRSSI
{
    return [m_TagData getPeakRSSI];
}

- (short)getChannelIndex
{
    return [m_TagData getChannelIndex];
}

- (short)getPhase
{
    return [m_TagData getPhaseInfo];
}

- (SRFID_MEMORYBANK)getMemoryBank
{
    return [m_TagData getMemoryBank];
}

- (NSString*)getMemoryBankData
{
    return [m_TagData getMemoryBankData];
}

@end
