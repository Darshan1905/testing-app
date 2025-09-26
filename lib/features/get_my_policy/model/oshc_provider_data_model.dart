class OSHCProviderDataModel {
  bool? flag;
  String? message;
  dynamic data;
  List<OSHCProviderDataModelList>? outData;
  dynamic emailLink;
  dynamic other;
  bool? isPolyPayment;
  bool? isAirWallex;
  dynamic nIB;

  OSHCProviderDataModel(
      {this.flag,
      this.message,
      this.data,
      this.outData,
      this.emailLink,
      this.other,
      this.isPolyPayment,
      this.isAirWallex,
      this.nIB});

  OSHCProviderDataModel.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    message = json['message'];
    data = json['data'];
    if (json['outdata'] != null) {
      outData = <OSHCProviderDataModelList>[];
      json['outdata'].forEach((v) {
        outData!.add(OSHCProviderDataModelList.fromJson(v));
      });
    }
    emailLink = json['emaillink'];
    other = json['other'];
    isPolyPayment = json['ispolypayment'];
    isAirWallex = json['isairwallex'];
    nIB = json['NIB'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['flag'] = flag;
    data['message'] = message;
    data['data'] = this.data;
    if (outData != null) {
      data['outdata'] = outData!.map((v) => v.toJson()).toList();
    }
    data['emaillink'] = emailLink;
    data['other'] = other;
    data['ispolypayment'] = isPolyPayment;
    data['isairwallex'] = isAirWallex;
    data['NIB'] = nIB;
    return data;
  }
}

class OSHCProviderDataModelList {
  String? providerid;
  String? provider;
  String? approvedInsurerForVisa;
  bool? approvedInsurerForVisaFlag;
  String? policyCertificate;
  String? mobileAppSupportAndroid;
  String? mobileAppSupportApple;
  bool? onlineMembershipAccount;
  bool? homeDoctorServices;
  String? support247;
  bool? onCampusSupport;
  bool? doctorOnDemand;
  String? doctorOnDemandTooltipText;
  bool? sonder;
  String? membersExclusiveDiscounts;
  bool? membersExclusiveDiscountsFlag;
  bool? membersExclusiveDiscountsTooltip;
  bool? multilingualOSHCCustomerServiceTeam;
  String? doctorVisits;
  String? pathology;
  String? radiology;
  String? specialistConsultations;
  String? publicHospital;
  String? privateHospital;
  String? privateRoom;
  bool? publicHospitalFlag;
  bool? privateHospitalFlag;
  bool? privateRoomFlag;
  String? publicHospitalAccidentAndEmergency;
  String? contractedPrivateHospitalsAccidentAndEmergency;
  String? nonContractPrivateHospitalsAccidentAndEmergency;
  bool? publicHospitalAccidentAndEmergencyFlag;
  bool? contractedPrivateHospitalsAccidentAndEmergencyFlag;
  bool? nonContractPrivateHospitalsAccidentAndEmergencyFlag;
  bool? nonContractPrivateHospitalsAccidentAndEmergencyTooltip;
  String? nonContractPrivateHospitalsAccidentAndEmergencyTooltipText;
  bool? ambulanceServices;
  String? surgicallyImplantedProstheses;
  bool? mri;
  String? prescriptionMedicines;
  bool? surgicallyImplantedProsthesesFlag;
  String? psychiatricConditions;
  String? pregnancyAndBirthRelatedServices;
  String? otherPreExisitingConditions;
  String? refundPolicy;
  String? bestChoiceFor;
  String? mobileAppToLaunchClaims;
  String? helpline247;
  String? onCampusSupportToolTip;
  String? policyCertificateToolTip;
  String? homeDoctorToolTip;
  String? singleParentCover;
  String? emergencyAssistance;
  String? logo;
  String? link;
  String? providerName;
  String? price;
  String? pdfFilePath;
  bool? isActive;
  double? commissionpercentge;
  String? getqouteurl;

