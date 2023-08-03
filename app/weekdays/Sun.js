import React from 'react'
import { Constants } from 'expo-constants';

const Sun = () => {
  return (
    <div>Sun</div>
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
export default Sun