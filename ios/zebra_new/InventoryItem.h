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
 *  Description:  RfidInventoryItem.h
 *
 *  Notes:
 *
 ******************************************************************************/

#import <Foundation/Foundation.h>
#import "RfidTagData.h"

@interface zt_InventoryItem : NSObject
{
    srfidTagData *m_TagData;
    int m_Count;
}

- (id)initWithTagData:(srfidTagData*)tagData;

- (srfidTagData*)getTagData;
- (int)getCount;
- (void)incCount;
- (void)incCountBySeenCount:(int) tagSeenCount;

- (NSString*)getTagId;
- (NSString*)getPC;
- (short)getRSSI;
- (short)getChannelIndex;
- (short)getPhase;
- (SRFID_MEMORYBANK)getMemoryBank;
- (NSString*)getMemoryBankData;


@end
