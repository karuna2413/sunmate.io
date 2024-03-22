import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sunmate/constants/colors_contant.dart';
import 'package:sunmate/widgets/home/CTPCL.dart';
import '../../providers/theme_provider.dart';

class HomeCTPVPage extends StatefulWidget {
  HomeCTPVPage(
      {super.key,
      required this.heading,
      required this.label1,
      required this.label2,
      required this.label3});
  final String heading;
  var label1, label2, label3;
  @override
  State<HomeCTPVPage> createState() => _HomeCTPVPageState();
}

class _HomeCTPVPageState extends State<HomeCTPVPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
      return SizedBox(
        child: Container(
          height: 120,
          width: MediaQuery.of(context).size.width * 0.28,
          decoration: BoxDecoration(
            color: getColors(themeNotifier.isDark, 'inputColor'),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: getColors(themeNotifier.isDark, 'borderColor')),
          ),
          margin: const EdgeInsets.all(3),
          padding: const EdgeInsets.all(5),
          child: Stack(
            children: [
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.heading,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: getColors(themeNotifier.isDark, 'textColor'),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CTPVLPage(
                      label: widget.label1,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    CTPVLPage(
                      label: widget.label2,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    CTPVLPage(
                      label: widget.label3,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
