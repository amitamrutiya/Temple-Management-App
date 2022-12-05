class DonationModel {
  late String _fullName;
  late String _emailAddress;
  late String _phoneNumber;
  String? _address;
  String? _country;
  late double _amount;
  late String _message;
  late bool _isAnonymous;
  late DateTime _submitedAt;

  DonationModel({
    required fullName,
    required emailAddress,
    required phoneNumber,
    required message,
    required submitedAt,
    country,
    address,
    required amount,
    required isAnonymous,
  }) {
    _fullName = fullName;
    _emailAddress = emailAddress;
    _phoneNumber = phoneNumber;
    _amount = amount;
    _message = message;
    _submitedAt = submitedAt;
    _country = country;
    _address = address;
    _isAnonymous = isAnonymous;
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['full_name'] = _fullName;
    data['email_address'] = _emailAddress;
    data['phone_number'] = _phoneNumber;
    data['amount'] = _amount;
    data['message'] = _message;
    data['submited_at'] = _submitedAt;
    data['country'] = _country;
    data['address'] = _address;
    data['is_anonymous'] = _isAnonymous;
    return data;
  }
}
