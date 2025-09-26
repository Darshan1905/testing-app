// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:occusearch/features/point_test/point_test_review/point_test_review_model/point_test_review_model/point_test_score_result_model.dart';
import 'package:occusearch/resources/icons.dart';
import 'package:occusearch/resources/string_helper.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

Future<Uint8List> generatePdf(String pointTestResultJSONString) async {
  // current time in PDF footer
  var currDt = DateTime.now();
  DateFormat formatter = DateFormat('dd-MMM-yyyy HH:mm:ss aaa');
  // 03-Oct-2022 12:25:20 PM IST
  // print("${formatter.format(currDt)}, ${currDt.timeZoneName}");
  String footerDateTime = "${formatter.format(currDt)}, ${currDt.timeZoneName}";

  // Convert Point test result question String into List<QuestionData>
  PointTestResultModel pointTestResultModel =
      PointTestResultModel.fromJson(jsonDecode(pointTestResultJSONString));
  List<QuestionScorelist> pointResultQuestionList =
      pointTestResultModel.data![0].questionlist!;

  // Calculate Total user point score
  int totalPointValue = 0;
  for (var quesValue in pointTestResultModel.data![0].questionlist!) {
    for (var element in quesValue.option!) {
      totalPointValue += int.parse(element.ovalue ?? "0");
    }
  }

  final pdf = Document();
  PdfPageFormat format = PdfPageFormat.a4;

  // Image and logo to be used in PDF
  final imageLogo = MemoryImage(
      (await rootBundle.load(IconsPNG.pointTestPdfPage))
          .buffer
          .asUint8List());

  final headerAussizzIcon = MemoryImage(
      (await rootBundle.load(IconsPNG.icAussizzLogo)).buffer.asUint8List());

  final occuSearchIcon = MemoryImage(
      (await rootBundle.load(IconsPNG.pdfOccusearchHeaderLogo))
          .buffer
          .asUint8List());

  final cclIcon = MemoryImage(
      (await rootBundle.load(IconsPNG.pdfFooterCCL)).buffer.asUint8List());

  final ieltsIcon = MemoryImage(
      (await rootBundle.load(IconsPNG.pdfFooterIelts)).buffer.asUint8List());

  final pteIcon = MemoryImage(
      (await rootBundle.load(IconsPNG.pdfFooterPte)).buffer.asUint8List());

  final aussizzIcon = MemoryImage(
      (await rootBundle.load(IconsPNG.pdfFooterAussizz))
          .buffer
          .asUint8List());

  final footerIcon = MemoryImage(
      (await rootBundle.load(IconsPNG.icAussizzLogo)).buffer.asUint8List());

  final bgImage = MemoryImage(
      (await rootBundle.load(IconsPNG.pdfA4Background)).buffer.asUint8List());

  final barcode = MemoryImage(
      (await rootBundle.load(IconsPNG.occusearchQrCode)).buffer.asUint8List());

  /* Custom fonts for PDF*/
  final regularFont = await fontFromAssetBundle('assets/fonts/notosans-regular.ttf');
  final mediumFont = await fontFromAssetBundle('assets/fonts/notosans-medium.ttf');
  final semiBoldFont = await fontFromAssetBundle('assets/fonts/notosans-semibold.ttf');

  /*Custom colors for PDF*/
  const PdfColor lightBlue = PdfColor.fromInt(0xff00549A);
  const PdfColor lightGrey = PdfColor.fromInt(0xff7E7E7E);
  const PdfColor bgGrey = PdfColor.fromInt(0xffD9E1E8);

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
                      UrlLink(
                          child: Image(occuSearchIcon, height: 40.0),
                          destination: StringHelper.referAFriendDynamicLink),
                      UrlLink(
                          child: Image(headerAussizzIcon, height: 50.0),
                          destination: StringHelper.aussizzWebsiteUrl),
                    ]),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30.0, horizontal: 10.0),
                    child: UrlLink(
                        child: Image(barcode),
                        destination: StringHelper.referAFriendDynamicLink),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      UrlLink(
                          child: Image(aussizzIcon),
                          destination: StringHelper.aussizzWebsiteUrl),
                      UrlLink(
                          child: Image(pteIcon),
                          destination: StringHelper.pteWebsite),
                      UrlLink(
                          child: Image(ieltsIcon),
                          destination: StringHelper.ieltsWebsite),
                      UrlLink(
                          child: Image(cclIcon),
                          destination: StringHelper.cclWebsite),
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
              children: [Image(occuSearchIcon, height: 15)],
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
                      destination: StringHelper.aussizzWebsiteUrl),
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
            child: Column(
              children: List<Widget>.generate(
                pointResultQuestionList.length + 1,
                (index) => index == 0
                    ? Container(
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                            color: lightBlue),
                        margin: const EdgeInsets.only(bottom: 20.0),
                        padding: const EdgeInsets.all(15),
                        child: Column(children: [
                          Row(children: [
                            Expanded(
                              child: Text('Criteria',
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      font: semiBoldFont,
                                      fontWeight: FontWeight.bold,
                                      color: PdfColors.white)),
                            ),
                            Text('Point scored',
                                style: TextStyle(
                                    fontSize: 14.0,
                                    font: semiBoldFont,
                                    fontWeight: FontWeight.bold,
                                    color: PdfColors.white))
                          ]),
                          //Divider(thickness: 0.5,color: PdfColors.grey700)
                        ]))
                    : rowData(pointResultQuestionList[index - 1], regularFont,
                        mediumFont, semiBoldFont, lightBlue, lightGrey),
              ),
            ),
          ),
          padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
        ),
        SizedBox(height: 50.0),
        Padding(
          child: Center(
              child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                      color: bgGrey,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Your Point score is ",
                            style: TextStyle(
                                fontSize: 14.0,
                                font: semiBoldFont,
                                fontWeight: FontWeight.bold,
                                color: lightBlue)),
                        Text("$totalPointValue",
                            style: TextStyle(
                                fontSize: 16.0,
                                font: semiBoldFont,
                                fontWeight: FontWeight.bold,
                                color: lightBlue))
                      ]))),
          padding: const EdgeInsets.only(left: 25, right: 25, bottom: 15),
        ),
      ],
    ),
  );

  return pdf.save();
}

