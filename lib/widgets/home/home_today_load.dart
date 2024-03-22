import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sunmate/constants/colors_contant.dart';
import '../../providers/theme_provider.dart';

class TodayLoadPage extends StatefulWidget {
  TodayLoadPage(
      {required this.name,
      required this.watt,
      required this.forecast,
      required this.usage,
      required this.img,
      required this.bttry,
      this.battery_discharge = ""});
  var watt;
  var forecast;
  var usage;
  var name;
  var img;
  var bttry;
  var battery_discharge;

  @override
  State<TodayLoadPage> createState() => _TodayLoadPageState();
}

class _TodayLoadPageState extends State<TodayLoadPage> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
      return Container(
        width: width * 0.42,
        height: 165,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
              color: getColors(themeNotifier.isDark, 'cardborderColor')),
        ),
        margin: const EdgeInsets.all(5),
        padding: EdgeInsets.only(left: 20, top: 10),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                      color: getColors(themeNotifier.isDark, 'GreyTextColor')),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: getColors(themeNotifier.isDark, 'buttonColor'),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Image.asset(
                        widget.img,
                        height: 45,
                        width: 45,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            '${widget.watt.toString()} W',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: getColors(
                                    themeNotifier.isDark, 'buttonColor')),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text('${widget.bttry}',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: getColors(
                                      themeNotifier.isDark, 'buttonColor'))),
                        )
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  widget.forecast.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: getColors(themeNotifier.isDark, 'GreyTextColor')),
                ),
                Text(
                  widget.usage.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: getColors(themeNotifier.isDark, 'GreyTextColor')),
                ),
                Text(
                  widget.battery_discharge.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: getColors(themeNotifier.isDark, 'GreyTextColor')),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
