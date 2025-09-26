// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:occusearch/features/visa_fees/model/visa_fees_table_model.dart';
import 'package:occusearch/resources/icons.dart';
import 'package:occusearch/resources/string_helper.dart';
import 'package:occusearch/utility/utils.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

/// ********  Table Header Column name  ***********
final tableHeaders = [
  'Applicant',
  'Base Application Fee',
  'Subsequent Temp Entry Fee',
  'Total',
];

Future<Uint8List> generatePDFForVisaFees(
    List<VisaFeesPriceTableModel> visaFeesEstimatedFData) async {
  // current time in PDF footer
  var currDt = DateTime.now();
  DateFormat formatter = DateFormat('dd-MMM-yyyy HH:mm:ss aaa');
  // 03-Oct-2022 12:25:20 PM IST
  // print("${formatter.format(currDt)}, ${currDt.timeZoneName}");
  String footerDateTime = "${formatter.format(currDt)}, ${currDt.timeZoneName}";

  /// ***** Fees Table Widgets *****
  List<Widget> widgetVisaFeesTable = [];
  for (var visaFeesRowData in visaFeesEstimatedFData) {
    int count = 0;
    List<String> title =
        []; // Main Applicant, secondary applicant 1, 2, 3 label  etc
    List<double> base = []; // Base application fees
    List<double> sequent = []; // sub-sequent temp entry fees

    // fees data...
    List<PriceTableRowModel> feesTableData = visaFeesRowData.priceTable;
    for (int i = 0; i < feesTableData.length; i++) {
      // Title
      if (feesTableData[i].sequence == 0) {
        if (i != 0) {
          count++;
        }
        //material_style.debugPrint("--------------------");
        title.insert(count, feesTableData[i].label);
        base.insert(count, 0);
        sequent.insert(count, 0);
        //material_style.debugPrint("$count");
        //material_style.debugPrint(feesTableData[i].label);
      }
      // Base Applicant Fees
      if (feesTableData[i].sequence == 1) {
        base[count] = feesTableData[i].fees;
        //material_style.debugPrint(feesTableData[i].fees_aud);
      }
      // sub-sequent temp fees
      if (feesTableData[i].sequence == 2) {
        sequent[count] = feesTableData[i].fees;
        //material_style.debugPrint(feesTableData[i].fees_aud);
      }
    }
    // ascending order
    title.reversed;
    base.reversed;
    sequent.reversed;

    var visaFeesMap = <Map<String, String>>[
      for (int i = 0; i <= count; i++)
        {
          "name": title[i],
          "base": Utility.getAmountInCurrencyFormat(amount: base[i]),
          "sub_sequent": Utility.getAmountInCurrencyFormat(amount: sequent[i]),
          "total":
              Utility.getAmountInCurrencyFormat(amount: (base[i] + sequent[i])),
        },
    ];

    List<List<String>>? visaFeesTableData = [];
    for (int i = 0; i < visaFeesMap.length; i++) {
      visaFeesTableData.add(visaFeesMap[i].values.toList());
    }

    // Adding every visa fees table widget...
    widgetVisaFeesTable.add(await visaPriceTableRow(
        visaName: visaFeesRowData.visaSubclassName,
        notesList: visaFeesRowData.notesList,
        visaFeesTableData: visaFeesTableData,
        visaFeesModel: visaFeesRowData));
  }

  final pdf = Document();
  PdfPageFormat format = PdfPageFormat.a4;

  /* Custom fonts for PDF*/
  final mediumFont =
      await fontFromAssetBundle('assets/fonts/notosans-semibold.ttf');
  /* Custom colors for PDF*/
  const PdfColor bgGrey = PdfColor.fromInt(0xffD9E1E8);

  // Image and logo to be used in PDF
  final imageLogo = MemoryImage(
      (await rootBundle.load(IconsPNG.pdfA4VisaFeesBackground))
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
      (await rootBundle.load(IconsPNG.pdfFooterAussizz)).buffer.asUint8List());

  final footerIcon = MemoryImage(
      (await rootBundle.load(IconsPNG.icAussizzLogo)).buffer.asUint8List());

  final bgImage = MemoryImage(
      (await rootBundle.load(IconsPNG.pdfA4Background)).buffer.asUint8List());

  final barcode = MemoryImage(
      (await rootBundle.load(IconsPNG.occusearchQrCode)).buffer.asUint8List());

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
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 30.0, horizontal: 10.0),
                      child: UrlLink(
                          child: Image(barcode),
                          destination: StringHelper.referAFriendDynamicLink),
                    ),
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

  // [PAGE-2] Visa Fees Estimation Price Table
  pdf.addPage(
    MultiPage(
      header: (Context context) {
        return Padding(
          padding: const EdgeInsets.only(top: 20, left: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [Image(occuSearchIcon, height: 15)],
          ),
        );
      },
      footer: (Context context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    "Disclaimer: ",
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Text(
                      "The information contained in this document is provided for informational purposes only, and should not be construed as legal advice on any subject matter.",
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ]),
                Divider(),
                Row(
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
                            fontSize: 12.0, font: mediumFont, color: bgGrey))
                  ],
                )
              ]),
        );
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
      build: (Context context) => widgetVisaFeesTable,
    ),
  );

  return pdf.save();
}

