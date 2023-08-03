import React, { useEffect, useState } from 'react'
import { View, ScrollView, Text, Image, TouchableOpacity, StyleSheet, StatusBar} from 'react-native';
import Constants from 'expo-constants';

const Home = () => {
  return (
    <View style={styles.container}>
      <Text style={{color: "#fff"}}>Home</Text>
    </View>
  )
}
const styles = StyleSheet.create({
  container: {
    flex: 1,
    flexDirection: "column",
    marginTop: Constants.statusBarHeight,
    padding: 12,
    backgroundColor: "#1b1e2b",
    color: "#fff"
  },
  content: {
    color: "#fff"
  }
});

export default Home