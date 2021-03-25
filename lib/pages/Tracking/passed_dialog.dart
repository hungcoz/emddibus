import 'package:flutter/material.dart';

class PassedDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return AlertDialog(
    //   title: Center(
    //     child: Column(
    //       children: [
    //         Text('Xe đã đến điểm dừng'),
    //         RaisedButton(
    //             child: Text('Đóng'),
    //             onPressed: () {
    //               Navigator.pop(context);
    //             }),
    //       ],
    //     ),
    //   ),
    // );
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Container(
        height: 200,
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.white70,
                child: Image.asset(
                  'assets/bus_arrived.png',
                  width: 75,
                  height: 75,
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Color(0xffeeac24),
                child: SizedBox.expand(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Xe đã đến điểm dừng',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        RaisedButton(
                          color: Colors.white,
                          child: Text('Okelaaaa'),
                          onPressed: () => {Navigator.of(context).pop()},
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