Future<Widget> visaPriceTableRow(
    {required String visaName,
    required List<String> notesList,
    required List<List<String>> visaFeesTableData,
    required VisaFeesPriceTableModel visaFeesModel}) async {
  MemoryImage? surchargeImage;
  try {
    if (visaFeesModel.surchargeImage.isNotEmpty) {
      surchargeImage = MemoryImage((await NetworkAssetBundle(
                  Uri.parse(StringHelper.occusearchDomainName))
              .load(visaFeesModel.surchargeImage))
          .buffer
          .asUint8List());
    }
  } catch (e) {
    printLog(e);
  }

/* Custom fonts for PDF*/
  final regularFont =
      await fontFromAssetBundle('assets/fonts/notosans-regular.ttf');
  final mediumFont =
      await fontFromAssetBundle('assets/fonts/notosans-medium.ttf');
  final semiBoldFont =
      await fontFromAssetBundle('assets/fonts/notosans-semibold.ttf');
  final boldFont = await fontFromAssetBundle('assets/fonts/notosans-bold.ttf');

/*Custom colors for PDF*/
  const PdfColor lightBlue = PdfColor.fromInt(0xff00549A);
  const PdfColor lightGrey = PdfColor.fromInt(0xff7E7E7E);
  const PdfColor tableBorderColor = PdfColor.fromInt(0xff595959);
  const PdfColor tableHeaderColor = PdfColor.fromInt(0xffF0F5FF);
  return Container(
    decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: PdfColors.white),
    margin: const EdgeInsets.all(20.0),
    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      // [Visa subclass title]
      Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            color: lightBlue),
        margin: const EdgeInsets.only(bottom: 0.0),
        padding: const EdgeInsets.all(10),
        child: Text(
          visaName,
          textAlign: TextAlign.left,
          style: TextStyle(
            font: boldFont,
            color: PdfColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      // [Visa Price table]
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.3),
        child: TableHelper.fromTextArray(
          headers: tableHeaders,
          // Table header title
          data: visaFeesTableData,
          border: TableBorder.all(width: 0.5, color: tableBorderColor),
          headerStyle: TextStyle(font: semiBoldFont, color: PdfColors.black),
          headerDecoration: const BoxDecoration(color: tableHeaderColor),
          cellHeight: 30.0,
          cellAlignments: {
            0: Alignment.centerLeft,
            1: Alignment.centerRight,
            2: Alignment.centerRight,
            3: Alignment.centerRight,
            4: Alignment.centerRight,
          },
        ),
      ),

      // [Visa fees Total, sub total others]
      Padding(
        padding: const EdgeInsets.only(top: 10, right: 5.0),
        child: Container(
          alignment: Alignment.centerRight,
          child: Row(
            children: [
              Spacer(flex: 5),
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // [Sub total]
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Sub total: ',
                            style: TextStyle(
                              font: semiBoldFont,
                            ),
                          ),
                        ),
                        Text(
                          "${visaFeesModel.currencyShortCode} ${Utility.getAmountInCurrencyFormat(amount: visaFeesModel.subTotal)}",
                          style: TextStyle(font: semiBoldFont),
                        ),
                      ],
                    ),
                    // [Non-internet App. charge]
                    visaFeesModel.nonInternetCharge > 0
                        ? Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Non-internet App. charge: ',
                                  style: TextStyle(font: semiBoldFont),
                                ),
                              ),
                              Text(
                                '${visaFeesModel.currencyShortCode} ${Utility.getAmountInCurrencyFormat(amount: visaFeesModel.nonInternetCharge)}',
                                style: TextStyle(font: semiBoldFont),
                              ),
                            ],
                          )
                        : Container(),
                    // [Surcharge]
                    Row(
                      children: [
                        surchargeImage != null
                            ? Image(surchargeImage, height: 20.0)
                            : Container(),
                        SizedBox(width: 3.0),
                        Expanded(
                          child: Text(
                            'Surcharge(${visaFeesModel.surchargesPercentage}%): ',
                            style: TextStyle(font: semiBoldFont),
                          ),
                        ),
                        Text(
                          '${visaFeesModel.currencyShortCode} ${Utility.getAmountInCurrencyFormat(amount: visaFeesModel.surcharges)}',
                          style: TextStyle(font: semiBoldFont),
                        ),
                      ],
                    ),
                    Divider(),
                    // [Total]
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Total :',
                            style:
                                TextStyle(fontSize: 14.0, font: semiBoldFont),
                          ),
                        ),
                        Text(
                          '${visaFeesModel.currencyShortCode} ${Utility.getAmountInCurrencyFormat(amount: visaFeesModel.total)}',
                          style: TextStyle(font: semiBoldFont),
                        ),
                      ],
                    ),
                    SizedBox(height: 2 * PdfPageFormat.mm),
                    Container(height: 1, color: PdfColors.grey400),
                    SizedBox(height: 0.5 * PdfPageFormat.mm),
                    Container(height: 1, color: PdfColors.grey400),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      SizedBox(height: 25),
      // [Visa subclass Notes]
      notesList.isNotEmpty
          ? Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  color: PdfColors.white),
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              margin: const EdgeInsets.all(15.0),
              child: Column(
                children: List<Widget>.generate(
                  notesList.length,
                  (index) => rowNotesData(notesList[index], regularFont,
                      mediumFont, mediumFont, lightBlue, lightGrey),
                ),
              ),
            )
          : Container(),
    ]),
  );
}

Widget rowNotesData(String qData, TtfFont regularFont, TtfFont mediumFont,
    TtfFont semiBoldFont, PdfColor lightBlue, PdfColor lightGrey) {
  return Container(
    margin: const EdgeInsets.only(bottom: 5.0, top: 5.0),
    child: Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(qData,
                    style: TextStyle(
                      fontSize: 12.0,
                      font: semiBoldFont,
                    )),
              ),
              SizedBox(height: 15.0),
            ],
          ),
        ),
      ]),
      SizedBox(height: 5.0),
    ]),
  );
}
