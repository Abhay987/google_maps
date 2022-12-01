import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class MapServices {
  final String key = "******************************";  // Google Maps Api Key
  final String types = "geocode";

 Future<List<dynamic>> searchPlaces(String searchInput) async {
   final String url = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$searchInput&types=$types&key=$key";
   var response = await http.get(Uri.parse(url));
   var json = convert.jsonDecode(response.body);
   var results = json['predictions'] as List;
   return results;
 }

}