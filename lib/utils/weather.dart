import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

const apiKey = "98d2048dc23752b0cbae6eb3633762d3";

class WeatherData {
  WeatherDatawithlonglat(double longitude, double latitude) {
    this._longitude = longitude;
    this._latitude = latitude;
  }

  double currentTemperature;
  double _latitude, _longitude;
  int currentCondition;

  Future<void> getCurrentTemperature() async {
    var url = Uri.parse(
        "http://api.openweathermap.org/data/2.5/weather?lat=$_latitude&lon=$_longitude&appid=$apiKey&units=metric");
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      String data = response.body;
      var currentWeather = jsonDecode(data);
      try {
        currentTemperature = currentWeather["main"]["temp"];
        currentCondition = currentWeather["weather"][0]["id"];
      } catch (e) {
        print(e);
      }
    } else {
      debugPrint("apiden deger gelmedi");
    }
  }
}
