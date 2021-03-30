import 'package:emddibus/models/location_model.dart';
import 'package:emddibus/services/http_search_location.dart';
import 'package:flutter/material.dart';

class SearchLocation extends StatefulWidget {
  @override
  _SearchLocationState createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  Future<ListLocation> future;

  ScrollController _scrollController = ScrollController();

  bool _isSearching = false;
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tìm kiếm địa điểm'),
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
                  controller: searchController,
                  // onChanged: (value) {
                  //   setState(() {
                  //     _isSearching = value.isNotEmpty;
                  //   });
                  //   future = searchLocation(value);
                  // },
                  onSubmitted: (value) {
                    setState(() {
                      _isSearching = value.isNotEmpty;
                    });
                    future = searchLocation(value);
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(25, 10, 5, 5),
                    hintText: 'Tìm kiếm địa điểm...',
                    hintStyle: TextStyle(
                      fontSize: 20,
                    ),
                    suffixIcon: (_isSearching)
                        ? IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              searchController.clear();
                              setState(() {
                                _isSearching = false;
                              });
                            })
                        : IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {
                              setState(() {
                                _isSearching = searchController.text.isNotEmpty;
                              });
                              FocusScope.of(context).unfocus();
                              future = searchLocation(searchController.text);
                            },
                          ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _isSearching ? listResult() : Container(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget listResult() {
    return FutureBuilder<ListLocation>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              constraints: BoxConstraints(maxHeight: 200),
              child: snapshot.data.listLocation.length > 0
                  ? Scrollbar(
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.only(top: 0),
                        itemCount: snapshot.data.listLocation.length,
                        itemBuilder: (context, index) =>
                            buildStopPointCard(context, snapshot, index),
                        shrinkWrap: true,
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.grey, width: 1),
                        ),
                      ),
                      height: 30,
                      child: Center(
                        child: Text(
                          'Không tìm thấy kết quả',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
            );
          }
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
            ),
          );
        });
  }

  Widget buildStopPointCard(
      BuildContext context, AsyncSnapshot snapshot, int index) {
    LocationModel location = snapshot.data.listLocation[index];
    return Card(
      child: ListTile(
        leading: Icon(Icons.location_on),
        onTap: () {
          Navigator.pop(context, []);
        },
        title: Text(
          textName(location),
          style: TextStyle(fontSize: 18),
        ),
        subtitle: Text(
          text(location),
        ),
      ),
    );
  }
}
