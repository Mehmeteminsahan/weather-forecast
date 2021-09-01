import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_weather_forecast/screen/main_screen.dart';
import 'package:flutter_weather_forecast/utils/weather.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  WeatherData weatherData = WeatherData();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    weatherData.WeatherDatawithlonglat(28, 32);
    weatherData.getCurrentTemperature().then((value) {});
    Future.delayed(Duration(seconds: 10), () {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => MainScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.purple, Colors.deepOrange],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SpinKitPouringHourglass(
                color: Colors.white,
                size: 150,
                duration: Duration(milliseconds: 1200),
              ),
              Center(
                child: Text(
                  weatherData.currentTemperature.toString(),
                  style: TextStyle(fontSize: 25),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
