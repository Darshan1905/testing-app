import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/cricos_course/course_detail/model/course_detail_model.dart';
import 'package:occusearch/features/occupation_search/occupation_list/model/all_occupation_list_model.dart';

class CourseRelatedOccupationWidget extends StatelessWidget {
  final List<UgCode>? relatedOccupationsList;
  final int? selectedIndex;

  const CourseRelatedOccupationWidget(
      {Key? key,
      required this.relatedOccupationsList,
      required this.selectedIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Constants.commonPadding, vertical: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(StringHelper.occupationMainRelatedOccupations,
              style: AppTextStyle.titleSemiBold(
                  context, AppColorStyle.text(context))),
          const SizedBox(height: 20),
          ListView.builder(
              key: Key('builder ${selectedIndex.toString()}'),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              itemCount: relatedOccupationsList!.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return Theme(
                    data: ThemeData(
                      dividerColor: Colors.transparent,
                    ),
                    child: Column(
                      children: [
                        ExpansionTile(
                          childrenPadding: EdgeInsets.zero,
                          tilePadding: EdgeInsets.zero,
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                    relatedOccupationsList![index]
                                        .ugName
                                        .toString(),
                                    style: AppTextStyle.detailsMedium(
                                        context, AppColorStyle.text(context))),
                              ),
                              Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 2.0),
                                  margin: const EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                      color: AppColorStyle.primarySurface2(
                                          context),
                                      borderRadius:
                                          BorderRadius.circular(50.0)),
                                  child: relatedOccupationsList![index]
                                              .oData!
                                              .length >
                                          9
                                      ? Text(
                                          '${relatedOccupationsList![index].oData!.length}',
                                          style: AppTextStyle.captionMedium(
                                              context,
                                              AppColorStyle.primary(context)),
                                        )
                                      : Text(
                                          '0${relatedOccupationsList![index].oData!.length}',
                                          style: AppTextStyle.captionMedium(
                                              context,
                                              AppColorStyle.primary(context)),
                                        )),
                            ],
                          ),
                          initiallyExpanded: index == selectedIndex,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(bottom: 15),
                              width: double.infinity,
                              child: Wrap(
                                alignment: WrapAlignment.start,
                                runSpacing: 20,
                                spacing: 20,
                                children: List.generate(
                                    relatedOccupationsList![index]
                                        .oData!
                                        .length,
                                    (occupationIndex) => InkWellWidget(
                                          onTap: () {
                                            OccupationRowData occuRowData =
                                                OccupationRowData(
                                                    id: relatedOccupationsList![
                                                            index]
                                                        .oData![occupationIndex]
                                                        .occupationCode,
                                                    mainId:
                                                        relatedOccupationsList![
                                                                index]
                                                            .oData![
                                                                occupationIndex]
                                                            .occupationCode,
                                                    name:
                                                        relatedOccupationsList![
                                                                index]
                                                            .oData![
                                                                occupationIndex]
                                                            .occupationName);
                                            GoRoutesPage.go(
                                                mode: NavigatorMode.push,
                                                moveTo: RouteName
                                                    .occupationSearchScreen,
                                                param: occuRowData);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0, vertical: 3.0),
                                            decoration: BoxDecoration(
                                                color: relatedOccupationsList?[index].oData?[occupationIndex].randomColor,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        50.0)),
                                            child: Text(
                                              relatedOccupationsList![index]
                                                  .oData![occupationIndex]
                                                  .occupationName
                                                  .toString(),
                                              style:
                                                  AppTextStyle.captionRegular(
                                                      context,
                                                      AppColorStyle.textDetail(
                                                          context)),
                                            ),
                                          ),
                                        )),
                              ),
                            )
                          ],
                        ),
                        ((relatedOccupationsList!.length) - 1) != index
                            ? Divider(
                                color: AppColorStyle.surfaceVariant(context),
                                thickness: 0.5)
                            : const SizedBox(),
                      ],
                    ));
              })
        ],
      ),
    );
  }
}