Widget rowData(QuestionScorelist qData, TtfFont regularFont, TtfFont mediumFont,
    TtfFont semiBoldFont, PdfColor lightBlue, PdfColor lightGrey) {
  return Container(
      margin: const EdgeInsets.only(bottom: 5.0, left: 15, right: 15),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(qData.qtype ?? '',
                    style: TextStyle(
                        fontSize: 14.0,
                        font: semiBoldFont,
                        fontWeight: FontWeight.bold,
                        color: lightBlue)),
                SizedBox(height: 5.0),
                Text(qData.qname ?? '',
                    style: TextStyle(
                        fontSize: 12.0,
                        font: mediumFont,
                        fontWeight: FontWeight.bold,
                        color: PdfColors.grey800)),
                SizedBox(height: 5.0),
                Text(qData.option![0].oname ?? '',
                    style: TextStyle(
                        fontSize: 10.0,
                        font: regularFont,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.normal,
                        color: lightGrey)),
              ])),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
                (qData.option![0].ovalue != null &&
                        qData.option![0].ovalue!.length == 1)
                    ? "0${qData.option![0].ovalue}"
                    : qData.option![0].ovalue ?? '00',
                style: TextStyle(
                    fontSize: 14.0,
                    font: semiBoldFont,
                    fontWeight: FontWeight.bold,
                    color: PdfColors.grey900)),
          )
        ]),
        SizedBox(height: 5.0),
        Divider(thickness: 0.5, color: lightGrey)
      ]));
}
