import 'package:emddibus/models/location_model.dart';
import 'package:http/http.dart' as http;

Future<ListLocation> searchLocation(String value) async {
  final response = await http.get(
      "https://nominatim.openstreetmap.org/search/"+value+"?format=json&&countrycode=vn&addressdetails=1&limit=10&polygon_svg=1");
  if (response.statusCode == 200){
    print(response.body.toString());
    return listLocationFromJson(response.body);
  }
  else {
    throw Exception('Error');
  }
  // final searchResult = await Nominatim.searchByName(
  //   query: value,
  //   limit: 5,
  //   countryCodes: ["vn"],
  //   addressDetails: true,
  //   extraTags: true,
  //   nameDetails: true,
  // );
  // print(searchResult.single.displayName);
  // print(searchResult.single.address);
  // print(searchResult.single.extraTags);
  // print(searchResult.single.nameDetails);
  //
  // print('');

  // final reverseSearchResult = await Nominatim.reverseSearch(
  //   lat: 50.1,
  //   lon: 6.2,
  //   addressDetails: true,
  //   extraTags: true,
  //   nameDetails: true,
  // );
  // print(reverseSearchResult.displayName);
  // print(reverseSearchResult.address);
  // print(reverseSearchResult.extraTags);
  // print(reverseSearchResult.nameDetails);
}