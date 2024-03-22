import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsConditionDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double dialogHeight = MediaQuery.of(context).size.height * 0.9;
    double dialogWidth = MediaQuery.of(context).size.width;

    return Dialog(
      child: Container(
        height: dialogHeight,
        width: dialogWidth,
        child: Stack(
          children: [
            WebView(
              initialUrl:
                  'https://sunmate.mangoitsol.com/public/terms-conditions',
              javascriptMode: JavascriptMode.unrestricted,
            ),
            Align(
                alignment: Alignment.topRight,
                child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.close,
                      color: Colors.blue,
                    ))),
          ],
        ),
      ),
    );
  }
}
