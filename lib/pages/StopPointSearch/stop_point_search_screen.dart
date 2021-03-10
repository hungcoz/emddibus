import 'package:emddibus/constants.dart';
import 'package:emddibus/models/stop_point_model.dart';
import 'package:emddibus/pages/Home/fmap_screen.dart';
import 'package:emddibus/pages/Home/search_field.dart';
import 'package:emddibus/pages/StopPointDetails/stop_point_detail_screen.dart';
import 'package:flutter/material.dart';

class StopPointSearch extends StatefulWidget {
  @override
  _StopPointSearchState createState() => _StopPointSearchState();
}

class _StopPointSearchState extends State<StopPointSearch> {
  List<StopPoint> _listStopPoint = [];

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _listStopPoint.addAll(STOP_POINT);
    super.initState();
  }

  void searchStopPoint(String value) {
    if (value.isNotEmpty) {
      List<StopPoint> data = [];
      STOP_POINT.forEach((element) {
        if (element.name.toLowerCase().contains(value.toLowerCase())) {
          data.add(element);
        }
      });
      setState(() {
        _listStopPoint.clear();
        _listStopPoint.addAll(data);
      });
      return;
    } else {
      setState(() {
        _listStopPoint.clear();
        _listStopPoint.addAll(STOP_POINT);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách các điểm dừng'),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(8, 10, 8, 5),
                child: TextField(
                  onChanged: (value) {
                    searchStopPoint(value);
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(25, 10, 5, 5),
                    hintText: 'Tìm kiếm...',
                    hintStyle: TextStyle(
                      fontSize: 20,
                    ),
                    suffixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Scrollbar(
                  isAlwaysShown: true,
                  controller: _scrollController,
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _listStopPoint.length,
                    itemBuilder: (context, index) => _buildCard(context, index),
                    shrinkWrap: true,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, int index) {
    StopPoint stopPoint = _listStopPoint[index];
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
      child: Card(
        child: ListTile(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => StopPointDetail(stopPoint)));
          },
          title: Text(stopPoint.name),
          leading: CircleAvatar(child: Image.asset('assets/stop_point.png')),
          //subtitle: Text('${busRoute.city}'),
        ),
      ),
    );
  }
}
