import { createStackNavigator } from '@react-navigation/stack';
import FirstTimeSetup from "./screens/FirstTimeSetup";
import Home from "./Home";
import React, { useEffect } from 'react';
import AsyncStorage, { useAsyncStorage } from '@react-native-async-storage/async-storage';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { NavigationContainer } from '@react-navigation/native';
import Index from './index';
const AppStack = createStackNavigator();
const Layout = () => {
    const [isFirstLaunch, setIsFirstLaunch] = React.useState(null);
    
    useEffect(() => {
        AsyncStorage.getItem('alreadyLaunched').then(value => {
            if(value == null) {
                AsyncStorage.setItem('alreadyLaunched', 'true');
                setIsFirstLaunch(true);
            } else {
                setIsFirstLaunch(false);
            }
        })
    }, []);

    if(isFirstLaunch === null) {
        return null;
    } else if (isFirstLaunch === false) {
        return(
            <Index />
        )
    } else {
        return(
            <AppStack.Navigator screenOptions={{headerShown: false}}>
                <AppStack.Screen name="screens/FirstTimeSetup" component={FirstTimeSetup} options={{title: 'First Time Setup'}} />
                <AppStack.Screen name="Home" component={Home} options={{title: 'First Time Setup'}}/>
            </AppStack.Navigator>
        );
    }
    
}

export default Layout;