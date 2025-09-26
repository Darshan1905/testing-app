import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_accessing_auth_details/so_access_auth_model.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_model/so_accessing_auth_detail_model.dart';

class SoAccessingAuthDetailWidget {
  static final ScrollController scrollController = ScrollController();

  static englishTestModifiedTableWidget(
      BuildContext context, AccessingAuthModel accessingAuthData) {
    String strTestTableData = "";
    List<AccessAuthEns> engData = [];

    engData.add(AccessAuthEns(
        examType: "Exam",
        listening: "Listening",
        reading: "Reading",
        writing: "Writing",
        speaking: "Speaking",
        comment: "Comment"));

    try {
      if (accessingAuthData.englishTest != null &&
          accessingAuthData.englishTest!.isNotEmpty) {
        strTestTableData = accessingAuthData.englishTestTable ?? "";
        if (strTestTableData.contains("|") && strTestTableData.contains("*")) {
          List<String> rowArrayData = strTestTableData.split("|");

          if (rowArrayData.isNotEmpty) {
            /*For add exam type only*/
            for (var rowData in rowArrayData) {
              if (rowData.isNotEmpty) {
                List<String> columnArray = rowData.split("*");
                engData.add(AccessAuthEns(
                    examType: columnArray[0].split(":").last,
                    listening: columnArray[1].split(":").last,
                    reading: columnArray[2].split(":").last,
                    writing: columnArray[3].split(":").last,
                    speaking: columnArray[4].split(":").last,
                    comment: columnArray[5].trim().split(" ").first));
              }
            }
          }
        }
      }
    } catch (e) {
      debugPrint("Accessing Authority Table Data *ERROR* : $e");
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildTSSTableCells(context, engData),
        ),
        Flexible(
          child: Scrollbar(
            //controller: scrollController,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: scrollController,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildTSSTableRows(context, engData),
              ),
            ),
          ),
        )
      ],
    );
  }

  static List<Widget> _buildTSSTableCells(
      BuildContext context, List<AccessAuthEns> engData) {
    return List.generate(
      engData.length,
      (index) => Container(
        alignment: Alignment.center,
        width: 80.0,
        height: 50.0,
        decoration: BoxDecoration(
          borderRadius: index == 0
              ? const BorderRadius.only(topLeft: Radius.circular(10))
              : index == engData.length - 1
                  ? const BorderRadius.only(bottomLeft: Radius.circular(10))
                  : BorderRadius.zero,
          color: index != 0
              ? AppColorStyle.primary(context)
              : AppColorStyle.surface(context),
        ),
        child: Text(
          engData[index].examType ?? "",
          textAlign: TextAlign.center,
          style: AppTextStyle.captionMedium(
              context,
              index != 0
                  ? AppColorStyle.textWhite(context)
                  : AppColorStyle.text(context)),
        ),
      ),
    );
  }

  static List<Widget> _buildTSSTableRows(
      BuildContext context, List<AccessAuthEns> engData) {
    return List.generate(
      engData.length,
      (index) => Column(
        children: _buildTSSTableRowData(context, engData, index),
      ),
    );
  }

  static List<Widget> _buildTSSTableRowData(
      BuildContext context, List<AccessAuthEns> engData, int pos) {
    return List.generate(
      engData.length,
      (index) => Container(
        alignment: Alignment.center,
        width: 80.0,
        height: 50.0,
        color: index % 2 == 0
            ? AppColorStyle.surface(context)
            : AppColorStyle.background(context),
        child: Text(
          "${tableTSSData(engData, index, pos)}",
          style: AppTextStyle.captionMedium(
              context,
              index == 0
                  ? AppColorStyle.primary(context)
                  : AppColorStyle.text(context)),
        ),
      ),
    );
  }

  static String? tableTSSData(List<AccessAuthEns> engData, int index, int pos) {
    if (pos == 0) {
      return engData[index].listening;
    } else if (pos == 1) {
      return engData[index].reading;
    } else if (pos == 2) {
      return engData[index].writing;
    } else if (pos == 3) {
      return engData[index].speaking;
    } else if (pos == 4) {
      return engData[index].comment;
    }
    return "";
  }
}
