import React from 'react';
import {
  StyleSheet,
  Text,
  View,
  NativeModules,
  FlatList,
  TextInput,
  NativeEventEmitter
} from 'react-native';
import KeepAwake from '@sayem314/react-native-keep-awake';
import AppLoader from './src/services/AppLoader';
import { TouchableOpacity } from 'react-native-gesture-handler';
import * as Zebra from '@oniku/react-native-zebra-rfid';
import parser from './src/services/epc-parser';

class App extends React.Component {
  constructor() {
    super();
    this.state = {
      devices: [],
      spinner: true,
      connected: false,
      activeBox: 1,
      sku: "",
      errorSku: '',
      newTag: ''
    };
  }
  async componentDidMount() {
    this.handleGetDevices()
    var isConnected = false
    try {
      isConnected = await Zebra.isConnected()
    }
    catch (err) {
      isConnected = false
    }
    this.setState({
      connected: isConnected
    })
  }
  handleConnect = async (item) => {
    try {
      const deviceName = await Zebra.connect(item.name);
      console.log('handleConnect device name', deviceName);
      if (Platform.OS == 'ios') {
        const { RNZebraRfid } = NativeModules
        const emitter = new NativeEventEmitter(RNZebraRfid)
        emitter.addListener('onRfidRead', this.onPayTmResponse)
        this.setState({
          emitter,
          connected: true
        })
      } else {
        const deviceLisnter = DeviceEventEmitter.addListener('onRfidRead', this.onPayTmResponse)
        this.setState({
          deviceLisnter,
          connected: true
        })
      }
    }
    catch (err) {
      console.log(err)
      alert("something went wrong")
    }
  };
  onPayTmResponse = async (response) => {
    var coming_barcode = '';
    coming_barcode = response[0].id
    this.setState({ sku: coming_barcode, errorSku: '' });
  }
  handleGetDevices = async () => {
    this.setState({
      spinner: true,
    });
    try {
      const devices = await Zebra.getAvailableDevices();
      console.log(' handleGetDevices devices', devices);
      let pairedDevices = [...this.state.devices];
      if (this.state.devices && this.state.devices.length > 0) {
        let findIndex = this.state.devices.find((x) => x.name === device.name);
        if (findIndex > -1) {
          pairedDevices.push(device);
          this.setState({
            devices: pairedDevices,
          });
        }
      } else {
        this.setState({
          devices: devices,
          spinner: false,
        });
      }
    } catch {
      this.setState({
        spinner: false,
      });
    }
  };
  checkIfAlreadyEncoded = async () => {
    if (this.state.sku) {
      var requestOptions = {
        method: 'GET',
        redirect: 'follow'
      };
      fetch("https://card-51a04-default-rtdb.firebaseio.com/Secure/cards.json", requestOptions)
        .then(response => response.text())
        .then(result1 => {
          var pins = []
          var found = false
          const result = JSON.parse(result1)
          if (result) {
            Object.keys(result).forEach(function (key, index) {
              pins.push(result[key])
            });

            for (var i = 0; i < pins.length; i++) {
              if (pins[i].old == this.state.sku || pins[i].new == this.state.sku) {
                found = true
              }
            }
          }

          if (found) {
            alert("Tag already encoded")
          }
          else {
            this.encodeToDataBase()
          }
        })
        .catch(error => console.log('error', error));
    }
    else {
      alert('Please scan tag first')
    }

  }
  encodeToDataBase = async () => {
    if (this.state.sku) {
      const epc = parser.encode("12345678901234", String(Math.random()).substring(2, 11))
      const response = await Zebra.WriteTag(this.state.sku, epc)
      if (response) {
        var myHeaders = new Headers();
        myHeaders.append("Content-Type", "application/json");
        var raw = JSON.stringify({
          "old": this.state.sku,
          "new": epc,
        });
        var requestOptions = {
          method: 'POST',
          headers: myHeaders,
          body: raw,
          redirect: 'follow'
        };
        fetch("https://card-51a04-default-rtdb.firebaseio.com/Secure/cards.json", requestOptions)
          .then(response => response.text())
          .then(async result => {
            alert("tagEncoded")
          })
          .catch(error => {
            console.log(error)
            alert("Something went wrong! Please try again")
            this.setState({
              inlineLoading: false,
            })
          });
      }
      else {
        alert("Tag encoding failed")
      }

    }
    else {
      alert('Please scan sku')
    }

  }
  fetchDetails = async () => {
    if (this.state.sku) {
      var requestOptions = {
        method: 'GET',
        redirect: 'follow'
      };
      fetch("https://card-51a04-default-rtdb.firebaseio.com/Secure/cards.json", requestOptions)
        .then(response => response.text())
        .then(result1 => {
          var pins = []
          const result = JSON.parse(result1)
          Object.keys(result).forEach(function (key, index) {
            pins.push(result[key])
          });
          var found = false
          var data
          for (var i = 0; i < pins.length; i++) {
            if (pins[i].old == this.state.sku || pins[i].new == this.state.sku) {
              found = true
              data = pins[i]
            }
          }
          if (found) {
            this.setState({
              newTag: data.old
            })
          }
          else {
            alert("No Tag Found")
          }
        })
        .catch(error => console.log('error', error));
    }
    else {
      alert('Please scan tag first')
    }
  }

