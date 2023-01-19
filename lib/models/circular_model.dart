import 'package:flutter/animation.dart';

class CircularModel {
  late String _uploadTime;
  late String _eventTitle;
  late String _date;
  late String _pdfname;

  CircularModel({
    required uploadTime,
    required eventTitle,
    required date,
    required pdfname,
  }) {
    _uploadTime = uploadTime;
    _eventTitle = eventTitle;
    _date = date;
    _pdfname = pdfname;
  }

  CircularModel.fromJson(Map<String, dynamic> json) {
    _uploadTime = json['uploadTime'];
    _eventTitle = json['eventTitle'];
    _date = json['date'];
    _pdfname = json['pdfname'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['uploadTime'] = _uploadTime;
    data['eventTitle'] = _eventTitle;
    data['date'] = _date;
    data['pdfname'] = _pdfname;

    return data;
  }
}
