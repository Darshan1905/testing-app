import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:occusearch/common_widgets/stream_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/cricos_course/course_list/courses_bloc.dart';

class CourseDetailDataWidget extends StatelessWidget {
  const CourseDetailDataWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final coursesBloc = RxBlocProvider.of<CoursesBloc>(context);

    return (coursesBloc.courseDetailsDataObject.value.description != null &&
            coursesBloc.courseDetailsDataObject.value.description!.isNotEmpty)
        ? Container(
            color: AppColorStyle.backgroundVariant(context),
            padding: const EdgeInsets.symmetric(
                horizontal: Constants.commonPadding, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(StringHelper.courseDetails,
                    style: AppTextStyle.titleSemiBold(
                        context, AppColorStyle.text(context))),
                const SizedBox(height: 10.0),

                //Course Description
                StreamWidget(
                    stream: coursesBloc.isViewMoreSubject,
                    onBuild: (_, snapshot) {
                      if (snapshot != null) {
                        return HtmlWidget(
                          coursesBloc
                                  .courseDetailsDataObject.value.description ??
                              "",
                          customStylesBuilder: (element) {
                            if (element.localName == 'table' ||
                                element.localName == 'Table' ||
                                element.localName == 'TABLE') {
                              return {
                                'border': '1px solid black',
                                'border-collapse': 'collapse'
                              };
                            }
                            if (element.localName == 'td' ||
                                element.localName == 'Td' ||
                                element.localName == 'TD') {
                              return {
                                'border': '1px solid black',
                                'border-collapse': 'collapse'
                              };
                            }
                            if (element.localName == 'th' ||
                                element.localName == 'Th' ||
                                element.localName == 'TH') {
                              return {
                                'border': '1px solid black',
                                'border-collapse': 'collapse'
                              };
                            }
                            return null;
                          },
                          textStyle: AppTextStyle.detailsRegular(
                            context,
                            AppColorStyle.text(context),
                          ),
                          onTapUrl: (url) async => Utility.openUrl(url),
                          renderMode: RenderMode.column,
                        ); /*,Text(
                            coursesBloc.courseDetailsDataObject.value
                                    .description ??
                                "",
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.detailsRegular(
                                context, AppColorStyle.text(context)));*/
                      }
                    }),
                const SizedBox(height: 15),
              ],
            ),
          )
        : Container();
  }
}
