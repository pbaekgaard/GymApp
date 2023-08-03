import React from 'react'
import { Text } from 'react-native'
import Ionicons from '@expo/vector-icons/Ionicons';
import Home from './Home';
import { createMaterialTopTabNavigator } from '@react-navigation/material-top-tabs';
import Mon from './weekdays/Mon';




const Tab = createMaterialTopTabNavigator();
const index = () => {
  return (
    <Tab.Navigator tabBarPosition='bottom'
        screenOptions={({ route }) => ({
            tabBarStyle: {
                backgroundColor: "#292d3e",
            },
            tabBarActiveTintColor: "#64a0ff",
            tabBarInactiveTintColor: "#aaa",
            headerShown: false,
        })}
      >
        <Tab.Screen name="weekdays/Mon" component={Mon} options={{title: 'Mon'}}/>

      </Tab.Navigator>
  )
}

export default index