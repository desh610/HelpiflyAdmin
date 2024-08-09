import 'package:flutter/material.dart';
import 'package:helpiflyadmin/constants/colors.dart';
import 'package:helpiflyadmin/widgets/progress_view.dart';

class Loading {
  void startLoading(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      barrierColor: Colors.black45,
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Container(
            margin: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height / 2.5,
              horizontal: MediaQuery.of(context).size.width / 2.5,
            ),
            child: Center(
              child: SizedBox(
                child: ProgressView(color: secondaryColor),
              ),
            ),
          ),
        );
      },
    );
  }

  void stopLoading(BuildContext context) {
    Navigator.of(context).pop();
  }
}
