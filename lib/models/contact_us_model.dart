import 'package:flutter/animation.dart';

class ContactUsModel {
  late String _fullName;
  late int _phoneNumber;
  late String _emailAddress;
  late String _message;
  late DateTime _submitedAt;

  ContactUsModel(
      {
      required fullName,
      required phoneNumber,
      required emailAddress,
      required message,
      required submitedAt}) {

    _fullName = fullName;
    _phoneNumber = phoneNumber;
    _emailAddress = emailAddress;
    _message = message;
    _submitedAt = submitedAt;
  }
  ContactUsModel.fromJson(Map<String, dynamic> json) {

    _fullName = json['fullName'];
    _phoneNumber = json['phoneNumber'];
    _emailAddress = json['emailAddress'];
    _message = json['message'];
    _submitedAt = json['submitedAt'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};

    data['fullName'] = _fullName;
    data['phoneNumber'] = _phoneNumber;
    data['emailAddress'] = _emailAddress;
    data['message'] = _message;
    data['submitedAt'] = _submitedAt;
    return data;
  }
}
