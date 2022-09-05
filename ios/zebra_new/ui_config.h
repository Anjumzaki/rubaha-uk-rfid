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
 *  Description:  ui_config.h
 *
 *  Notes:
 *
 ******************************************************************************/

#ifndef __UI_CONFIG_H__
#define __UI_CONFIG_H__

#define ZT_UI_HOME_COLOR_BTN_BACKGROUND                            0xc3
#define ZT_UI_HOME_COLOR_BTN_SHADOW                                0x8c
#define ZT_UI_HOME_BTN_CORNER_RADIUS                               0
#define ZT_UI_HOME_BTN_SHADOW_SIZE                                 3
#define ZT_UI_HOME_BTN_FONT_SIZE                                   18.0
#define ZT_UI_HOME_BTN_FONT_COLOR
#define ZT_UI_HOME_BTN_FONT_NAME                                   @"System"

#define ZT_UI_RAPID_READ_COLOR_LBL_BACKGROUND                      0xcc
#define ZT_UI_RAPID_READ_CORNER_RADIUS_BIG                         15
#define ZT_UI_RAPID_READ_CORNER_RADIUS_SMALL                       5
#define ZT_UI_RAPID_READ_FONT_SZ_LBL                               15.0

#define ZT_UI_INVENTORY_COLOR_LBL_HEADER                           0x66
#define ZT_UI_INVENTORY_COLOR_LBL_HEADER_SHADOW                    0xc9
#define ZT_UI_INVENTORY_COLOR_SEARCH_FIELD                         0x99
#define ZT_UI_INVENTORY_FONT_SZ_SMALL                              10.0
#define ZT_UI_INVENTORY_FONT_SZ_BIG                                19.0
#define ZT_UI_INVENTORY_FONT_SZ_MEDIUM                             14.0
#define ZT_UI_INVENTORY_FONT_SZ_BUTTON                             23.0

#define ZT_UI_CELL_TAG_FONT_SZ_BIG                                 17.0
#define ZT_UI_CELL_TAG_FONT_SZ_MEDIUM                              15.0
#define ZT_UI_CELL_TAG_FONT_SZ_SMALL                               11.0
#define ZT_UI_CELL_TAG_INDENT_EXT                                  10.0
#define ZT_UI_CELL_TAG_INDENT_INT_BIG                              8.0
#define ZT_UI_CELL_TAG_INDENT_INT_SMALL                            2.0

#define ZT_UI_CELL_CUSTOM_FONT_SZ_TEXT_FIELD                       17.0
#define ZT_UI_CELL_CUSTOM_FONT_SZ_BIG                              17.0
#define ZT_UI_CELL_CUSTOM_FONT_SZ_SMALL                            14.0
#define ZT_UI_CELL_CUSTOM_INDENT_EXT                               10.0
#define ZT_UI_CELL_CUSTOM_INDENT_INT_SMALL                         0.0
#define ZT_UI_CELL_CUSTOM_INDENT_INT_BIG                           10.0
#define ZT_UI_CELL_CUSTOM_IMAGE_SZ                                 25.0

#define ZT_UI_LOCATE_TAG_INDENT_EXT                                10.0
#define ZT_UI_LOCATE_TAG_FONT_SZ_SMALL                             12.0
#define ZT_UI_LOCATE_TAG_FONT_SZ_BIG                               20.0
#define ZT_UI_LOCATE_TAG_FONT_SZ_MEDIUM                            17.0
#define ZT_UI_LOCATE_TAG_FONT_SZ_BUTTON                            23.0
#define ZT_UI_LOCATE_TAG_COLOR_BACKGROUND                          0xcc
#define ZT_UI_LOCATE_TAG_COLOR_LEVEL_RED                           0x80
#define ZT_UI_LOCATE_TAG_COLOR_LEVEL_GREEN                         0x00
#define ZT_UI_LOCATE_TAG_COLOR_LEVEL_BLUE                          0x80
#define ZT_UI_LOCATE_TAG_COLOR_LINE_RED                            0x3f
#define ZT_UI_LOCATE_TAG_COLOR_LINE_GREEN                          0x9f
#define ZT_UI_LOCATE_TAG_COLOR_LINE_BLUE                           0x9f
#define ZT_UI_LOCATE_TAG_INDICATOR_CORNER_RADIUS                   2

#define ZT_UI_ACCESS_FONT_SZ_SMALL                                 12.0
#define ZT_UI_ACCESS_FONT_SZ_BIG                                   20.0
#define ZT_UI_ACCESS_FONT_SZ_MEDIUM                                17.0
#define ZT_UI_ACCESS_FONT_SZ_BUTTON                                23.0
#define ZT_UI_ACCESS_INDENT                                        10.0

