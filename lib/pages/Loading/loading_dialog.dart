import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                  'assets/bus_icon.png',
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
                    child: Center(
                      child: Text(
                        'Đang tải dữ diệu...',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
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
