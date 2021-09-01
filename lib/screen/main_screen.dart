import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather_forecast/utils/weather.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  WeatherData weatherData = WeatherData();
  Icon weatherIcon; // = Icon(FontAwesomeIcons.sun, size: 90);
  double textDerece = 0;
  /*= Icon(
    Icons.error_outline,
    size: 80,
    color: Colors.white,
  );*/
  AssetImage
      weatherImage; // = AssetImage('assets/gunesli.png'); /* = AssetImage('assets/error.jpg');*/
  int sehirsec = 1;
  double longitude = 36.922821, latitude = 37.575275;
  List sehirlerkonumulist;

  String apiKey =
      "api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}&units=metric";

  void getWeatherData() async {
    weatherData.WeatherDatawithlonglat(longitude, latitude);
    debugPrint("getweatherdaya ici longitude=$longitude latitude=$latitude");
    await weatherData.getCurrentTemperature();
    if (weatherData.currentCondition == null ||
        weatherData.currentTemperature == null) {
      debugPrint("sıcaklık yada durum bilgisi bos geldi");
    } else {
      debugPrint("current condition degeri =" +
          weatherData.currentCondition.toString());
      debugPrint("saat =" + DateTime.now().hour.toString());
      if (weatherData.currentCondition < 600) {
        setState(() {
          weatherIcon = Icon(FontAwesomeIcons.cloud,
              color: Colors.white,
              size: MediaQuery.of(context).size.height / 3.5);
          weatherImage = AssetImage('assets/bulutlu.png');
          textDerece = weatherData.currentTemperature;
        });
      } else {
        var now = new DateTime.now();
        //hava iyi gece ise
        if (now.hour >= 19) {
          setState(() {
            weatherIcon = Icon(FontAwesomeIcons.moon,
                color: Colors.white,
                size: MediaQuery.of(context).size.height / 3.5);
            weatherImage = AssetImage('assets/gece.png');
            textDerece = weatherData.currentTemperature;
          });
        }
        //hava iyi gündüz ise
        else {
          setState(() {
            weatherIcon = Icon(FontAwesomeIcons.sun,
                color: Colors.white,
                size: MediaQuery.of(context).size.height / 5);
            weatherImage = AssetImage('assets/gunesli.png');
            textDerece = weatherData.currentTemperature;
          });
        }
      }
    }
  }

  @override
  Future<void> initState() {
    // TODO: implement initState

    super.initState();
    getWeatherData();
    setState(() {});
    sehirlerkonumulist = [];
    sehirKonumOku();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Hava Durumu",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: weatherImage == null
          ? Center(
              child: Text("yükleniyor" + textDerece.toStringAsFixed(1)),
            )
          : Container(
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: weatherImage,
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.orangeAccent, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        items: secilenSehirItems(),
                        value: sehirsec,
                        onChanged: (secilendeger) {
                          setState(() {
                            sehirsec = secilendeger;
                            latitude =
                                sehirlerkonumulist[sehirsec - 1]["latitude"];
                            longitude =
                                sehirlerkonumulist[sehirsec - 1]["longitude"];
                            debugPrint("secilen id=" +
                                sehirsec.toString() +
                                "sehir adı=${sehirlerkonumulist[sehirsec - 1]["sehir_adi"]}  longitude=$longitude latitude=$latitude");
                            getWeatherData();
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 20,
                  ),
                  Container(
                    child: weatherIcon,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 20,
                  ),
                  Center(
                    child: Text(
                      textDerece.toStringAsFixed(1) + "°C",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width / 5,
                          color: Colors.white,
                          letterSpacing: -5),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  List<DropdownMenuItem<int>> secilenSehirItems() {
    List<DropdownMenuItem<int>> sehirler = [];
    sehirler.add(
      DropdownMenuItem(
        child: Text(
          " KahramanMaraş ",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.orange),
        ),
        value: 1,
      ),
    );
    sehirler.add(
      DropdownMenuItem(
        child: Text(
          " Ankara ",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.orange),
        ),
        value: 2,
      ),
    );
    sehirler.add(
      DropdownMenuItem(
        child: Text(
          " İstanbul ",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.orange),
        ),
        value: 3,
      ),
    );
    sehirler.add(
      DropdownMenuItem(
        child: Text(
          " Malatya ",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.orange),
        ),
        value: 4,
      ),
    );
    return sehirler;
  }

  sehirKonumOku() async {
    var gelensehirler =
        await DefaultAssetBundle.of(context).loadString("assets/latlon.json");
    print(gelensehirler);
    sehirlerkonumulist = json.decode(gelensehirler.toString());
  }
}
