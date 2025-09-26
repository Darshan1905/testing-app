import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/labour_insights/unit_group_charts/unit_group_age_profile_chart.dart';
import 'package:occusearch/features/labour_insights/unit_group_charts/unit_group_earnings_chart.dart';
import 'package:occusearch/features/labour_insights/unit_group_charts/unit_group_qualification_chart.dart';
import 'package:occusearch/features/labour_insights/unit_group_charts/unit_group_workers_chart.dart';
import 'package:occusearch/features/labour_insights/widgets/characteristic_data_widget.dart';
import 'package:occusearch/features/labour_insights/widgets/employee_outlook_data_widget.dart';
import 'package:occusearch/features/labour_insights/widgets/industries_data_widget.dart';
import 'package:occusearch/features/labour_insights/widgets/snapshot_data_widget.dart';
import 'package:occusearch/features/labour_insights/widgets/unit_group_summary_widget.dart';
import 'package:occusearch/features/discover_dream/unit_group/model/unit_group_detail_model.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'labour_insight_bloc.dart';

class LabourInsightDetail extends StatelessWidget {
  const LabourInsightDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final labourInsightBloc = RxBlocProvider.of<LabourInsightBloc>(context);
    UnitGroupDetailData? ugDataModel =
        labourInsightBloc.unitGroupDetailsDataObject.value;
    return Container(
      color: AppColorStyle.background(context),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            //Summary of unit group
            UnitGroupSummaryWidget(ugDataModel: ugDataModel),

            //snapshot Data
            SnapShotDataWidget(ugDataModel: ugDataModel),

            //task
            TaskWidget(ugDataModel: ugDataModel),

            //Characteristic
            CharacteristicDataWidget(ugDataModel: ugDataModel),

            //Industries
            IndustriesDataWidget(ugDataModel: ugDataModel),

            //Anzsco Occupation Group
            AnzscoGroupWidget(ugDataModel: ugDataModel),

            //Employee Outlook Data
            EmployeeOutlookDataWidget(ugDataModel: ugDataModel),

            //Number of workers chart
            UnitGroupWorkersChart(unitGroupDetailData: ugDataModel),

            //weekly earnings graph
            UnitGroupEarningsChart(unitGroupDetailData: ugDataModel),

            MainIndustriesDataWidget(ugDataModel: ugDataModel),

            Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
              child: RichText(
                softWrap: true,
                textAlign: TextAlign.start,
                text: TextSpan(
                  text: StringHelper.employmentAcrossAustralia,
                  style: AppTextStyle.titleSemiBold(
                      context, AppColorStyle.text(context)),
                  children: [
                    WidgetSpan(
                        child: Text("Australia",
                            style: AppTextStyle.titleBold(
                                context, AppColorStyle.primary(context))),
                        alignment: PlaceholderAlignment.middle)
                  ],
                ),
              ),
            ),

            AustraliaRegionMapWidget(ugDataModel: ugDataModel),

            WorkProfileDataWidget(ugDataModel: ugDataModel),

            //Age Profile chart
            UnitGroupAgeProfileChart(unitGroupDetailData: ugDataModel),

            //highest qualification chart
            UnitGroupQualificationChart(unitGroupDetailData: ugDataModel),
          ],
        ),
      ),
    );
  }
}

class AustraliaRegionMapWidget extends StatefulWidget {
  final UnitGroupDetailData ugDataModel;

  const AustraliaRegionMapWidget({Key? key, required this.ugDataModel})
      : super(key: key);

  @override
  State<AustraliaRegionMapWidget> createState() =>
      _AustraliaRegionMapWidgetState();
}

class _AustraliaRegionMapWidgetState extends State<AustraliaRegionMapWidget> {
  late PageController _pageViewController;
  late MapTileLayerController _mapController;
  late MapZoomPanBehavior _zoomPanBehavior;
  late int _currentSelectedIndex;
  late int _previousSelectedIndex;
  late int _tappedMarkerIndex;
  late double _cardHeight;
  late bool _canUpdateFocalLatLng;
  late bool _canUpdateZoomLevel;

