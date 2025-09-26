// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:occusearch/data_provider/firebase/remote_config/firebase_remote_config.dart';
import 'package:occusearch/data_provider/firebase/remote_config/firebase_remote_config_constants.dart';
import 'package:occusearch/features/country/model/country_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rx_bloc/rx_bloc.dart';

@RxBloc()
class CountryBloc extends RxBlocTypeBase {
  TextEditingController? _countrySearchController;

  // Variable
  final _countryModelStream = BehaviorSubject<List<CountryModel>>();

  // Set
  set setSearchFieldController(controller) =>
      _countrySearchController = controller;

  set setCountryList(List<CountryModel> list) =>
      _countryModelStream.sink.add(list);

  // Get
  Stream<List<CountryModel>> get getCountryListStream => _countryModelStream
      // .debounceTime(const Duration(milliseconds: 100))
      .transform(streamTransformer);

  BehaviorSubject<List<CountryModel>> get getCountryList => _countryModelStream;

  // Search
  onSearch(query) {
    getCountryList.add(getCountryList.value);
  }

  // Firebase Remote Config: to get Country details
  setupRemoteConfigForCountryList() async {
    List<CountryModel> countryDataList = [];

    //read data from firebase
    String firebaseCountryData = await FirebaseRemoteConfigController.shared
        .Data(key: FirebaseRemoteConfigConstants.keyCountry);

    var jsonData = json.decode(firebaseCountryData);
    //converted model into dynamic list
    countryDataList = (jsonData as List)
        .map<CountryModel>((json) => CountryModel.fromJson(json))
        .toList();
    _countryModelStream.sink.add(countryDataList);
  }

  // Find the matching data on Search Text
  // Replace StreamTransformer to ScanStreamTransformer
  StreamTransformer<
      List<CountryModel>,
      List<
          CountryModel>> get streamTransformer =>
      StreamTransformer<List<CountryModel>, List<CountryModel>>.fromHandlers(
        handleData: (list, sink) {
          if ((_countrySearchController!.text).isNotEmpty) {
            List<CountryModel> newList = list.where(
              (item) {
                return item.name!.toLowerCase().contains(
                        _countrySearchController!.text.toLowerCase()) ||
                    item.dialCode!
                        .toLowerCase()
                        .contains(_countrySearchController!.text.toLowerCase());
              },
            ).toList();
            return sink.add(newList);
          } else {
            return sink.add(list);
          }
        },
      );

  @override
  void dispose() {
    _countryModelStream.close();
    _countrySearchController?.dispose();
  }
}
