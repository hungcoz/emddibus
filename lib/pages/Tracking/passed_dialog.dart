import 'package:flutter/material.dart';

class PassedDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Column(
          children: [
            Text('Xe đã đến điểm dừng'),
            RaisedButton(
                child: Text('Đóng'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                })
          ],
        ),
      ),
    );
  }
}
