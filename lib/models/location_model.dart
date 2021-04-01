import 'dart:convert';

class LocationModel {
  final String displayName;
  final double lat;
  final double long;

  LocationModel(
      {this.displayName, this.lat, this.long});

  factory LocationModel.fromJson(dynamic json) => LocationModel(
      displayName: json['display_name'],
      lat: double.parse(json['lat']),
      long: double.parse(json['lon']));
}

class ListLocation {
  List<LocationModel> listLocation;

  factory ListLocation.fromJson(dynamic json) {
    var list = json as List;
    List<LocationModel> _listLocation =
        list.map((e) => LocationModel.fromJson(e)).toList();
    return ListLocation(listLocation: _listLocation);
  }

  ListLocation({this.listLocation});
}

ListLocation listLocationFromJson(String str) =>
    ListLocation.fromJson(json.decode(str));

String textName(LocationModel locationModel) {
  String text = "";
  List<String> list = locationModel.displayName.split(",");
  text = list[0];
  return text;
}

String text(LocationModel locationModel) {
  String text = "";
  List<String> number = ['0','1','2','3','4','5','6','7','8','9'];
  List<String> list = locationModel.displayName.split(",");
  List<String> listTmp = [];
  list.forEach((element) {
    int count = 0;
    number.forEach((e) { 
      if (element.contains(e)) count++;
    });
    if (count == 0)
      listTmp.add(element);
  });
  for (int i=0; i < listTmp.length - 1; i++) {
    if (i < listTmp.length-2) text = text + listTmp[i] + ', ';
    else if (i == listTmp.length - 2) text += listTmp[i];
  }
  return text;
}
