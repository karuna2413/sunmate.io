import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sunmate/constants/colors_contant.dart';
import '../../providers/theme_provider.dart';

class BottomNavBarPage extends StatefulWidget {
  const BottomNavBarPage({Key? key});

  @override
  State<BottomNavBarPage> createState() => _BottomNavBarPageState();
}

class _BottomNavBarPageState extends State<BottomNavBarPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
      return SizedBox(
        height: 70, // Adjust the height according to your design
        child: Container(
          decoration: BoxDecoration(
            color: getColors(themeNotifier.isDark, 'backgroundColor'),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 1), //(x,y)
                blurRadius: 5.0,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                  onTap: () {},
                  child: themeNotifier.isDark
                      ? Image.asset(
                          'assets/images/dark-bar1.png',
                          height: 20,
                          width: 20,
                        )
                      : Image.asset(
                          'assets/images/light-bar1.png',
                          height: 20,
                          width: 20,
                        )),
              GestureDetector(
                onTap: () {},
                child: Image.asset(
                  'assets/images/bottom-bar2.png',
                  height: 20,
                  width: 20,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Image.asset(
                  'assets/images/bottom-bar3.png',
                  height: 20,
                  width: 20,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Image.asset(
                  'assets/images/bottom-bar4.png',
                  height: 20,
                  width: 20,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
