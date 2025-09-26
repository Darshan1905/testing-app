import 'package:html_to_pdf_plus/html_to_pdf_plus.dart';
import 'package:intl/intl.dart';
import 'package:occusearch/data_provider/firebase/remote_config/firebase_remote_config.dart';
import 'package:path_provider/path_provider.dart';

/// ********  Table Header Column name  ***********

/*Future<Uint8List> generatePDFForRecentUpdates(String? title, String? subTitle,
    String? content, String? recentChangesId) async {
  // current time in PDF footer
  var currDt = DateTime.now();
  DateFormat formatter = DateFormat('dd-MMM-yyyy HH:mm:ss aaa');
  // 03-Oct-2022 12:25:20 PM IST
  // print("${formatter.format(currDt)}, ${currDt.timeZoneName}");
  String footerDateTime = "${formatter.format(currDt)}, ${currDt.timeZoneName}";

  final pdf = Document();
  PdfPageFormat format = PdfPageFormat.a4;

  */ /* Custom colors for PDF*/ /*
  const PdfColor bgGrey = PdfColor.fromInt(0xffD9E1E8);
  const PdfColor bgPrimary = PdfColor.fromInt(0xFF00549A);
  const PdfColor bgWhite = PdfColor.fromInt(0xFFffffff);

  // Image and logo to be used in PDF
  final footerIcon = MemoryImage(
      (await rootBundle.load(IconsPNG.icAussizzLogo)).buffer.asUint8List());

  final playStoreIcon = MemoryImage(
      (await rootBundle.load(IconsPNG.googlePlayStoreIcon))
          .buffer
          .asUint8List());

  final appStoreIcon = MemoryImage(
      (await rootBundle.load(IconsPNG.appStoreIcon)).buffer.asUint8List());

  final occuSearchIcon = MemoryImage(
      (await rootBundle.load(IconsPNG.pdfOccusearchHeaderLogo))
          .buffer
          .asUint8List());

  List<Widget> widgets = [];

  widgets.add(Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(20.0),
          color: bgPrimary,
          width: double.infinity,
          child: Text(
            title!,
            style: TextStyle(
                color: bgWhite,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 15.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Text(
            subTitle!,
            style: TextStyle(
                fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 15.0),
      ]));

  // widgets.addAll(await HTMLToPdf().convert(content!));
  widgets.add(Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: await HTMLToPdf().convert(content!))));

  pdf.addPage(
    MultiPage(
      maxPages: 2,
      footer: (Context context) {
        return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(children: [
              Divider(height: 2.0, thickness: 1.5, color: bgGrey),
              SizedBox(height: 20.0),
              Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      UrlLink(
                          child: Image(playStoreIcon, height: 30),
                          destination: StringHelper.playStoreLink),
                      SizedBox(width: 20.0),
                      UrlLink(
                          child: Image(appStoreIcon, height: 30),
                          destination: StringHelper.appStoreLink),
                      SizedBox(width: 20.0)
                    ]),
                    Row(children: [
                      UrlLink(
                          child: Image(occuSearchIcon, height: 25),
                          destination: StringHelper.referAFriendDynamicLink),
                      SizedBox(width: 20.0),
                      Text("|"),
                      SizedBox(width: 20.0),
                      UrlLink(
                          child: Image(footerIcon, height: 30),
                          destination: StringHelper.aussizzWebsiteUrl),
                    ])
                  ]),
            ]));
      },
      pageTheme: PageTheme(
        pageFormat: format.copyWith(
          marginBottom: 0,
          marginLeft: 0,
          marginRight: 0,
          marginTop: 0,
        ),
        orientation: PageOrientation.portrait,
        //buildBackground: (context) => Image(aussizzIcon, fit: BoxFit.fill),
      ),
      crossAxisAlignment: CrossAxisAlignment.start,
      build: (Context context) => <Widget>[
        Wrap(
          children: List<Widget>.generate(widgets.length, (int index) {
            final issue = widgets[index];
            return Container(
              child: Column(
                children: <Widget>[issue],
              ),
            );
          }),
        ),
      ],
    ),
  );

  return pdf.save();
}*/

