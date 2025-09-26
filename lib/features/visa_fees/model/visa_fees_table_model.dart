class VisaFeesPriceTableModel {
  String visaSubclassName = "";
  double subTotal = 0.0;
  double surchargesPercentage = 0.0;
  double surcharges = 0.0;
  double total = 0.0;
  double nonInternetCharge = 0;
  String surchargeImage = "";
  String currencyShortCode =
      "AUD"; // default AUD, else user selected currency code
  double currencyRate = 1; // user selected currency rate
  List<PriceTableRowModel> priceTable = [];
  List<String> notesList = [];

  VisaFeesPriceTableModel(
      {required this.visaSubclassName,
      required this.subTotal,
      required this.surchargesPercentage,
      required this.nonInternetCharge,
      required this.surcharges,
      required this.total,
      required this.priceTable,
      required this.currencyShortCode,
      required this.currencyRate,
      required this.surchargeImage,
      required this.notesList});
}

class PriceTableRowModel {
  String label = "";
  String feesAud = "";
  double fees = 0.0;

  // 0 = Title(Main Applicant or Secondary applicant), 1 = Base App., 2 = Subsequent temp.
  int sequence = 0;

  PriceTableRowModel(
      {required this.label,
      required this.feesAud,
      required this.fees,
      required this.sequence});
}
