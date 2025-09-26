import 'package:occusearch/features/contact_us/model/contact_us_model.dart';

class CountryWiseBranchModel {
  List<CountryWiseBranch>? aussizzBranches;

  CountryWiseBranchModel({this.aussizzBranches});

  CountryWiseBranchModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      aussizzBranches = <CountryWiseBranch>[];
      json['data'].forEach((v) {
        aussizzBranches!.add(CountryWiseBranch.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (aussizzBranches != null) {
      data['data'] = aussizzBranches!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CountryWiseBranch {
  String? countryName;
  String? countryCode;

  List<AussizzBranches>? branchDataList;

  CountryWiseBranch(this.countryName, this.countryCode, this.branchDataList);

  CountryWiseBranch.fromJson(Map<String, dynamic> json) {
    countryName = json['countryname'];
    countryCode = json['countryCode'];
    if (json['branchDataList'] != null) {
      branchDataList = <AussizzBranches>[];
      json['branchDataList'].forEach((v) {
        branchDataList!.add(AussizzBranches.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['countryname'] = countryName;
    data['countryCode'] = countryCode;
    if (branchDataList != null) {
      data['branchDataList'] =
          branchDataList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
