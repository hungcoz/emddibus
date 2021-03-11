import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Column(
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text('Đang tải dữ liệu...')
          ],
        ),
      ),
    );
  }
}
