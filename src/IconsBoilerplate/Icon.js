import React from "react";
import MaterialCommunityIcons from "react-native-vector-icons/MaterialCommunityIcons";
import FontAwesome from "react-native-vector-icons/FontAwesome";
import FontAwesome5 from "react-native-vector-icons/FontAwesome5";
import MaterialIcons from "react-native-vector-icons/MaterialIcons";
import Fontisto from "react-native-vector-icons/Fontisto";
import SimpleLineIcons from "react-native-vector-icons/SimpleLineIcons";
import FeatherIcons from "react-native-vector-icons/Feather";
import AntDesign from "react-native-vector-icons/AntDesign";
import Entypo from "react-native-vector-icons/Entypo";
import Ionicons from "react-native-vector-icons/Ionicons";
import Octicons from "react-native-vector-icons/Octicons";
// import { inputIconClr } from "../../assets/colors";

/**
 * Component to render different icons from different icon providers
 */

const defaultSettings = {
  color: "red",
  size: 23,
};

export const MTIcon = ({ icon, onPress }) => {
  const _settings = { ...defaultSettings, ...icon };
  const { name, color, size, style } = _settings;
  const [provider, iconName] = name.split("/");

  if (provider === "fa") {
    return (
      <FontAwesome
        onPress={onPress}
        name={iconName}
        color={color}
        size={size}
        style={style}
      />
    );
  } else if (provider === "fa5") {
    return (
      <FontAwesome5
        onPress={onPress}
        name={iconName}
        color={color}
        size={size}
        style={style}
      />
    );
  } else if (provider === "oct") {
    return (
      <Octicons
        onPress={onPress}
        name={iconName}
        color={color}
        size={size}
        style={style}
      />
    );
  } else if (provider === "sl") {
    return (
      <SimpleLineIcons
        onPress={onPress}
        name={iconName}
        color={color}
        size={size}
        style={style}
      />
    );
  } else if (provider === "ft") {
    return (
      <Fontisto
        onPress={onPress}
        size={size}
        style={style}
        name={iconName}
        color={color}
      />
    );
  } else if (provider === "mc") {
    return (
      <MaterialCommunityIcons
        onPress={onPress}
        name={iconName}
        size={size}
        style={style}
        color={color}
      />
    );
  } else if (provider === "mt") {
    return (
      <MaterialIcons
        onPress={onPress}
        name={iconName}
        color={color}
        size={size}
        style={style}
      />
    );
  } else if (provider === "fh") {
    return (
      <FeatherIcons
        onPress={onPress}
        name={iconName}
        color={color}
        size={size}
        style={style}
      />
    );
  } else if (provider === "ad") {
    return (
      <AntDesign
        onPress={onPress}
        name={iconName}
        color={color}
        size={size}
        style={style}
      />
    );
  } else if (provider === "et") {
    return (
      <Entypo
        onPress={onPress}
        name={iconName}
        color={color}
        size={size}
        style={style}
      />
    );
  } else if (provider === "ii") {
    return (
      <Ionicons
        onPress={onPress}
        name={iconName}
        color={color}
        size={size}
        style={style}
      />
    );
  }

  return null;
};
