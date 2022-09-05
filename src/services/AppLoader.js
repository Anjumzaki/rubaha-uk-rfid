import React from 'react'
import { Text } from 'react-native'
import { StyleSheet } from 'react-native'
import { View } from 'react-native'
import { Image } from 'react-native'
import { widthPercentageToDP } from 'react-native-responsive-screen'

export default ({ width, height, marginVertical, modal, text, flex }) => {
    return (
        modal ?
            <View style={{ ...StyleSheet.absoluteFillObject, alignItems: 'center', justifyContent: 'center', zIndex: 100, backgroundColor: 'rgba(0,0,0,0.7)' }} >
                <Image resizeMode='contain' style={{ width: width ? width : '100%', height: height ? height : 30, marginVertical: marginVertical ? marginVertical : 10 }} source={require('../assets/appLoader.gif')} />
                <Text style={{ color: '#fff', fontSize: widthPercentageToDP(4), fontFamily: 'EffraLight-Regular' }} >{text ? text : 'Please wait'}</Text>
            </View>
            :
            flex ?
                <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center' }} >
                    <Image resizeMode='contain' style={{ width: width ? width : '100%', height: height ? height : 30, marginVertical: marginVertical ? marginVertical : 10 }} source={require('../assets/appLoader.gif')} />
                </View>
                :
                <Image resizeMode='contain' style={{ width: width ? width : '100%', height: height ? height : 30, marginVertical: marginVertical ? marginVertical : 10 }} source={require('../assets/appLoader.gif')} />
    )
}