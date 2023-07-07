class AppGlobalData {
  static final AppGlobalData _instance = AppGlobalData._internal();

  factory AppGlobalData() {
    return _instance;
  }

  AppGlobalData._internal() {
    // initialization logic
  }

  String? merchantTitle;
  String? merchantLogo;
  String? merchantOrderNumber;
  num? merchantTotalAmount;
  String? totalEarnAmount;
  String? merchantPercent;
  String? merchantId;
  String? checkOutToken;
  String? ecodeId;
  String? availableCash;
  String? orderConfirmUrl;
  num? enterAmount;
  String? cardURL;
  num? purchaseFinalAmount;
  int? taxPin;
  bool? isCPPayments = false;
  bool isShoppingBoss = false;
  String accountNumber = "";
}
