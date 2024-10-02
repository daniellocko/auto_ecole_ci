import 'dart:typed_data';

class Student {
  final String id;
  final String? telephone;
  final double amountPaid;
  final String? numPiece;
  final String lastName;
  final String firstName;
  final bool enrollementCompleted;
  final String email;
  final String? qid;

  Student({
    required this.id,
    this.telephone,
    required this.amountPaid,
    this.numPiece,
    required this.lastName,
    required this.firstName,
    required this.email,
    required this.enrollementCompleted,
    this.qid,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      qid: json['qid'],
      telephone: json['telephone'],
      amountPaid: double.parse(json['amount_paid']),
      numPiece: json['num_piece'],
      lastName: json['last_name'],
      firstName: json['first_name'],
      email: json['email'],
      enrollementCompleted: json['enrollementCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'qid': qid,
        'telephone': telephone,
        'amount_paid': amountPaid,
        'num_piece': "numPiece",
        'last_name': lastName,
        'first_name': firstName,
        'email': email,
        'enrollementCompleted': enrollementCompleted,
      };
}

class Instructor {
  final String? id;
  final String? name;
  final String? lastName;
  final String? firstName;
  final String? email;
  final String? telephone;
  final Uint8List? logo;
  final String? logoUrl;
  final String? pID;
  final String? password;
  final String? password2;
  final String? capp;
  Instructor(
      {this.id,
      this.telephone,
      this.name,
      this.logo,
      this.logoUrl,
      this.lastName,
      this.firstName,
      this.email,
      this.password,
      this.password2,
      this.capp,
      this.pID});

  factory Instructor.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) {
      return Instructor();
    }
    return Instructor(
      id: json['id'],
      telephone: json['telephone'],
      name: json['name'],
      lastName: json['last_name'],
      firstName: json['first_name'],
      email: json['email'],
      password: json['password'],
      password2: json['password2'],
      pID: json['pID'],
      //logo: json['logo'],
      logoUrl: json['logo_url'],
      capp: json['capp'],
    );
  }
  Map<String, dynamic> toJson() {
    print(telephone);
    print(name);
    print(lastName);
    print(firstName);
    print(email);
    print(logo);
    print(capp);
    return {
      'id': id,
      'telephone': telephone,
      'name': name,
      'pID': pID,
      'capp': capp,
      'logo_url': logoUrl,
    };
  }

  // Map<String, dynamic> toJson() => {
  //       'id': id,
  //       'telephone': telephone,
  //       'name': name,
  //       // 'last_name': lastName,
  //       // 'first_name': firstName,
  //       // 'email': email,
  //       // 'password': password,
  //       // 'password2': password2,
  //       // //'logo': logo,
  //       'pID': pID,
  //       // 'logo_url': logoUrl,
  //       'capp': capp,
  //     };
}
