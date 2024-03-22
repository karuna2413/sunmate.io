import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunmate/constants/colors_contant.dart';
import 'package:sunmate/providers/auth_provider.dart';
import 'package:sunmate/providers/home_data_provider.dart';
import 'package:sunmate/widgets/home/home_CTPVL.dart';
import 'package:sunmate/widgets/home/home_chart.dart';
import 'package:sunmate/widgets/home/home_today_load.dart';
import 'package:sunmate/widgets/home/todays_staticstics.dart';
import 'package:sunmate/widgets/layouts/main_drawer.dart';
import 'package:sunmate/widgets/shared/language_select.dart';
import '../../localization/localization_contants.dart';
import '../../main.dart';
import '../../providers/theme_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Timer _timer;
  var completeData = null;
  String dropdownvalue = 'Power Slit';
  bool like = true;
  bool disLike = false;
  bool isSwitched = false;
  bool isSwitchedSolerSell = true;
  var page = 0;
  var items = [];
  var items_en = [
    'Power Slit',
    'Load',
    'Battery SOC',
  ];
  var items_da = [
    'strømspalte',
    'Belastning',
    'Batteri SOC',
  ];

  var lightIcons = [
    'assets/images/light-icon1.png',
    'assets/images/light-icon2.png',
    'assets/images/light-icon3.png',
    'assets/images/light-icon4.png',
  ];
  var darkIcons = [
    'assets/images/dark-icon1.png',
    'assets/images/dark-icon2.png',
    'assets/images/dark-icon3.png',
    'assets/images/dark-icon4.png',
  ];

  @override
  void initState() {
    super.initState();
    homeDataAPICAll();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      homeDataAPICAll();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  void homeDataAPICAll() async {
    await Provider.of<HomeDataProvider>(context, listen: false)
        .homeData(context);
    final pref = await SharedPreferences.getInstance();
    var lan = pref.getString('language');
    MyApp.setLocale(context, Locale(lan ?? 'en'));
    if (mounted) {
      Provider.of<AuthProvider>(context, listen: false).updateLanguage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ModelTheme>(
      builder: (context, themeNotifier, _) {
        return Scaffold(
          appBar: buildAppBar(themeNotifier),
          backgroundColor: getColors(themeNotifier.isDark, 'backgroundColor'),
          resizeToAvoidBottomInset: true,
          drawer: const MainDrawerPage(),
          body: buildBody(themeNotifier),
        );
      },
    );
  }

  AppBar buildAppBar(ModelTheme themeNotifier) {
    return AppBar(
      iconTheme: IconThemeData(
        color: getColors(themeNotifier.isDark, 'textColor'),
      ),
      backgroundColor: getColors(themeNotifier.isDark, 'backgroundColor'),
      centerTitle: true,
      title: Text(
        getTranslated(context, 'k_home_page'),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: getColors(themeNotifier.isDark, 'textColor'),
        ),
      ),
      actions: <Widget>[
        const Padding(
          padding: EdgeInsets.all(5),
          child: LanguageSelect(),
        ),
        IconButton(
          icon: Icon(
            themeNotifier.isDark ? Icons.wb_sunny : Icons.wb_sunny,
            color: const Color(0xFFF6C517),
          ),
          onPressed: () {
            homeDataAPICAll();
            themeNotifier.isDark = !themeNotifier.isDark;
          },
        ),
      ],
    );
  }

  Widget buildBody(ModelTheme themeNotifier) {
    return Consumer<AuthProvider>(builder: (context, value, child) {
      var display_name =
          value.lan == 'en' ? "display_name_en" : "display_name_dk";
      return Consumer<HomeDataProvider>(
        builder: (context, value, _) {
          if (value.res != null) {
            completeData = value.res;
          }

          return value.loader && completeData == null
              ? Center(
                  child: CircularProgressIndicator(
                    color: getColors(themeNotifier.isDark, 'buttonColor'),
                  ),
                )
              : SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        buildLoadInfoSection(themeNotifier),
                        const SizedBox(height: 10),
                        if (value.res != null &&
                            value.res['graph'] != null &&
                            value.res['graph']['powersplit'] != null)
                          Container(
                            margin: const EdgeInsets.only(left: 5, right: 5),
                            child: HomeChartPage(
                                json.encode(value.res['graph']['powersplit'])),
                          ),
                        const SizedBox(height: 20),
                        Container(
                          margin: const EdgeInsets.only(left: 20, right: 20),
                          child: Column(
                            children: [
                              if (value.res != null &&
                                  value.res['price'] != null)
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: getColors(
                                        themeNotifier.isDark, 'buttonColor'),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 20),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (value.res != null &&
                                            value.res['price'] != null)
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                'Kr.${value.res['price'][0]['value'] ?? ''}', // Replace with your data
                                                style: TextStyle(
                                                  color: getColors(
                                                      themeNotifier.isDark,
                                                      'iconColor'),
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                '/',
                                                style: TextStyle(
                                                  color: getColors(
                                                      themeNotifier.isDark,
                                                      'iconColor'),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              Text(
                                                'Kwh',
                                                style: TextStyle(
                                                  color: getColors(
                                                      themeNotifier.isDark,
                                                      'iconColor'),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        Text(
                                          value.res['price'][0][display_name] ??
                                              '',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                            color: getColors(
                                                themeNotifier.isDark,
                                                'borderColor'),
                                          ),
                                        ),
                                      ]),
                                ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    getTranslated(context, 'k_home_today_load'),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: getColors(
                                            themeNotifier.isDark, 'textColor')),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      if (value.res != null &&
                                          value.res['current_status'] != null)
                                        value.res['current_status']['status'] ==
                                                'success'
                                            ? const Icon(Icons.thumb_up_alt,
                                                color: Colors.green)
                                            : Icon(Icons.thumb_down,
                                                color: Colors.red.shade900),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      buildLoadPage(
                                          value: value,
                                          type: 'houseload',
                                          icons: [darkIcons[0], lightIcons[0]],
                                          themeNotifier: themeNotifier,
                                          display_name: display_name),
                                      SizedBox(height: 5),
                                      buildLoadPage(
                                          value: value,
                                          type: 'solar',
                                          icons: [darkIcons[1], lightIcons[1]],
                                          themeNotifier: themeNotifier,
                                          display_name: display_name),
                                    ],
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 5),
                                        buildLoadPage(
                                            value: value,
                                            type: 'grid',
                                            icons: [
                                              darkIcons[2],
                                              lightIcons[2]
                                            ],
                                            themeNotifier: themeNotifier,
                                            display_name: display_name),
                                        SizedBox(height: 5),
                                        if (value.res != null &&
                                            value.res['current_status'] !=
                                                null &&
                                            value.res['current_status']
                                                    ['battery'] !=
                                                null)
                                          TodayLoadPage(
                                              bttry:
                                                  "${value.res['current_status']['battery'][0]['value'].toString()} ${value.res["current_status"]["battery"][1]["unit_type"]}" ??
                                                      "",
                                              img: themeNotifier.isDark
                                                  ? darkIcons[3]
                                                  : lightIcons[3],
                                              name: value.res['current_status']
                                                          ['battery'][0]
                                                      [display_name] ??
                                                  '',
                                              watt: value.res['current_status']
                                                      ['battery'][1]['value'] ??
                                                  '',
                                              forecast:
                                                  '${value.res['current_status']['battery'][2][display_name] ?? ''} ${(value.res['current_status']['battery'][2]['value'] ?? '').toString()} ${value.res["current_status"]["battery"][2]["unit_type"]}',
                                              usage: "${value.res['current_status']['battery'][3][display_name] ?? ''} ${(value.res['current_status']['battery'][3]['value'] ?? '').toString()} ${value.res["current_status"]["battery"][3]["unit_type"]}",
                                              battery_discharge: "${value.res['current_status']['battery'][4][display_name] ?? ''} ${(value.res['current_status']['battery'][4]['value'] ?? '').toString()} ${value.res["current_status"]["battery"][4]["unit_type"]}"),
                                      ]),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (value.res != null &&
                                      value.res['current_status'] != null &&
                                      value.res['current_status']
                                              ['internal-ct'] !=
                                          null)
                                    HomeCTPVPage(
                                      heading: getTranslated(
                                          context, 'k_home_internal_ct'),
                                      label1:
                                          "${value.res['current_status']['internal-ct'][0][display_name]}: ${(value.res['current_status']['internal-ct'][0]['value'] ?? '').toString()} A",
                                      label2:
                                          "${value.res['current_status']['internal-ct'][1][display_name]}: ${(value.res['current_status']['internal-ct'][1]['value'] ?? '').toString()} A",
                                      label3:
                                          "${value.res['current_status']['internal-ct'][2][display_name]}: ${(value.res['current_status']['internal-ct'][2]['value'] ?? '').toString()} A",
                                    ),
                                  if (value.res != null &&
                                      value.res['current_status'] != null &&
                                      value.res['current_status']
                                              ['external-ct'] !=
                                          null)
                                    HomeCTPVPage(
                                      heading: getTranslated(
                                          context, 'k_home_external_ct'),
                                      label1:
                                          "${value.res['current_status']['external-ct'][0][display_name]}: ${(value.res['current_status']['external-ct'][0]['value'] ?? '').toString()} A",
                                      label2:
                                          "${value.res['current_status']['external-ct'][1][display_name]}: ${(value.res['current_status']['external-ct'][1]['value'] ?? '').toString()} A",
                                      label3:
                                          "${value.res['current_status']['external-ct'][2][display_name]}: ${(value.res['current_status']['external-ct'][2]['value'] ?? '').toString()} A",
                                    ),
                                  if (value.res != null &&
                                      value.res['current_status'] != null &&
                                      value.res['current_status']
                                              ['solar-production'] !=
                                          null)
                                    HomeCTPVPage(
                                      heading: "PV",
                                      label1:
                                          '${value.res['current_status']['solar-production'][0][display_name]}: ${(value.res['current_status']['solar-production'][0]['value'] ?? "").toString()}W',
                                      label2:
                                          '${value.res['current_status']['solar-production'][1][display_name]}: ${(value.res['current_status']['solar-production'][1]['value'] ?? "").toString()} W',
                                      label3:
                                          '${value.res['current_status']['solar-production'][2][display_name]}: ${(value.res['current_status']['solar-production'][2]['valuel'] ?? "").toString()} W',
                                    ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    getTranslated(
                                        context, 'k_home_today_statistics'),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: getColors(
                                            themeNotifier.isDark, 'textColor')),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                  child: value.res != null &&
                                          value.res['other_information'] != null
                                      ? TodayStaticsticsPage(
                                          dataStatistics:
                                              value.res['other_information'])
                                      : SizedBox())
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
        },
      );
    });
  }

  Widget buildLoadInfoSection(ModelTheme themeNotifier) {
    return Consumer<AuthProvider>(
      builder: (context, value, child) {
        value.lan == 'en' ? items = items_en : items = items_da;
        if (value.lan == 'en') {
          items = items_en;
          dropdownvalue = 'Power Slit'; // Set default value for English
        } else {
          items = items_da;
          dropdownvalue = 'strømspalte'; // Set default value for Danish
        }
        return Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  getTranslated(context, 'k_home_load_info'),
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: getColors(themeNotifier.isDark, 'textColor'),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        );
      },
    );
  }

  Widget buildLoadPage(
      {required value,
      required String type,
      required List<String> icons,
      required themeNotifier,
      required display_name}) {
    if (value.res == null ||
        value.res['current_status'] == null ||
        value.res['current_status'][type] == null) {
      return SizedBox
          .shrink(); // Return an empty SizedBox if data is not available
    }

    var data = value.res['current_status'][type];
    return TodayLoadPage(
      bttry: '',
      img: themeNotifier.isDark ? icons[0] : icons[1],
      name: data[0][display_name] ?? '',
      watt: data[0]['value'] ?? '',
      forecast:
          '${data[2][display_name] ?? ''} ${data[2]['value'] ?? ''} ${(data[2]['unit_type']) ?? ""}',
      usage:
          '${data[1][display_name] ?? ''} ${data[1]['value'] ?? ''} ${(data[1]['unit_type']) ?? ""}',
    );
  }
}
