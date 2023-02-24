import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:screen_state/screen_state.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Screen State Demo',
      home: ScreenStateDemo(),
    );
  }
}

class ScreenStateDemo extends StatefulWidget {
  @override
  _ScreenStateDemoState createState() => _ScreenStateDemoState();
}

class _ScreenStateDemoState extends State<ScreenStateDemo> {
  Screen _screen;
  bool _isActive = false;
  DateTime _startTime;
  DateTime _endTime;
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
    _screen = Screen();
    _screen.startScreensUpdates();
    _screen.screenStateStream.listen((ScreenState state) {
      if (state == ScreenState.SCREEN_OFF) {
        _setAlarm();
      } else if (state == ScreenState.SCREEN_ON) {
        _cancelAlarm();
      }
    });
  }

  void _setAlarm() async {
    var time = DateTime.now().add(Duration(hours: 8));
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.max, priority: Priority.high, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.schedule(
        0, 'Alarm', 'Wake up!', time, platformChannelSpecifics);
  }

  void _cancelAlarm() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  void _onStartChanged(DateTime value) {
    setState(() {
      _startTime = value;
    });
  }

  void _onEndChanged(DateTime value) {
    setState(() {
      _endTime = value;
    });
  }

  void _onSaveButtonPressed() {
    setState(() {
      _isActive = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Screen State Demo'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _isActive
              ? Text(
                  'Active from ${_startTime.hour}:${_startTime.minute} to ${_endTime.hour}:${_endTime.minute}')
              : Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Start time: '),
                        SizedBox(
                          width: 30,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(2)
                            ],
                            onChanged: (value) {
                              if (value.isEmpty) {
                                _onStartChanged(null);
                                return;
                              }
                              var hour = int.parse(value);
                              if (hour > 23) {
                                hour = 23;
                              }
                              if (hour < 0 ) {
hour = 0;
}
var minute = _startTime?.minute ?? 0;
_onStartChanged(DateTime(1, 1, 1, hour, minute));
},
decoration: InputDecoration(
border: OutlineInputBorder(),
),
),
),
Text(':'),
SizedBox(
width: 30,
child: TextField(
keyboardType: TextInputType.number,
inputFormatters: [
FilteringTextInputFormatter.digitsOnly,
LengthLimitingTextInputFormatter(2)
],
onChanged: (value) {
if (value.isEmpty) {
_onStartChanged(null);
return;
}
var minute = int.parse(value);
if (minute > 59) {
minute = 59;
}
if (minute < 0) {
minute = 0;
}
var hour = _startTime?.hour ?? 0;
_onStartChanged(DateTime(1, 1, 1, hour, minute));
},
decoration: InputDecoration(
border: OutlineInputBorder(),
),
),
),
],
),
SizedBox(height: 20),
Row(
mainAxisAlignment: MainAxisAlignment.center,
children: <Widget>[
Text('End time: '),
SizedBox(
width: 30,
child: TextField(
keyboardType: TextInputType.number,
inputFormatters: [
FilteringTextInputFormatter.digitsOnly,
LengthLimitingTextInputFormatter(2)
],
onChanged: (value) {
if (value.isEmpty) {
_onEndChanged(null);
return;
}
var hour = int.parse(value);
if (hour > 23) {
hour = 23;
}
if (hour < 0) {
hour = 0;
}
var minute = _endTime?.minute ?? 0;
_onEndChanged(DateTime(1, 1, 1, hour, minute));
},
decoration: InputDecoration(
border: OutlineInputBorder(),
),
),
),
Text(':'),
SizedBox(
width: 30,
child: TextField(
keyboardType: TextInputType.number,
inputFormatters: [
FilteringTextInputFormatter.digitsOnly,
LengthLimitingTextInputFormatter(2)
],
onChanged: (value) {
if (value.isEmpty) {
_onEndChanged(null);
return;
}
var minute = int.parse(value);
if (minute > 59) {
minute = 59;
}
if (minute < 0) {
minute = 0;
}
var hour = _endTime?.hour ?? 0;
_onEndChanged(DateTime(1, 1, 1, hour, minute));
},
decoration: InputDecoration(
border: OutlineInputBorder(),
),
),
),
],
),
SizedBox(height: 20),
ElevatedButton(
onPressed: _onSaveButtonPressed,
child: Text('Save'),
),
],
),
],
),
);
}
}
