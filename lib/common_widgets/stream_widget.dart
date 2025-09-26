import 'package:flutter/material.dart';
import 'package:occusearch/common_widgets/widget_stream/default_error_widget.dart';
import 'package:occusearch/common_widgets/widget_stream/default_internet_fail_widget.dart';
import 'package:occusearch/common_widgets/widget_stream/default_none_widget.dart';
import 'package:occusearch/common_widgets/widget_stream/default_process_widget.dart';
import 'package:occusearch/common_widgets/widget_stream/default_vpn_widget.dart';
import 'package:occusearch/data_provider/api_service/base_response_model.dart';

class StreamWidget<T> extends StatelessWidget {
  final Function? onLoading;
  final Function onBuild;
  final Function? onError;
  final Function? onNone;
  final Function? onInternetLost;
  final Function? onVPNConnected;

  final Stream<T> stream;

  const StreamWidget({
    super.key,
    required this.stream,
    required this.onBuild,
    this.onLoading,
    this.onNone,
    this.onError,
    this.onInternetLost,
    this.onVPNConnected,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      key: key,
      stream: stream,
      builder: (context, AsyncSnapshot<T> snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          // debugPrint(
          //     "StreamBuilder<T> Datatype :: ${snapshot.data.runtimeType}");
          if (snapshot.data is BaseResponseModel) {
            BaseResponseModel response = snapshot.data as BaseResponseModel;
            switch (response.status) {
              case NetworkRequestStatus.none:
                return onNone != null
                    ? onNone!(context)
                    : WidgetNone(message: response.message);
              case NetworkRequestStatus.loading:
                return onLoading != null
                    ? onLoading!(context)
                    : const WidgetProcess();
              case NetworkRequestStatus.completed:
                return onBuild(context, snapshot.data);
              case NetworkRequestStatus.error:
                return onError != null
                    ? onError!(context)
                    : WidgetError(response.message);
              case NetworkRequestStatus.internetConnection:
                return onInternetLost != null
                    ? onInternetLost!(context)
                    : WidgetInternetLost(message: response.message);
              case NetworkRequestStatus.vpn:
                return onVPNConnected != null
                    ? onVPNConnected!(context)
                    : WidgetVPNConnected(message: response.message);
            }
          } else {
            return onBuild(context, snapshot.data);
          }
        } else if (snapshot.hasError) {
          return onError != null
              ? onError!(context)
              : WidgetError(snapshot.error);
        } else {
          return onNone != null ? onNone!(context) : const WidgetNone();
        }
      },
    );
  }
}