  OSHCProviderDataModelList(
      {this.providerid,
      this.provider,
      this.approvedInsurerForVisa,
      this.approvedInsurerForVisaFlag,
      this.policyCertificate,
      this.mobileAppSupportAndroid,
      this.mobileAppSupportApple,
      this.onlineMembershipAccount,
      this.homeDoctorServices,
      this.support247,
      this.onCampusSupport,
      this.doctorOnDemand,
      this.doctorOnDemandTooltipText,
      this.sonder,
      this.membersExclusiveDiscounts,
      this.membersExclusiveDiscountsFlag,
      this.membersExclusiveDiscountsTooltip,
      this.multilingualOSHCCustomerServiceTeam,
      this.doctorVisits,
      this.pathology,
      this.radiology,
      this.specialistConsultations,
      this.publicHospital,
      this.privateHospital,
      this.privateRoom,
      this.publicHospitalFlag,
      this.privateHospitalFlag,
      this.privateRoomFlag,
      this.publicHospitalAccidentAndEmergency,
      this.contractedPrivateHospitalsAccidentAndEmergency,
      this.nonContractPrivateHospitalsAccidentAndEmergency,
      this.publicHospitalAccidentAndEmergencyFlag,
      this.contractedPrivateHospitalsAccidentAndEmergencyFlag,
      this.nonContractPrivateHospitalsAccidentAndEmergencyFlag,
      this.nonContractPrivateHospitalsAccidentAndEmergencyTooltip,
      this.nonContractPrivateHospitalsAccidentAndEmergencyTooltipText,
      this.ambulanceServices,
      this.surgicallyImplantedProstheses,
      this.mri,
      this.prescriptionMedicines,
      this.surgicallyImplantedProsthesesFlag,
      this.psychiatricConditions,
      this.pregnancyAndBirthRelatedServices,
      this.otherPreExisitingConditions,
      this.refundPolicy,
      this.bestChoiceFor,
      this.mobileAppToLaunchClaims,
      this.helpline247,
      this.onCampusSupportToolTip,
      this.policyCertificateToolTip,
      this.homeDoctorToolTip,
      this.singleParentCover,
      this.emergencyAssistance,
      this.logo,
      this.link,
      this.providerName,
      this.price,
      this.pdfFilePath,
      this.isActive,
      this.commissionpercentge,
      this.getqouteurl});

