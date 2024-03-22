class UserRegistration {
  final String name;
  final String email;
  final String password;
  final int terms;
  final String lang;
  final String zipcode;

  UserRegistration({
    required this.name,
    required this.email,
    required this.password,
    required this.terms,
    required this.lang,
    required this.zipcode,
  });

  factory UserRegistration.fromJson(Map<String, dynamic> json) {
    return UserRegistration(
      name: json['name'],
      email: json['email'],
      password: json['password'],
      terms: json['terms'],
      lang: json['lang'],
      zipcode: json['zipcode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'terms': terms,
      'lang': lang,
      'zipcode': zipcode,
    };
  }
}