#define ZT_UI_FILTER_FONT_SZ_SMALL                                 12.0
#define ZT_UI_FILTER_FONT_SZ_BIG                                   20.0
#define ZT_UI_FILTER_FONT_SZ_MEDIUM                                17.0
#define ZT_UI_FILTER_FONT_SZ_BUTTON                                23.0
#define ZT_UI_FILTER_INDENT                                        10.0

#define ZT_UI_BATTERY_FONT_SZ_MEDIUM                               17.0
#define ZT_UI_BATTERY_FONT_SZ_BIG                                  23.0

#define ZT_UI_ABOUT_FONT_SZ_MEDIUM                                 16.0
#define ZT_UI_ABOUT_FONT_SZ_BIG                                    19.0


#define ZT_STR_SETTINGS_READER_LIST                                @"Readers List"
#define ZT_STR_SETTINGS_CONNECTION                                 @"Application"
#define ZT_STR_SETTINGS_ANTENNA                                    @"Antenna"
#define ZT_STR_SETTINGS_START_STOP_TRIGGER                         @"Start\\Stop Triggers"
#define ZT_STR_SETTINGS_SINGULATION_CONTROL                        @"Singulation Control"
#define ZT_STR_SETTINGS_REGULATORY                                 @"Regulatory"
#define ZT_STR_SETTINGS_BEEPER                                     @"Beeper"
#define ZT_STR_SETTINGS_SAVE                                       @"Save Configuration"
#define ZT_STR_SETTINGS_BATTERY                                    @"Battery"
#define ZT_STR_SETTINGS_TAG_REPORT                                 @"Tag Reporting"
#define ZT_STR_SETTINGS_PWR_MANAGEMENT                             @"Power Optimization"

#define ZT_STR_SETTINGS_PWR_MANAGEMENT_DYNAMIC_POWER               @"Dynamic Power"

#define ZT_STR_SETTINGS_CONNECTION_AUTO_RECONNECT                  @"Auto Reconnect Reader"
#define ZT_STR_SETTINGS_CONNECTION_NOTIFICATION_AVAILABLE          @"Reader Available"
#define ZT_STR_SETTINGS_CONNECTION_NOTIFICATION_ACTIVE             @"Reader Connection"
#define ZT_STR_SETTINGS_CONNECTION_NOTIFICAtiON_BATTERY            @"Reader Battery Status"
#define ZT_STR_SETTINGS_CONNECTION_DATA_EXPORT                     @"Export Data"
#define ZT_STR_SETTINGS_CONNECTION_HEADER_CONNECTION               @"Reader Connection Settings"
#define ZT_STR_SETTINGS_CONNECTION_HEADER_NOTIFICATION             @"Notification Settings"
#define ZT_STR_SETTINGS_CONNECTION_HEADER_DATA_EXPORT              @"Data Export Settings"

#define ZT_STR_SETTINGS_ANTENNA_POWER_LEVEL                        @"Power level(dbm)"
#define ZT_STR_SETTINGS_ANTENNA_LINK_PROFILE                       @"Link profile"
#define ZT_STR_SETTINGS_ANTENNA_TARI                               @"Tari"
#define ZT_STR_SETTINGS_ANTENNA_DO_SELECT                          @"Do Select"

#define ZT_BUTTON_RAPID_READ                                       1
#define ZT_STR_BUTTON_RAPID_READ                                   @"Rapid Read"
#define ZT_BUTTON_INVENTORY                                        2
#define ZT_STR_BUTTON_INVENTORY                                    @"Inventory"
#define ZT_BUTTON_SETTINGS                                         3
#define ZT_STR_BUTTON_SETTING                                      @"Settings"
#define ZT_BUTTON_LOCATE_TAG                                       4
#define ZT_STR_BUTTON_LOCATE_TAG                                   @"Locate Tag"
#define ZT_BUTTON_FILTER                                           5
#define ZT_STR_BUTTON_FILTER                                       @"Pre Filters"
#define ZT_BUTTON_ACCESS                                           6
#define ZT_STR_BUTTON_ACCESS                                       @"Access Control"

#define ZT_WARNING_NO_READER                                       @"No Active Reader"
#define ZT_WARNING_NO_MATCH                                        @"No Match Found"


#define ZT_TAGREPORT_BATCHMODE_ENABLE                              @"ENABLE"
#define ZT_TAGREPORT_BATCHMODE_AUTO                                @"AUTO"
#define ZT_TAGREPORT_BATCHMODE_DISABLE                             @"DISABLE"


#endif /* __UI_CONFIG_H__ */