//to remove Span and strong tags from HTML content
String removeSpanTags(String html) {
  RegExp exp = RegExp(r'<span[^>]*>(.*?)<\/span>',
      multiLine: true, caseSensitive: false);
  RegExp exp1 = RegExp(r'<strong[^>]*>(.*?)<\/strong>',
      multiLine: true, caseSensitive: false);
  html = html.replaceAllMapped(
      exp1,
      (match) =>
          match.group(1) ??
          ''); // Replace with the content inside the <strong> tag
  return html.replaceAllMapped(
      exp,
      (match) =>
          match.group(1) ??
          ''); // Replace with the content inside the <span> tag
}

// convert [HTML] to [PDF] file & store into external storage[data/data/com.aussizzgroup.occusearch/app_flutter]
Future<String> createDocument(String title, String subTitle,
    String? publishDateTime, String content) async {
  late final dateFormat = DateFormat('dd MMMM yyyy');
  late final utcFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
  final date = utcFormat.parse(publishDateTime ?? '');
  final latestUpdateDate = dateFormat.format(date);
  String htmlContent =
      """<html lang="en-us"><body style="padding:0px;margin:0px"><p style="background-color:#00549A; width:100%;font-weight:900;color:white;padding:20px;font-size:22px">$title</p><div style="margin:20px;"><div style="color:grey;float:right;">Published on $latestUpdateDate</div>""";
  String temp = htmlContent +
      removeSpanTags(content).replaceAll("<table>",
          "<table border='1' style='border-collapse:collapse;border: 1px solid black;'>");
  // [ FOOTER PART ]
  temp =
      """$temp</div><div style="width:100%;height:1px;background-color:#D2D2D2;margin-top:50px;"></div><br/>""";
  temp =
      """$temp<a href="https://apps.apple.com/sa/app/occusearch-anzsco-search-tool/id1619089046" target="_blank" style="margin-left:20px"><img src="${FirebaseRemoteConfigController.shared.dynamicEndUrl!.general!.cdnUrl}images/ic_app_store.webp" alt="https://apps.apple.com/sa/app/occusearch-anzsco-search-tool/id1619089046" width="100px" height="30px" style="margin-right:10px"/></a>""";
  temp =
      """$temp<a href="https://play.google.com/store/apps/details?id=com.aussizzgroup.occusearch" target="_blank"><img src="${FirebaseRemoteConfigController.shared.dynamicEndUrl!.general!.cdnUrl}images/ic_google_playstore.webp" alt="https://play.google.com/store/apps/details?id=com.aussizzgroup.occusearch" width="100px" height="30px" style="margin-right:10px"/></a>""";

  temp =
      """$temp<div style="float: right; display: inline-flex; align-items: center;"><a href="https://www.aussizzgroup.com/occusearch" target="_blank"><img src="${FirebaseRemoteConfigController.shared.dynamicEndUrl!.general!.cdnUrl}images/ic_occusearch.webp" alt="https://www.aussizzgroup.com/occusearch" height="30px"  style="margin-right:10px"/></a>""";
  temp =
      """$temp<span style="margin-right: 10px;"><div style="width: 1px; height: 25px; background-color: #D2D2D2; display: inline-block;"></div></span>""";
  temp =
      """$temp<span><a href="https://www.aussizzgroup.com" target="_blank"><img src="${FirebaseRemoteConfigController.shared.dynamicEndUrl!.general!.cdnUrl}images/ic_aussizzgroup-124.webp" alt="https://www.aussizzgroup.com/occusearch" height="30px" style="margin-right:20px"/></a></span></div>""";

  temp = """$temp</body></html>""";
  final targetPath = (await getApplicationDocumentsDirectory()).path;
  var generatedPdfFile = await HtmlToPdf.convertFromHtmlContent(
      htmlContent: temp,
      configuration: PdfConfiguration(
          targetDirectory: targetPath, targetName: "occusearch_recent_update"));
  return generatedPdfFile.path;
}