  @override
  void initState() {
    super.initState();
    _currentSelectedIndex = 0;
    _canUpdateFocalLatLng = true;
    _canUpdateZoomLevel = true;
    _mapController = MapTileLayerController();

    _zoomPanBehavior = MapZoomPanBehavior(
      minZoomLevel: 4,
      maxZoomLevel: 4,
      focalLatLng: MapLatLng(
          Utility.getLatitude(widget
              .ugDataModel.regionsEmployment![_currentSelectedIndex].state!),
          Utility.getLongitude(widget
              .ugDataModel.regionsEmployment![_currentSelectedIndex].state!)),
      enableDoubleTapZooming: true,
    );
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_canUpdateZoomLevel) {
      _zoomPanBehavior.zoomLevel = 4;
      _canUpdateZoomLevel = false;
    }
    _cardHeight = 140;
    _pageViewController = PageController(
        initialPage: _currentSelectedIndex, viewportFraction: 0.75);
    return Column(
      children: [
        SizedBox(
          height: 600,
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: Image.asset(
                  IconsPNG.mapsGrid,
                  repeat: ImageRepeat.repeat,
                ),
              ),
              SfMaps(
                layers: <MapLayer>[
                  MapTileLayer(
                    /// URL to request the tiles from the providers.
                    ///
                    /// The [urlTemplate] accepts the URL in WMTS format i.e. {z} —
                    /// zoom level, {x} and {y} — tile coordinates.
                    ///
                    /// We will replace the {z}, {x}, {y} internally based on the
                    /// current center point and the zoom level.
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    zoomPanBehavior: _zoomPanBehavior,
                    controller: _mapController,
                    initialMarkersCount:
                        widget.ugDataModel.regionsEmployment!.length,
                    tooltipSettings: const MapTooltipSettings(
                      color: Colors.transparent,
                    ),
                    markerTooltipBuilder: (BuildContext context, int index) {
                      return const SizedBox();
                    },
                    markerBuilder: (BuildContext context, int index) {
                      final double markerSize =
                          _currentSelectedIndex == index ? 40 : 25;
                      return MapMarker(
                        latitude: Utility.getLatitude(widget
                            .ugDataModel.regionsEmployment![index].state
                            .toString()),
                        longitude: Utility.getLongitude(widget
                            .ugDataModel.regionsEmployment![index].state
                            .toString()),
                        alignment: Alignment.bottomCenter,
                        child: GestureDetector(
                          onTap: () {
                            if (_currentSelectedIndex != index) {
                              _canUpdateFocalLatLng = false;
                              _tappedMarkerIndex = index;
                              _pageViewController.animateToPage(
                                index,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            height: markerSize,
                            width: markerSize,
                            child: FittedBox(
                              child: Icon(Icons.location_on,
                                  color: _currentSelectedIndex == index
                                      ? Colors.blue
                                      : Colors.red,
                                  size: markerSize),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: _cardHeight,
                  padding: const EdgeInsets.only(bottom: 10),

                  /// PageView which shows the world wonder details at the bottom.
                  child: PageView.builder(
                    itemCount: widget.ugDataModel.regionsEmployment!.length,
                    onPageChanged: _handlePageChange,
                    controller: _pageViewController,
                    itemBuilder: (BuildContext context, int index) {
                      return Transform.scale(
                        scale: index == _currentSelectedIndex ? 1 : 0.85,
                        child: Stack(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(10.0),
                              margin: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? const Color.fromRGBO(255, 255, 255, 1)
                                    : const Color.fromRGBO(66, 66, 66, 1),
                                border: Border.all(
                                  color: const Color.fromRGBO(153, 153, 153, 1),
                                  width: 0.5,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(children: <Widget>[
                                // Adding title and description for card.
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5.0, right: 5.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          widget
                                                  .ugDataModel
                                                  .regionsEmployment![index]
                                                  .state ??
                                              '',
                                          style: AppTextStyle.titleBold(context,
                                              AppColorStyle.text(context)),
                                          textAlign: TextAlign.start),
                                      const SizedBox(height: 5.0),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text:
                                                  '${widget.ugDataModel.regionsEmployment![index].worker ?? ' '}%',
                                              style: AppTextStyle.detailsBold(
                                                context,
                                                AppColorStyle.textCaption(
                                                    context),
                                              ),
                                            ),
                                            TextSpan(
                                              text: " are your",
                                              style:
                                                  AppTextStyle.captionRegular(
                                                context,
                                                AppColorStyle.textCaption(
                                                    context),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text('preferred job for this state',
                                          style: AppTextStyle.captionRegular(
                                              context,
                                              AppColorStyle.textCaption(
                                                  context)),
                                          textAlign: TextAlign.start),
                                    ],
                                  ),
                                )),
                                // Adding Image for card.
                                SvgPicture.asset(
                                  "assets/icons/svg/map_${widget.ugDataModel.regionsEmployment![index].state!.toLowerCase()}.svg",
                                  fit: BoxFit.fill,
                                )
                              ]),
                            ),
                            // Adding splash to card while tapping.
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: const BorderRadius.all(
                                    Radius.elliptical(10, 10)),
                                onTap: () {
                                  if (_currentSelectedIndex != index) {
                                    _pageViewController.animateToPage(
                                      index,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(height: 5.0, color: AppColorStyle.backgroundVariant(context)),
        const SizedBox(height: 15.0),
      ],
    );
  }

  void _handlePageChange(int index) {
    /// While updating the page viewer through interaction, selected position's
    /// marker should be moved to the center of the maps. However, when the
    /// marker is directly clicked, only the respective card should be moved to
    /// center and the marker itself should not move to the center of the maps.
    if (!_canUpdateFocalLatLng) {
      if (_tappedMarkerIndex == index) {
        _updateSelectedCard(index);
      }
    } else if (_canUpdateFocalLatLng) {
      _updateSelectedCard(index);
    }
  }

  void _updateSelectedCard(int index) {
    setState(() {
      _previousSelectedIndex = _currentSelectedIndex;
      _currentSelectedIndex = index;
    });

    /// While updating the page viewer through interaction, selected position's
    /// marker should be moved to the center of the maps. However, when the
    /// marker is directly clicked, only the respective card should be moved to
    /// center and the marker itself should not move to the center of the maps.
    if (_canUpdateFocalLatLng) {
      _zoomPanBehavior.focalLatLng = MapLatLng(
          Utility.getLatitude(widget
              .ugDataModel.regionsEmployment![_currentSelectedIndex].state!),
          Utility.getLongitude(widget
              .ugDataModel.regionsEmployment![_currentSelectedIndex].state!));
    }

    /// Updating the design of the selected marker. Please check the
    /// `markerBuilder` section in the build method to know how this is done.
    _mapController
        .updateMarkers(<int>[_currentSelectedIndex, _previousSelectedIndex]);
    _canUpdateFocalLatLng = true;
  }
}