  OSHCProviderDataModelList.fromJson(Map<String, dynamic> json) {
    providerid = json['providerid'];
    provider = json['provider'];
    approvedInsurerForVisa = json['Approved_Insurer_for_Visa'];
    approvedInsurerForVisaFlag = json['Approved_Insurer_for_Visa_flag'];
    policyCertificate = json['Policy_Certificate'];
    mobileAppSupportAndroid = json['mobile_app_support_android'];
    mobileAppSupportApple = json['mobile_app_support_apple'];
    onlineMembershipAccount = json['online_membership_account'];
    homeDoctorServices = json['home_doctor_services'];
    support247 = json['support_24_7'];
    onCampusSupport = json['on_campus_support'];
    doctorOnDemand = json['doctor_on_demand'];
    doctorOnDemandTooltipText = json['doctor_on_demand_tooltip_text'];
    sonder = json['sonder'];
    membersExclusiveDiscounts = json['members_exclusive_discounts'];
    membersExclusiveDiscountsFlag = json['members_exclusive_discounts_flag'];
    membersExclusiveDiscountsTooltip =
        json['members_exclusive_discounts_tooltip'];
    multilingualOSHCCustomerServiceTeam =
        json['Multilingual_OSHC_Customer_Service_team'];
    doctorVisits = json['doctor_visits'];
    pathology = json['pathology'];
    radiology = json['radiology'];
    specialistConsultations = json['specialist_consultations'];
    publicHospital = json['public_hospital'];
    privateHospital = json['private_hospital'];
    privateRoom = json['private_room'];
    publicHospitalFlag = json['public_hospital_flag'];
    privateHospitalFlag = json['private_hospital_flag'];
    privateRoomFlag = json['private_room_flag'];
    publicHospitalAccidentAndEmergency =
        json['public_hospital_accident_and_emergency'];
    contractedPrivateHospitalsAccidentAndEmergency =
        json['contracted_private_hospitals_accident_and_emergency'];
    nonContractPrivateHospitalsAccidentAndEmergency =
        json['non_contract_private_hospitals_accident_and_emergency'];
    publicHospitalAccidentAndEmergencyFlag =
        json['public_hospital_accident_and_emergency_flag'];
    contractedPrivateHospitalsAccidentAndEmergencyFlag =
        json['contracted_private_hospitals_accident_and_emergency_flag'];
    nonContractPrivateHospitalsAccidentAndEmergencyFlag =
        json['non_contract_private_hospitals_accident_and_emergency_flag'];
    nonContractPrivateHospitalsAccidentAndEmergencyTooltip =
        json['non_contract_private_hospitals_accident_and_emergency_tooltip'];
    nonContractPrivateHospitalsAccidentAndEmergencyTooltipText = json[
        'non_contract_private_hospitals_accident_and_emergency_tooltip_text'];
    ambulanceServices = json['ambulance_services'];
    surgicallyImplantedProstheses = json['surgically_implanted_prostheses'];
    mri = json['mri'];
    prescriptionMedicines = json['prescription_medicines'];
    surgicallyImplantedProsthesesFlag =
        json['surgically_implanted_prostheses_flag'];
    psychiatricConditions = json['psychiatric_conditions'];
    pregnancyAndBirthRelatedServices =
        json['pregnancy_and_birth_related_services'];
    otherPreExisitingConditions = json['other_pre_exisiting_conditions'];
    refundPolicy = json['refund_policy'];
    bestChoiceFor = json['best_choice_for'];
    mobileAppToLaunchClaims = json['mobile_app_to_launch_claims'];
    helpline247 = json['helpline_24_7'];
    onCampusSupportToolTip = json['on_campus_support_tool_tip'];
    policyCertificateToolTip = json['policy_certificate_tool_tip'];
    homeDoctorToolTip = json['home_doctor_tool_tip'];
    singleParentCover = json['single_parent_cover'];
    emergencyAssistance = json['emergency_assistance'];
    logo = json['logo'];
    link = json['link'];
    providerName = json['providerName'];
    price = json['price'];
    pdfFilePath = json['pdfFilePath'];
    isActive = json['isActive'];
    commissionpercentge = json['commissionpercentge'];
    getqouteurl = json['getqouteurl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['providerid'] = providerid;
    data['provider'] = provider;
    data['Approved_Insurer_for_Visa'] = approvedInsurerForVisa;
    data['Approved_Insurer_for_Visa_flag'] = approvedInsurerForVisaFlag;
    data['Policy_Certificate'] = policyCertificate;
    data['mobile_app_support_android'] = mobileAppSupportAndroid;
    data['mobile_app_support_apple'] = mobileAppSupportApple;
    data['online_membership_account'] = onlineMembershipAccount;
    data['home_doctor_services'] = homeDoctorServices;
    data['support_24_7'] = support247;
    data['on_campus_support'] = onCampusSupport;
    data['doctor_on_demand'] = doctorOnDemand;
    data['doctor_on_demand_tooltip_text'] = doctorOnDemandTooltipText;
    data['sonder'] = sonder;
    data['members_exclusive_discounts'] = membersExclusiveDiscounts;
    data['members_exclusive_discounts_flag'] = membersExclusiveDiscountsFlag;
    data['members_exclusive_discounts_tooltip'] =
        membersExclusiveDiscountsTooltip;
    data['Multilingual_OSHC_Customer_Service_team'] =
        multilingualOSHCCustomerServiceTeam;
    data['doctor_visits'] = doctorVisits;
    data['pathology'] = pathology;
    data['radiology'] = radiology;
    data['specialist_consultations'] = specialistConsultations;
    data['public_hospital'] = publicHospital;
    data['private_hospital'] = privateHospital;
    data['private_room'] = privateRoom;
    data['public_hospital_flag'] = publicHospitalFlag;
    data['private_hospital_flag'] = privateHospitalFlag;
    data['private_room_flag'] = privateRoomFlag;
    data['public_hospital_accident_and_emergency'] =
        publicHospitalAccidentAndEmergency;
    data['contracted_private_hospitals_accident_and_emergency'] =
        contractedPrivateHospitalsAccidentAndEmergency;
    data['non_contract_private_hospitals_accident_and_emergency'] =
        nonContractPrivateHospitalsAccidentAndEmergency;
    data['public_hospital_accident_and_emergency_flag'] =
        publicHospitalAccidentAndEmergencyFlag;
    data['contracted_private_hospitals_accident_and_emergency_flag'] =
        contractedPrivateHospitalsAccidentAndEmergencyFlag;
    data['non_contract_private_hospitals_accident_and_emergency_flag'] =
        nonContractPrivateHospitalsAccidentAndEmergencyFlag;
    data['non_contract_private_hospitals_accident_and_emergency_tooltip'] =
        nonContractPrivateHospitalsAccidentAndEmergencyTooltip;
    data['non_contract_private_hospitals_accident_and_emergency_tooltip_text'] =
        nonContractPrivateHospitalsAccidentAndEmergencyTooltipText;
    data['ambulance_services'] = ambulanceServices;
    data['surgically_implanted_prostheses'] = surgicallyImplantedProstheses;
    data['mri'] = mri;
    data['prescription_medicines'] = prescriptionMedicines;
    data['surgically_implanted_prostheses_flag'] =
        surgicallyImplantedProsthesesFlag;
    data['psychiatric_conditions'] = psychiatricConditions;
    data['pregnancy_and_birth_related_services'] =
        pregnancyAndBirthRelatedServices;
    data['other_pre_exisiting_conditions'] = otherPreExisitingConditions;
    data['refund_policy'] = refundPolicy;
    data['best_choice_for'] = bestChoiceFor;
    data['mobile_app_to_launch_claims'] = mobileAppToLaunchClaims;
    data['helpline_24_7'] = helpline247;
    data['on_campus_support_tool_tip'] = onCampusSupportToolTip;
    data['policy_certificate_tool_tip'] = policyCertificateToolTip;
    data['home_doctor_tool_tip'] = homeDoctorToolTip;
    data['single_parent_cover'] = singleParentCover;
    data['emergency_assistance'] = emergencyAssistance;
    data['logo'] = logo;
    data['link'] = link;
    data['providerName'] = providerName;
    data['price'] = price;
    data['pdfFilePath'] = pdfFilePath;
    data['isActive'] = isActive;
    data['commissionpercentge'] = commissionpercentge;
    data['getqouteurl'] = getqouteurl;
    return data;
  }
}
