import 'package:connectivity_plus/connectivity_plus.dart';

class Constants {
  static const SPECIAL_CHAR = '--';

  static const ADDRESS = 'Address"';
  static const CITY = 'City';
  static const STATE = 'State';
  static const COUNTRY = 'Country';
  static const ZIPCODE = 'ZipCode';
  static const PROFILE_NAME = 'ProfileName';
  static const FULL_NAME = 'FullName';
  static const FIRST_NAME = 'FirstName';
  static const LAST_NAME = 'LastName';

  static const EMAIL = 'Email';
  static const BIRTHDATE = 'BirthDate';
  static const PHONE_NUMBER = 'PhoneNumber';
  static const SUCCESS_CODE = '201';
  static const NETWORK_OFFLINE = 'Offline';
  static const NETWORK_WIFI = 'WiFi';
  static const NETWORK_MOBILE = 'mobile';

  static const SSN = 'SSN';
  static const ITIN = 'ITIN';
  static const NOT_APPLICABLE = 'Not applicable';

  var sourceInfo = {ConnectivityResult.none: false};

  ///Requests
  static const pending = 'PENDING';
  static const approved = 'PAID';
  static const rejected = 'DECLINED';
  static const sender = 'SENDER';
  static const receiver = 'RECEIVER';
}

class UrlAppEn {}
