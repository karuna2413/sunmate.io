import 'config.dart';

class Environment {
  factory Environment() {
    return _singleton;
  }

  late BaseConfig config;

  Environment._internal();
  static const String registerKey =
      "FzC6PBpDVCq3S!4QKrgUjG!Q-MUCQkwDdls/ZEJUDIR4O/GQEcdt4COS/5ThtLcS0!AkQszN4Ls36QTn/HX56ZQpRpPS2aTLBqusi9t/G4T-skI!/UC8f/o8F!qn/R0oEODy0BFSnD-mk?zGtQhfd305u46x2Jk6ixQmUwp6=fzV!KjmAdTdyLCLJmokJiGJ!-h?OisySO5bMtZC34dR2ALx8?vUl=nNTHFVfH4=un2tMWABeGcahYOuTGwqBCiT";
  static final Environment _singleton = Environment._internal();

  static const String DEV = 'DEV';
  static const String STAGING = 'STAGING';
  static const String PROD = 'PROD';

  initConfig(String environment) {
    config = _getConfig(environment);
  }

  BaseConfig _getConfig(String environment) {
    switch (environment) {
      case Environment.PROD:
        return ProdConfig();
      default:
        return DevConfig();
    }
  }
}
