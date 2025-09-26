import 'package:occusearch/constants/constants.dart';

class RowTitleNameWithBlueBG extends StatelessWidget {
  final String title;
  final bool isTitleOverview;

  const RowTitleNameWithBlueBG(
      {Key? key, required this.title, this.isTitleOverview = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      color: AppColorStyle.primarySurface2(context),
      child: Text(title,
          textAlign: TextAlign.center,
          style: AppTextStyle.detailsSemiBold(
              context,
              isTitleOverview
                  ? AppColorStyle.text(context)
                  : AppColorStyle.textDetail(context))),
    );
  }
}

class RowTitleOverviewWidgetGrayBG extends StatelessWidget {
  final String title;

  const RowTitleOverviewWidgetGrayBG({Key? key, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      color: AppColorStyle.backgroundVariant(context),
      child: Text(title,
          textAlign: TextAlign.center,
          style: AppTextStyle.detailsMedium(
              context, AppColorStyle.textDetail(context))),
    );
  }
}

class RowTitleNameWithGrayBG extends StatelessWidget {
  final String title;

  const RowTitleNameWithGrayBG({Key? key, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      color: AppColorStyle.backgroundVariant(context),
      child: Text(title,
          textAlign: TextAlign.center,
          style: AppTextStyle.detailsMedium(
              context, AppColorStyle.textDetail(context))),
    );
  }
}
