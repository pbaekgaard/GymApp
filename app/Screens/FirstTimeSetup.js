import React from 'react';
import { View, Text, Image, TouchableOpacity, StyleSheet} from 'react-native';
import Onboarding from 'react-native-onboarding-swiper';
const Dots = ({selected}) => {
    let backgroundColor;

    backgroundColor = selected ? 'rgba(0, 0, 0, 0.8)' : 'rgba(0, 0, 0, 0.3)';

    return (
        <View 
            style={{
                width:6,
                height: 6,
                marginHorizontal: 3,
                backgroundColor
            }}
        />
    );
}

const Next = ({...props}) => (
    <TouchableOpacity
        style={{marginHorizontal:10}}
        {...props}
    >
        <Text style={{fontSize:16}}>Next</Text>
    </TouchableOpacity>
);

const Done = ({...props}) => (
    <TouchableOpacity
        style={{marginHorizontal:10}}
        {...props}
    >
        <Text style={{fontSize:16}}>Done</Text>
    </TouchableOpacity>
);
const Skip = ({...props}) => (
  <TouchableOpacity
    style={{marginHorizontal:10}}
    {...props}>
    <Text></Text>
  </TouchableOpacity>
);

const FirstTimeSetup = ({navigation}) => {
    return (
        <Onboarding
        SkipButtonComponent={Skip}
        NextButtonComponent={Next}
        DoneButtonComponent={Done}
        DotComponent={Dots}
        onDone={() => navigation.navigate("screens/Home")}
        pages={[
          {
            backgroundColor: '#1DC690',
            image: <Image source={require('../assets/onboarding-img1.png')} />,
            title: 'Welcome to GymBuddy',
            subtitle: 'An Easy Way To Keep Track Of Your Workout!',
          },
          {
            backgroundColor: '#278AB0',
            image: <Image source={require('../assets/onboarding-img2.png')} />,
            title: "Setup Your Week!",
            subtitle: 'Lets Start By Setting Up Your Workouts. You can always change them later!',
          },
          {
            backgroundColor: '#1C4670',
            image: <Image source={require('../assets/onboarding-img3.png')} />,
            title: "That's It!",
            subtitle: "You Are Now Ready To Use GymBuddy!",
          },
        ]}
      />
    );
};

export default FirstTimeSetup;

const styles = StyleSheet.create({
  container: {
    flex: 1, 
    alignItems: 'center', 
    justifyContent: 'center'
  },
});