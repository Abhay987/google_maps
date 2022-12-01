import 'package:dio/dio.dart';
import 'package:google_maps/direction_modal.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DirectionRepository {
  static Dio dio = Dio();
  static const String baseUrl = "https://maps.googleapis.com/maps/api/directions/json?";

  static const String googleApiKey = "*******************************";  //Google Maps Api Key

  static Future<Directions?> getDirections({required LatLng origin,required LatLng destination}) async{
    final response = await dio.get(baseUrl,
    queryParameters: {
      "origin" : "${origin.latitude},${origin.longitude}",
      "destination" : "${destination.latitude},${destination.longitude}",
      'key' : googleApiKey,
    });


    if(response.statusCode == 200) {
      return Directions.fromMap(response.data);
    }
    return null;
  }

}