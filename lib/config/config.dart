abstract class BaseConfig {
  String get apiHost;
  String get apiLiveHost;

  String get adminMail;
  bool get useHttps;
  bool get trackEvents;
  bool get reportErrors;
}

class DevConfig implements BaseConfig {
  @override
  String get apiHost =>
      // "https://sunmate.mangoitsol.com/public/";
      "https://portal.sunmateio.dev/";
  String get apiLiveHost => "https://api.sunmateio.dk/dashboard/live";

  @override
  String get adminMail => "Neeraj Goswami <neeraj.goswami@mangoitsolutions.in>";

  @override
  bool get reportErrors => false;

  @override
  bool get trackEvents => false;

  @override
  bool get useHttps => false;
}

class ProdConfig implements BaseConfig {
  @override
  String get apiHost => "example.com";
  String get apiLiveHost => "https://api.sunmateio.dk/dashboard/live";

  @override
  bool get reportErrors => true;

  @override
  bool get trackEvents => true;

  @override
  bool get useHttps => true;

  @override
  // TODO: implement adminMail
  String get adminMail => throw UnimplementedError();
}
