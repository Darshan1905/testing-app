import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:occusearch/features/vevo_check/model/vevo_check_model.dart';
import 'package:occusearch/resources/icons.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

class VevoCheckPDFConstants {
  static const referAFriendDynamicLink = 'https://occusearch.page.link/lgn';
  static const aussizzWebsiteUrl = "https://aussizzgroup.com";
  static String pteWebsite = "https://ptetutorials.com/";
  static String cclWebsite = "https://ccltutorials.online/";
  static String ieltsWebsite = "https://ieltstutorials.online/";
}
Future<Uint8List> generatePDFForVevoCheck(VevoVisaDetailModel visaDetails,
    String? workPlace, String? workPlaceLink) async {
  // current time in PDF footer
  var currDt = DateTime.now();
  DateFormat formatter = DateFormat('dd-MMM-yyyy HH:mm:ss aaa');
  // 03-Oct-2022 12:25:20 PM IST
  // print("${formatter.format(currDt)}, ${currDt.timeZoneName}");
  String footerDateTime = "${formatter.format(currDt)}, ${currDt.timeZoneName}";

  final pdf = Document();
  PdfPageFormat format = PdfPageFormat.a4;

  // Image and logo to be used in PDF
  final imageLogo = MemoryImage(
      (await rootBundle.load(IconsPNG.vevoCheckPdfPage))
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

  //Custom fonts for PDF

  final regularFont = await fontFromAssetBundle('assets/fonts/notosans-regular.ttf');
  final mediumFont = await fontFromAssetBundle('assets/fonts/notosans-medium.ttf');
  final semiBoldFont = await fontFromAssetBundle('assets/fonts/notosans-semibold.ttf');

  //Custom colors for PDF

  const PdfColor lightBlue = PdfColor.fromInt(0xff00549A);
  const PdfColor lightGrey = PdfColor.fromInt(0xff7E7E7E);

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
                          destination: VevoCheckPDFConstants.referAFriendDynamicLink),
                      UrlLink(
                          child: Image(headerAussizzIcon, height: 50.0),
                          destination: VevoCheckPDFConstants.aussizzWebsiteUrl),
                    ]),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 30.0, horizontal: 10.0),
                      child: UrlLink(
                          child: Image(barcode),
                          destination: VevoCheckPDFConstants.referAFriendDynamicLink),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      UrlLink(
                          child: Image(aussizzIcon),
                          destination: VevoCheckPDFConstants.aussizzWebsiteUrl),
                      UrlLink(
                          child: Image(pteIcon),
                          destination: VevoCheckPDFConstants.pteWebsite),
                      UrlLink(
                          child: Image(ieltsIcon),
                          destination: VevoCheckPDFConstants.ieltsWebsite),
                      UrlLink(
                          child: Image(cclIcon),
                          destination: VevoCheckPDFConstants.cclWebsite),
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
                      destination: VevoCheckPDFConstants.aussizzWebsiteUrl),
                  SizedBox(width: 20.0),
                  Text(footerDateTime)
                ]),
                Text(
                    'Page ${context.pageNumber - 1} of ${context.pagesCount -
                        1}',
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
      build: (Context context) =>
      <Widget>[
        Padding(
          child: Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                color: PdfColors.white),
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      color: lightBlue),
                  margin: const EdgeInsets.only(bottom: 20.0),
                  padding: const EdgeInsets.all(15),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('Visa Detail Check',
                            style: TextStyle(
                                fontSize: 14.0,
                                font: semiBoldFont,
                                fontWeight: FontWeight.bold,
                                color: PdfColors.white)),
                        Text('',
                            style: TextStyle(
                                fontSize: 14.0,
                                font: semiBoldFont,
                                fontWeight: FontWeight.bold,
                                color: PdfColors.white))
                      ]),
                ),
                // Family name
                rowData(
                    "Family name",
                    visaDetails.familyName,
                    regularFont,
                    regularFont,
                    mediumFont,
                    lightBlue,
                    lightGrey),
                // Given name
                rowData(
                    "Given name(s)",
                    visaDetails.givenName,
                    regularFont,
                    regularFont,
                    mediumFont,
                    lightBlue,
                    lightGrey),
                // Visa Description
                rowData(
                    "Visa description",
                    visaDetails.visaDescription,
                    regularFont,
                    regularFont,
                    mediumFont,
                    lightBlue,
                    lightGrey),
                // Document number
                rowData(
                    "Document number",
                    visaDetails.documentNumber,
                    regularFont,
                    regularFont,
                    mediumFont,
                    lightBlue,
                    lightGrey),
                // Visa class/subclass
                rowData(
                    "Visa class/subclass",
                    visaDetails.visaClassSubclass,
                    regularFont,
                    regularFont,
                    mediumFont,
                    lightBlue,
                    lightGrey),
                // Visa applicant
                rowData(
                    "Visa applicant",
                    visaDetails.visaApplicant,
                    regularFont,
                    regularFont,
                    mediumFont,
                    lightBlue,
                    lightGrey),
                // Visa grant date
                rowData(
                    "Visa grant date",
                    visaDetails.visaGrantDate,
                    regularFont,
                    regularFont,
                    mediumFont,
                    lightBlue,
                    lightGrey),
                // Location
                rowData(
                    "Location",
                    visaDetails.location,
                    regularFont,
                    regularFont,
                    mediumFont,
                    lightBlue,
                    lightGrey),
                // Visa status
                rowData(
                    "Visa status",
                    visaDetails.visaStatus,
                    regularFont,
                    regularFont,
                    mediumFont,
                    lightBlue,
                    lightGrey),
                // Entries allowed
                rowData(
                    "Entries allowed",
                    visaDetails.entriesAllowed,
                    regularFont,
                    regularFont,
                    mediumFont,
                    lightBlue,
                    lightGrey),
                // Must not arrive after
                rowData(
                    "Must not arrive after",
                    visaDetails.mustNotArriveAfter,
                    regularFont,
                    regularFont,
                    mediumFont,
                    lightBlue,
                    lightGrey),
                // Period of stay
                rowData(
                    "Period of stay",
                    visaDetails.periodOfStay,
                    regularFont,
                    regularFont,
                    mediumFont,
                    lightBlue,
                    lightGrey),
                // Visa type
                rowData(
                    "Visa type",
                    visaDetails.visaType,
                    regularFont,
                    regularFont,
                    mediumFont,
                    lightBlue,
                    lightGrey),
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 5.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Work entitlements",
                          style: TextStyle(
                              fontSize: 14.0,
                              font: mediumFont,
                              fontWeight: FontWeight.normal,
                              color: PdfColors.grey900),
                        ),
                        Text(
                          visaDetails.workEntitlements ?? "",
                          style: TextStyle(
                              fontSize: 14.0,
                              font: regularFont,
                              fontWeight: FontWeight.bold,
                              color: PdfColors.grey600),
                        ),
                        SizedBox(height: 5.0),
                        Divider(thickness: 0.5, color: lightGrey)
                      ]),
                ),
                Container(
                  margin:
                  const EdgeInsets.only(bottom: 5.0, left: 15, right: 15),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Workplace rights",
                          style: TextStyle(
                              fontSize: 14.0,
                              font: mediumFont,
                              fontWeight: FontWeight.normal,
                              color: PdfColors.grey900),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          workPlace ?? "",
                          style: TextStyle(
                              fontSize: 14.0,
                              font: regularFont,
                              fontWeight: FontWeight.bold,
                              color: PdfColors.grey600),
                        ),
                        UrlLink(
                            child: Text(
                              workPlaceLink ?? "",
                              style: TextStyle(
                                  fontSize: 14.0,
                                  font: regularFont,
                                  fontWeight: FontWeight.normal,
                                  color: lightBlue),
                            ),
                            destination: workPlaceLink ?? ""),
                        SizedBox(height: 5.0),
                        Divider(thickness: 0.5, color: lightGrey)
                      ]),
                ),
                Container(
                  margin:
                  const EdgeInsets.only(bottom: 5.0, left: 15, right: 15),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Study entitlements",
                          style: TextStyle(
                              fontSize: 14.0,
                              font: mediumFont,
                              fontWeight: FontWeight.normal,
                              color: PdfColors.grey900),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          visaDetails.studyEntitlements ?? "",
                          style: TextStyle(
                              fontSize: 14.0,
                              font: regularFont,
                              fontWeight: FontWeight.bold,
                              color: PdfColors.grey600),
                        ),
                        SizedBox(height: 5.0),
                      ]),
                ),
              ],
            ),
          ),
          padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
        ),
      ],
    ),
  );

  return pdf.save();
}

Widget rowData(String label,
    String? value,
    TtfFont regularFont,
    TtfFont mediumFont,
    TtfFont semiBoldFont,
    PdfColor lightBlue,
    PdfColor lightGrey) {
  return Container(
    margin: const EdgeInsets.only(bottom: 5.0, left: 15, right: 15),
    child: Column(children: [
      Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                  child: Text(
                    label,
                    style: TextStyle(
                        fontSize: 14.0,
                        font: mediumFont,
                        fontWeight: FontWeight.normal,
                        color: PdfColors.grey900),
                  )),
            ),
            Expanded(
                child: Container(
                  child: Text(value ?? "",
                      style: TextStyle(
                          fontSize: 14.0,
                          font: semiBoldFont,
                          fontWeight: FontWeight.bold,
                          color: PdfColors.grey900)),
                ))
          ]),
      SizedBox(height: 5.0),
      Divider(thickness: 0.5, color: lightGrey)
    ]),
  );
}
