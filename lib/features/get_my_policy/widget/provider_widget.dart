import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/get_my_policy/gmp_bloc.dart';
import 'package:occusearch/features/get_my_policy/model/gmp_model.dart';

class ProviderWidget extends StatelessWidget {
  final GetMyPolicyBloc? gmpBloc;

  const ProviderWidget({Key? key, required this.gmpBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: gmpBloc?.providerStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: AppColorStyle.backgroundVariant(context)));
          }
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: AppColorStyle.backgroundVariant(context)),
            child: DropdownButtonHideUnderline(
              child: StreamBuilder(
                  stream: gmpBloc?.getSelectedProviderStream,
                  builder: (context, selectedCoverType) {
                    return DropdownButton<PolicyData>(
                      value: selectedCoverType.hasData
                          ? selectedCoverType.data
                          : snapshot.data!.first,
                      borderRadius: BorderRadius.circular(10.0),
                      dropdownColor: AppColorStyle.backgroundVariant(context),
                      isExpanded: true,
                      icon: SvgPicture.asset(
                        IconsSVG.icDownArrow,
                        colorFilter: ColorFilter.mode(
                          AppColorStyle.text(context),
                          BlendMode.srcIn,
                        ),
                      ),
                      selectedItemBuilder: (BuildContext context) {
                        return snapshot.data!.map<Widget>((PolicyData item) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 5.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                item.name ?? "",
                                overflow: TextOverflow.clip,
                                maxLines: 2,
                                style: AppTextStyle.subTitleRegular(
                                    context, AppColorStyle.text(context)),
                              ),
                            ),
                          );
                        }).toList();
                      },
                      items: snapshot.data!.map<DropdownMenuItem<PolicyData>>(
                          (PolicyData value) {
                        return DropdownMenuItem<PolicyData>(
                          value: value,
                          child: Column(
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    value.name ?? "",
                                    maxLines: 3,
                                    overflow: TextOverflow.visible,
                                    style: AppTextStyle.detailsMedium(
                                        context, AppColorStyle.text(context)),
                                  ),
                                ),
                              ),
                              value == snapshot.data?.last
                                  ? Container()
                                  : Divider(
                                      color:
                                          AppColorStyle.surfaceVariant(context),
                                      thickness: 0.5),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (PolicyData? value) {
                        gmpBloc?.selectedProviderStream.add(value!);
                      },
                    );
                  }),
            ),
          );
        });
  }
}
