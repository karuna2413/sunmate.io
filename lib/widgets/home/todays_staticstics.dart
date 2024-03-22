import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sunmate/constants/colors_contant.dart';
import 'package:sunmate/providers/auth_provider.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../providers/theme_provider.dart';

class TodayStaticsticsPage extends StatefulWidget {
  TodayStaticsticsPage({Key? key, required this.dataStatistics})
      : super(key: key);
  var dataStatistics;
  @override
  State<TodayStaticsticsPage> createState() => _TodayStaticsticsPageState();
}

class _TodayStaticsticsPageState extends State<TodayStaticsticsPage> {
  @override
  @override
  Widget build(BuildContext context) {
    return Consumer<ModelTheme>(
      builder: (context, ModelTheme themeNotifier, child) {
        return ListView.builder(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemCount: widget.dataStatistics.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: getColors(themeNotifier.isDark, 'cardborderColor')),
              ),
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
              padding: const EdgeInsets.all(13),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Consumer<AuthProvider>(
                    builder: (context, value, child) {
                      return Expanded(
                          child: value.lan == 'en'
                              ? Text(
                                  '${widget.dataStatistics[index]['display_name_en'].toString()}',
                                  softWrap: true,
                                  // textAlign: TextAlign.justify,
                                  style: TextStyle(
                                      color: getColors(themeNotifier.isDark,
                                          'GreyTextColor'),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                )
                              : Text(
                                  '${widget.dataStatistics[index]['display_name_dk'].toString()}',
                                  softWrap: true,
                                  style: TextStyle(
                                      color: getColors(themeNotifier.isDark,
                                          'GreyTextColor'),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                ));
                    },
                  ),
                  Text(
                    '${widget.dataStatistics[index]['value'].toString()}',
                    style: TextStyle(
                      color: getColors(themeNotifier.isDark, 'textColor'),
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
