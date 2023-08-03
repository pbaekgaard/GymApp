import React, { useEffect, useState } from 'react'
import { View, ScrollView, Text, Image, TouchableOpacity, StyleSheet, Dimensions} from 'react-native';
import Constants from 'expo-constants';

const Mon = () => {
  return (
    <View style={{height: '100%', flex: 1, flexDirection: "column"}}>
        <View style={styles.titlebar}>
            <Text style={{color: "#a6accd", fontSize: 48}}>WORKOUT NAME</Text>
        </View>
        <View style={styles.container}>
            <Text style={{color: "#a6accd"}}>CONTENT</Text>
        </View>
    </View>
  )
}
const styles = StyleSheet.create({
  titlebar: {
    marginTop: Constants.statusBarHeight,
    padding: 12,
    backgroundColor: "#1b1e2b",
    color: "#fff",
    alignItems: "center"
  },
  container: {
    flex: 1,
    flexDirection: "column",
    height: '100%',
    width: '100%',
    backgroundColor: "#292d3e",
    padding: 12,
  }
});

export default Mon