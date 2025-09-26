import 'dart:convert';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/common_widgets/will_pop_scope_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/data_provider/sqflite_database/entity/config_table.dart';
import 'package:occusearch/data_provider/sqflite_database/sqflite_database_constants.dart';
import 'package:occusearch/features/vevo_check/model/vevo_check_model.dart';
import 'package:occusearch/features/vevo_check/vevo_check_bloc.dart';
import 'package:occusearch/features/vevo_check/widgets/vevo_check_detail_widget.dart';


class VevoCheckDetailScreen extends BaseApp {
  const VevoCheckDetailScreen({super.key, super.arguments}) : super.builder();

  @override
  BaseState createState() => _VevoCheckDetailScreenState();
}

class _VevoCheckDetailScreenState extends BaseState {
  final VevoCheckBloc _vevoCheckBloc = VevoCheckBloc();

  @override
  Widget body(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColorStyle.background(context),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              StringHelper.vevoCheck,
              style: AppTextStyle.subHeadlineSemiBold(
                  context, AppColorStyle.text(context)),
            ),
            InkWellWidget(
              onTap: () {
                GoRoutesPage.go(
                    mode: NavigatorMode.replace, moveTo: RouteName.home);
              },
              child: Text(
                StringHelper.close,
                style: AppTextStyle.titleMedium(
                    context, AppColorStyle.red(context)),
              ),
            ),
          ],
        ),
      ),
      body: WillPopScopeWidget(
        onWillPop: () async{
          GoRoutesPage.go(
              mode: NavigatorMode.remove, moveTo: RouteName.home);
          return false;
        },
        child: RxBlocProvider(
            create: (_) => _vevoCheckBloc,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: AppColorStyle.backgroundVariant(context),
              child: SafeArea(
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        const VevoCheckVisaCardWidget(),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(left: 25.0),
                          child: Text(
                            StringHelper.moreDetails,
                            style: AppTextStyle.subTitleSemiBold(
                                context, AppColorStyle.text(context)),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const VevoCheckDetailsWidget(),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: InkWellWidget(
                        onTap: () {
                          GoRoutesPage.go(
                              mode: NavigatorMode.replace,
                              moveTo: RouteName.vevoCheck);
                          _vevoCheckBloc.setVevoResultModel(null);
                        },
                        child: Container(
                            margin: const EdgeInsets.only(bottom: 20.0),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 25.0),
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10.0)),
                              color: AppColorStyle.red(context),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(IconsSVG.icSyncOutline),
                                const SizedBox(width: 10),
                                Text(
                                  StringHelper.checkForOthers,
                                  style: AppTextStyle.subTitleMedium(context,
                                      AppColorStyle.background(context)),
                                ),
                              ],
                            )),
                      ),
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }

  @override
  init() async {
    dynamic param = widget.arguments;
    if (param != null) {
      _vevoCheckBloc.setVevoCheckDetailsModel = param;
    }

    //database
    ConfigTable? configTable =
        await ConfigTable.read(strField: ConfigFields.vevoCheckResponse);

    // if already data exists in db table
    if (configTable != null && configTable.fieldValue!.isNotEmpty) {
      CheckMyVisaModel model =
          CheckMyVisaModel.fromJson(jsonDecode(configTable.fieldValue!));
      if (model.data != null) {
        _vevoCheckBloc.setVevoResultModel(model.data!);
      }
    }
  }

  @override
  onResume() {}
}
