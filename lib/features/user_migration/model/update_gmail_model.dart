class UpdateGmailAddressModel {
  bool? flag;
  String? message;
  String? outdata;
  String? outdata1;
  String? data;
  String? bytedata;

  UpdateGmailAddressModel(
      {this.flag,
        this.message,
        this.outdata,
        this.outdata1,
        this.data,
        this.bytedata});

  UpdateGmailAddressModel.fromJson(Map<String, dynamic> json) {
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
