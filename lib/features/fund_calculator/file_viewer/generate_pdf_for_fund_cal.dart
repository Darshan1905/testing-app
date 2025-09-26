// ignore_for_file: depend_on_referenced_packages

import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:occusearch/features/fund_calculator/fund_calculator_bloc.dart';
import 'package:occusearch/features/fund_calculator/model/country_with_currency.dart';
import 'package:occusearch/features/fund_calculator/model/fund_calculator_question_model.dart';
import 'package:occusearch/features/fund_calculator/model/summary_chart_model.dart';
import 'package:occusearch/resources/icons.dart';
import 'package:occusearch/utility/utils.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';


class FundCalcPDFConstants {
  static const referAFriendDynamicLink = 'https://occusearch.page.link/lgn';
  static const aussizzWebsiteUrl = "https://aussizzgroup.com";
  static String pteWebsite = "https://ptetutorials.com/";
  static String cclWebsite = "https://ccltutorials.online/";
  static String ieltsWebsite = "https://ieltstutorials.online/";
}

Future<Uint8List> generatePDFForFundCalc(List<SummaryChartData> summaryChartData,
    FundCalculatorBloc? fundAnswerSavedBloc, List<FundCalculatorQuestion>? fundQuestions
   ) async {

  // current time in PDF footer
  var currDt = DateTime.now();
  DateFormat formatter = DateFormat('dd-MMM-yyyy HH:mm:ss aaa');
  // 03-Oct-2022 12:25:20 PM IST
  // print("${formatter.format(currDt)}, ${currDt.timeZoneName}");
  String footerDateTime = "${formatter.format(currDt)}, ${currDt.timeZoneName}";

  //CURRENCY
  CountryWithCurrencyModel? currencyModel = fundAnswerSavedBloc?.selectedCountrySubject.valueOrNull;

  /* Living cost calculated */
  double livingCostTotalAmount =
      fundQuestions![1].answerAmount +
          fundQuestions[2].answerAmount +
          fundQuestions[3].answerAmount;

  /* Total fund cal calculated */
  double totalCost = fundQuestions[0].answerAmount +
      livingCostTotalAmount +
      fundQuestions[4].answerAmount +
      fundQuestions[5].answerAmount;

  final pdf = Document();
  PdfPageFormat format = PdfPageFormat.a4;

  // Image and logo to be used in PDF
  final imageLogo = MemoryImage(
      (await rootBundle.load(IconsPNG.fundCalPdfPage))
          .buffer
          .asUint8List());

  final headerAussizzIcon = MemoryImage(
      (await rootBundle.load(IconsPNG.icAussizzLogo))
          .buffer
          .asUint8List());

  final occuSearchIcon = MemoryImage(
      (await rootBundle.load(IconsPNG.pdfOccusearchHeaderLogo))
          .buffer
          .asUint8List());

  final cclIcon = MemoryImage(
      (await rootBundle.load(IconsPNG.pdfFooterCCL))
          .buffer
          .asUint8List());

  final ieltsIcon = MemoryImage(
      (await rootBundle.load(IconsPNG.pdfFooterIelts))
          .buffer
          .asUint8List());

  final pteIcon = MemoryImage(
      (await rootBundle.load(IconsPNG.pdfFooterPte))
          .buffer
          .asUint8List());

  final aussizzIcon = MemoryImage(
      (await rootBundle.load(IconsPNG.pdfFooterAussizz))
          .buffer
          .asUint8List());

  final footerIcon = MemoryImage(
      (await rootBundle.load(IconsPNG.icAussizzLogo))
          .buffer
          .asUint8List());

  final bgImage = MemoryImage(
      (await rootBundle.load(IconsPNG.pdfA4Background))
          .buffer
          .asUint8List());

  final barcode = MemoryImage(
      (await rootBundle.load(IconsPNG.occusearchQrCode))
          .buffer
          .asUint8List());

  /*PDF list icon*/
  final courseIcon = MemoryImage(
      (await rootBundle.load(IconsPNG.icCourseFeePdf))
          .buffer
          .asUint8List());

  final livingCostIcon = MemoryImage(
      (await rootBundle.load(IconsPNG.icLivingCost))
          .buffer
          .asUint8List());

  final schoolCostIcon = MemoryImage(
      (await rootBundle.load(IconsPNG.icSchoolingFeePdf))
          .buffer
          .asUint8List());

  final travelCostIcon = MemoryImage(
      (await rootBundle.load(IconsPNG.icTravellingFeePdf))
          .buffer
          .asUint8List());

  /* Custom fonts for PDF*/
  final regularFont = await fontFromAssetBundle('assets/fonts/notosans-regular.ttf');
  final mediumFont = await fontFromAssetBundle('assets/fonts/notosans-medium.ttf');
  final semiBoldFont = await fontFromAssetBundle('assets/fonts/notosans-semibold.ttf');

  /*Custom colors for PDF*/
  const PdfColor lightBlue = PdfColor.fromInt(0xff00549A);
  const PdfColor lightGrey = PdfColor.fromInt(0xff595959);

  convertCurrency(double price) {
    return price * currencyModel!.rate;
  }

  // [PAGE-1] Cover OccuSearch banner
  pdf.addPage(
    Page(
      pageTheme: PageTheme(
        pageFormat: format.copyWith(
          marginBottom: 0,
          marginLeft: 0,
          marginRight: 0,
          marginTop: 0,
        ),
        orientation: PageOrientation.portrait,
        buildBackground: (context) => Image(imageLogo, fit: BoxFit.fill),
      ),
      build: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(children: [
            Expanded(
              child: Align(
                alignment: Alignment.topLeft,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      UrlLink(child: Image(occuSearchIcon, height: 40.0), destination: FundCalcPDFConstants.referAFriendDynamicLink),
                      UrlLink(
                          child: Image(headerAussizzIcon, height: 50.0),
                          destination:FundCalcPDFConstants.aussizzWebsiteUrl
                      ),
                    ]),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30.0, horizontal: 10.0),
                    child: UrlLink(
                        child: Image(barcode),
                        destination: FundCalcPDFConstants.referAFriendDynamicLink),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      UrlLink(
                          child: Image(aussizzIcon),
                          destination: FundCalcPDFConstants.aussizzWebsiteUrl),
                      UrlLink(
                          child: Image(pteIcon),
                          destination: FundCalcPDFConstants.pteWebsite),
                      UrlLink(
                          child: Image(ieltsIcon),
                          destination: FundCalcPDFConstants.ieltsWebsite),
                      UrlLink(
                          child: Image(cclIcon),
                          destination: FundCalcPDFConstants.cclWebsite),
                    ],
                  ),
                ],
              ),
            ),
          ]),
        );
      },
    ),
  );

  // [PAGE-2] Question & Answer with user score
  pdf.addPage(
    MultiPage(
      header: (Context context) {
        return Padding(
            padding: const EdgeInsets.only(top: 20, left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [Image(occuSearchIcon, height: 25)],
            ));
      },
      footer: (Context context) {
        return Padding(
            padding:
                const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(children: [
                  UrlLink(
                      child: Image(footerIcon, height: 30),
                      destination: FundCalcPDFConstants.aussizzWebsiteUrl),
                  SizedBox(width: 20.0),
                  Text(footerDateTime)
                ]),
                Text(
                    'Page ${context.pageNumber - 1} of ${context.pagesCount - 1}',
                    style: TextStyle(
                        fontSize: 12.0,
                        font: mediumFont,
                        color: PdfColors.grey))
              ],
            ));
      },
      pageTheme: PageTheme(
        pageFormat: format.copyWith(
          marginBottom: 0,
          marginLeft: 0,
          marginRight: 0,
          marginTop: 0,
        ),
        orientation: PageOrientation.portrait,
        buildBackground: (context) => Image(bgImage, fit: BoxFit.fill),
      ),
      crossAxisAlignment: CrossAxisAlignment.start,
      build: (Context context) => <Widget>[
        Padding(
          child: Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                color: PdfColors.white),
            child: Column(children: [
              Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      color: lightBlue),
                  margin: const EdgeInsets.only(bottom: 20.0),
                  padding: const EdgeInsets.all(15),
                  child: Text('Fund Calculator',
                      style: TextStyle(
                          fontSize: 14.0,
                          font: semiBoldFont,
                          fontWeight: FontWeight.bold,
                          color: PdfColors.white))),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Image(courseIcon, height: 35),
                        ),
                        SizedBox(width: 10),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  fundQuestions[0].category.toString(),
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      font: semiBoldFont,
                                      fontWeight: FontWeight.bold,
                                      color: PdfColors.black)),
                              SizedBox(height: 5),
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 2),
                                      child: Text('\u2022',
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              font: semiBoldFont,
                                              fontWeight: FontWeight.normal,
                                              color: lightBlue)),
                                    ),
                                    Text(' 12 month fee included',
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            font: regularFont,
                                            fontWeight: FontWeight.normal,
                                            color: lightGrey)),
                                  ])
                            ]),
                      ]),
                      Text(
                          "${currencyModel!.symbolCode} ${Utility.getAmountInCurrencyFormat(
                                  amount: convertCurrency(fundQuestions[0]
                                      .answerAmount))}",
                          style: TextStyle(
                              fontSize: 14.0,
                              font: semiBoldFont,
                              fontWeight: FontWeight.bold,
                              color: PdfColors.black)),
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Divider(color: PdfColors.grey400, thickness: 0.5),
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Image(livingCostIcon, height: 35),
                        ),
                        SizedBox(width: 10),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  fundQuestions[1].category.toString(),
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      font: semiBoldFont,
                                      fontWeight: FontWeight.bold,
                                      color: PdfColors.black)),
                              SizedBox(height: 5),
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 2),
                                      child: Text('\u2022',
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              font: semiBoldFont,
                                              fontWeight: FontWeight.normal,
                                              color: lightBlue)),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: fundQuestions[2].answer ==
                                                      "true"
                                                  ? ' spouse '
                                                  : " no spouse included",
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  font: regularFont,
                                                  fontWeight: FontWeight.normal,
                                                  color: lightGrey)),
                                          TextSpan(
                                              text: fundQuestions[2].answer ==
                                                      "true"
                                                  ? '+\$${Utility.getAmountInCurrencyFormat(
                                                          amount: fundQuestions[2].amount!
                                                              .toDouble())}'
                                                  : "",
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  font: regularFont,
                                                  fontWeight: FontWeight.normal,
                                                  color: lightBlue)),
                                        ],
                                      ),
                                    )
                                  ]),
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 2),
                                      child: Text('\u2022 ',
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              font: semiBoldFont,
                                              fontWeight: FontWeight.normal,
                                              color: lightBlue)),
                                    ),
                                    Text(
                                        "${fundQuestions[3].answer.isNotEmpty == true ? fundQuestions[3].answer : "0"} Children",
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            font: regularFont,
                                            fontWeight: FontWeight.normal,
                                            color: lightGrey)),
                                  ])
                            ]),
                      ]),
                      Text(
                          "${currencyModel.symbolCode} ${Utility.getAmountInCurrencyFormat(
                                  amount:convertCurrency(livingCostTotalAmount))}",
                          style: TextStyle(
                              fontSize: 14.0,
                              font: semiBoldFont,
                              fontWeight: FontWeight.bold,
                              color: PdfColors.black)),
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Divider(color: PdfColors.grey400, thickness: 0.5),
              ),
              SizedBox(height: 15),
                fundQuestions[4].answerAmount != 0.0
                  ? Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Image(schoolCostIcon, height: 35),
                                ),
                                SizedBox(width: 10),
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(fundQuestions[4]
                                              .category
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              font: regularFont,
                                              fontWeight: FontWeight.bold,
                                              color: PdfColors.black)),
                                      SizedBox(height: 5),
                                      Row(children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 2),
                                          child: Text('\u2022 ',
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  font: semiBoldFont,
                                                  fontWeight: FontWeight.normal,
                                                  color: lightBlue)),
                                        ),
                                        Text(
                                        "${fundQuestions[4].answer} Children",
                                            style: TextStyle(
                                                fontSize: 12.0,
                                                font: semiBoldFont,
                                                fontWeight: FontWeight.normal,
                                                color: lightGrey))
                                      ]),
                                    ]),
                              ]),
                              Text(
                                  "${currencyModel.symbolCode} ${Utility.getAmountInCurrencyFormat(
                                          amount: convertCurrency(fundQuestions[4]
                                              .answerAmount))}",
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      font: semiBoldFont,
                                      fontWeight: FontWeight.bold,
                                      color: PdfColors.black)),
                            ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child:
                            Divider(color: PdfColors.grey400, thickness: 0.5),
                      ),
                      SizedBox(height: 15),
                    ])
                  : Container(),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Image(travelCostIcon, height: 35),
                        ),
                        SizedBox(width: 10),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  fundQuestions[5].category
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      font: semiBoldFont,
                                      fontWeight: FontWeight.bold,
                                      color: PdfColors.black)),
                              SizedBox(height: 5),
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 2),
                                      child: Text('\u2022 ',
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              font: semiBoldFont,
                                              fontWeight: FontWeight.normal,
                                              color: lightBlue)),
                                    ),
                                    Text(
                                        " ${fundQuestions[5].options?.firstWhere(
                                              (element) => (element.optionId ==
                                                      int.parse(fundQuestions[
                                                                  5]
                                                              .answer
                                                              .isEmpty
                                                          ? "0"
                                                          : fundQuestions[
                                                                  5]
                                                              .answer) ||
                                                  element.isSelected),
                                            ).option}",
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            font: regularFont,
                                            fontWeight: FontWeight.normal,
                                            color: lightGrey)),
                                  ])
                            ]),
                      ]),
                      Text(
                          "${currencyModel.symbolCode} ${Utility.getAmountInCurrencyFormat(
                                  amount: convertCurrency(fundQuestions[5]
                                      .answerAmount))}",
                          style: TextStyle(
                              fontSize: 14.0,
                              font: semiBoldFont,
                              fontWeight: FontWeight.bold,
                              color: PdfColors.black)),
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Divider(color: PdfColors.grey400, thickness: 0.5),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Text('Total: ',
                      style: TextStyle(
                          fontSize: 18.0,
                          font: regularFont,
                          fontWeight: FontWeight.normal,
                          color: PdfColors.black)),
                  Text(
                      "${currencyModel.symbolCode} ${Utility.getAmountInCurrencyFormat(
                              amount: convertCurrency(totalCost)
                              // amount: convertCurrency(fundAnswerSavedBloc?.totalFundAmount() ?? 0)
                      )
                      }",
                      style: TextStyle(
                          fontSize: 18.0,
                          font: semiBoldFont,
                          fontWeight: FontWeight.bold,
                          color: PdfColors.black)),
                ]),
              ),
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 20, bottom: 30),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('All rates are for indicative purpose only:',
                          style: TextStyle(
                              fontSize: 16.0,
                              font: semiBoldFont,
                              fontWeight: FontWeight.normal,
                              color: PdfColors.black)),
                      SizedBox(height: 10),
                      Text(
                          "Please note that foreign exchange rates regularly rise and fall. It shows the market rate of your chosen currencypair for information purposes and is not our offered rate or an indication of price. These results should,therefore, be used only as a guide.",
                          style: TextStyle(
                              font: regularFont,
                              fontSize: 12.0,
                              fontWeight: FontWeight.normal,
                              color: lightGrey)),
                    ]),
              ),
            ]),
          ),
          padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
        ),
        SizedBox(height: 50.0)
      ],
    ),
  );
  return pdf.save();
}