  render() {
    const { spinner, devices, connected } = this.state
    return (
      <View style={styles.container}>
        <Text style={{ fontSize: 50, paddingVertical: 30, color: "#EFEFEF", fontWeight: '600' }}>
          Card Secure
        </Text>
        {connected ? <View>
          <TextInput
            placeholder="Scan" placeholderTextColor="gray" style={[styles.InputField, this.state.activeBox == 1 && { borderColor: 'white', borderWidth: 1 }]}
            onChangeText={sku => this.setState({ sku: sku.trim() })}
            value={this.state.sku}
            onFocus={() => this.setState({
              activeBox: 1
            })}
          />
          <View style={styles.bluetoothContainer}>
            <View style={styles.DeviceLable}>
              <Text style={styles.DeviceLableText}>{this.state.newTag}</Text>
            </View>
          </View>
          <TouchableOpacity onPress={() => this.fetchDetails()} style={styles.btn}>
            <Text style={{ fontSize: 20, fontWeight: '800', color: "#EFEFEF" }}>
              Fetch
            </Text>
          </TouchableOpacity>
          <TouchableOpacity onPress={() => this.checkIfAlreadyEncoded()} style={styles.btn}>
            <Text style={{ fontSize: 20, fontWeight: '800', color: "#EFEFEF" }}>
              Encode
            </Text>
          </TouchableOpacity>
        </View> :
          <>
            <View>
              <View style={styles.bluetoothContainer}>
                <FlatList
                  style={{ flex: 1 }}
                  data={devices}
                  renderItem={({ item }) => (
                    <TouchableOpacity onPress={() => this.handleConnect(item)}>
                      <View>
                        <View style={styles.DeviceLable}>
                          <Text style={styles.DeviceLableText}>{item.name}</Text>
                        </View>
                      </View>
                    </TouchableOpacity>
                  )}
                  keyExtractor={(item, index) => index.toString()}
                />
              </View>
              <View>
                <TouchableOpacity onPress={() => this.handleGetDevices()} style={styles.btn}>
                  <Text style={{ fontSize: 20, fontWeight: '800', color: "#EFEFEF" }}>
                    Scan Devices
                  </Text>
                </TouchableOpacity>
              </View>
            </View>
          </>}

        {
          spinner &&
          <AppLoader modal />
        }
        <KeepAwake />
      </View>
    );
  };

}
export default App;

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#112B3C',
    paddingVertical: 50,
    paddingHorizontal: 20
  },
  container1: {
    flex: 1,
    backgroundColor: '#112B3C',
    justifyContent: "center",
    alignItems: "center"
  },
  bluetoothContainer: {
    marginTop: 10,
    backgroundColor: '#205375',
    height: 250,
    borderRadius: 10,
  },
  btn: {
    backgroundColor: "#F66B0E",
    width: "100%",
    height: 50,
    borderRadius: 10,
    marginVertical: 20,
    alignItems: 'center',
    justifyContent: 'center'
  },
  DeviceLable: {
    width: '100%',
    paddingHorizontal: 15,
    paddingTop: 20,
  },
  DeviceLableText: {
    backgroundColor: '#112B3C',
    color: '#FFFFFF',
    fontSize: 16,
    paddingLeft: 15,
    borderRadius: 10,
    borderWidth: 1,
    overflow: 'hidden',
    padding: 8,
  },
  InputField: {
    backgroundColor: '#205375',
    borderRadius: 5,
    color: '#FFFFFF',
    margin: 5,
    padding: 10,
    fontSize: 20,
    marginBottom: 20
  }
});
