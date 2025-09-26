import 'package:occusearch/constants/constants.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewerScreen extends BaseApp {
  const PDFViewerScreen({super.key}) : super.builder();

  @override
  BaseState createState() => _PDFViewerState();
}

class _PDFViewerState extends BaseState {
  @override
  Widget body(BuildContext context) {
    return Container(
      color: AppColorStyle.background(context),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColorStyle.background(context),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 25.0, vertical: 20.0),
                child: Row(
                  children: [
                    InkWellWidget(
                      child: SvgPicture.asset(IconsSVG.arrowBack,
                          height: 24,
                          width: 24,
                          colorFilter: ColorFilter.mode(
                            AppColorStyle.text(context),
                            BlendMode.srcIn,
                          )),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: Container(
                          margin: const EdgeInsets.only(left: 8),
                          child: Text(
                            "Code of conduct",
                            style: AppTextStyle.titleBold(
                              context,
                              AppColorStyle.text(context),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10, left: 25.0, right: 25.0, bottom: 15.0),
                      child: SfPdfViewer.network(Constants.cocURL)))
            ],
          ),
        ),
      ),
    );
  }

  @override
  init() {}

  @override
  onResume() {}
}
