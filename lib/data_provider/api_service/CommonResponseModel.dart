// ignore_for_file: prefer_typing_uninitialized_variables, file_names

class CommonResponseModel {
  bool? flag;
  String? message;
  var outdata;
  var outdata1;
  var data;
  var bytedata;

  CommonResponseModel(
      {this.flag,
      this.message,
      this.outdata,
      this.outdata1,
      this.data,
      this.bytedata});

  CommonResponseModel.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    message = json['message'];
    outdata = json['outdata'];
    outdata1 = json['outdata1'];
    data = json['data'];
    bytedata = json['bytedata'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['flag'] = flag;
    data['message'] = message;
    data['outdata'] = outdata;
    data['outdata1'] = outdata1;
    data['data'] = this.data;
    data['bytedata'] = bytedata;
    return data;
  }
}
