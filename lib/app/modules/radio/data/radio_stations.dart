import '../models/radio_station.dart';

class RadioStations {
  static const List<RadioStation> stations = [
    RadioStation(
      id: '98fm',
      name: '98FM',
      url: 'https://playerservices.streamtheworld.com/api/livestream-redirect/98FM_CWBAAC.aac?dist=site',
      description: 'Rádio 98FM Curitiba',
    ),
    RadioStation(
      id: 'massa_curitiba',
      name: 'Massa Curitiba',
      url: 'https://live.virtualcast.com.br/massacuritiba?1756235460149',
      description: 'Rádio Massa Curitiba',
    ),
    RadioStation(
      id: 'joven_pan',
      name: 'Joven Pan',
      url: 'https://play.wisestream.io/jpcuritiba',
      description: 'Joven Pan Curitiba',
    ),
    RadioStation(
      id: 'transamerica',
      name: 'Transamérica',
      url: 'https://playerservices.streamtheworld.com/api/livestream-redirect/RT_CWB.mp3',
      description: 'Transamérica Curitiba',
    ),
  ];

  static RadioStation get defaultStation => stations.first;
}
