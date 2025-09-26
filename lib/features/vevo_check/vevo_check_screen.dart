// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:occusearch/common_widgets/button_widget.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/common_widgets/will_pop_scope_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/vevo_check/vevo_check_bloc.dart'; // ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';
import 'package:rive/rive.dart';

class VevoCheckScreen extends BaseApp {
  const VevoCheckScreen({super.key}) : super.builder();

  @override
  BaseState createState() => _VevoCheckScreenState();
}

class _VevoCheckScreenState extends BaseState {
  final VevoCheckBloc _vevoCheckBloc = VevoCheckBloc();

  @override
  Widget body(BuildContext context) {
    return RxBlocProvider(
      create: (_) => _vevoCheckBloc,
      child: WillPopScopeWidget(
        onWillPop: () async {
          GoRoutesPage.go(mode: NavigatorMode.pop, moveTo: RouteName.home);
          return false;
        },
        child: Container(
          color: AppColorStyle.background(context),
          child: Stack(
            children: [
              Container(
                alignment: Alignment.topRight,
                child: SvgPicture.asset(
                  IconsSVG.bgVevoCheck,
                  colorFilter: ColorFilter.mode(
                    AppColorStyle.red(context),
                    BlendMode.srcIn,
                  ),
                  width: MediaQuery.of(context).size.width / 4.5,
                ),
              ),
              Align(
                alignment: AlignmentDirectional.bottomCenter,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 100,
                        width: 100,
                        child: RiveAnimation.asset(
                          RiveAssets.vevoCheck,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Check your",
                                style: AppTextStyle.headlineBold(
                                  context,
                                  AppColorStyle.text(context),
                                )),
                            const SizedBox(height: 3),
                            Text("Visa Status",
                                style: AppTextStyle.headlineBold(
                                  context,
                                  AppColorStyle.red(context),
                                )),
                            const SizedBox(
                              height: 15,
                            ),
                            const SizedBox(height: 15),
                            Text("Check your work rights",
                                style: AppTextStyle.subTitleRegular(
                                  context,
                                  AppColorStyle.red(context),
                                )),
                            const SizedBox(
                              height: 50.0,
                            ),
                            //Scan passport button
                            ButtonWidget(
                              title: StringHelper.scanDocument,
                              buttonColor: AppColorStyle.red(context),
                              onTap: () async {
                                openGalleryAndCameraOption(true);
                                /*PermissionStatus cameraStatus =
                                    await Permission.camera.request();
                                if (cameraStatus.isGranted) {
                                  final picker = ImagePicker();
                                  final file = await picker.pickImage(
                                      source: ImageSource.camera,
                                      imageQuality: 100);
                                  final imgPath = file?.path;
                                  if (imgPath == null) return;
                                  vevoPassPortAPI(StringHelper.vrnDOC, imgPath);
                                }*/
                              },
                              logActionEvent: "",
                              prefixIcon: SvgPicture.asset(
                                IconsSVG.icScan,
                                colorFilter: ColorFilter.mode(
                                  AppColorStyle.textWhite(context),
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            //Scan Visa Grant button
                            ButtonWidget(
                              title: StringHelper.uploadDocument,
                              buttonColor: AppColorStyle.red(context),
                              onTap: () {
                                if (NetworkController.isInternetConnected ==
                                    false) {
                                  Toast.show(
                                      message: StringHelper.internetConnection,
                                      context,
                                      duration: 3,
                                      type: Toast.toastError,
                                      gravity: Toast.toastTop);
                                  return;
                                }
                                openGalleryAndCameraOption(false);
                              },
                              logActionEvent:
                                  FBActionEvent.fbActionVevoCheckPassport,
                              prefixIcon: SvgPicture.asset(
                                IconsSVG.icUpload,
                                colorFilter: ColorFilter.mode(
                                  AppColorStyle.textWhite(context),
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Please upload document in ",
                                      style: AppTextStyle.captionRegular(
                                        context,
                                        AppColorStyle.textDetail(context),
                                      ),
                                    ),
                                    TextSpan(
                                      text: "PDF",
                                      style: AppTextStyle.captionSemiBold(
                                        context,
                                        AppColorStyle.textDetail(context),
                                      ),
                                    ),
                                    TextSpan(
                                      text: " and ",
                                      style: AppTextStyle.captionRegular(
                                        context,
                                        AppColorStyle.textDetail(context),
                                      ),
                                    ),
                                    TextSpan(
                                      text: "jpeg ",
                                      style: AppTextStyle.captionSemiBold(
                                        context,
                                        AppColorStyle.textDetail(context),
                                      ),
                                    ),
                                    TextSpan(
                                      text: "format only with less than ",
                                      style: AppTextStyle.captionRegular(
                                        context,
                                        AppColorStyle.textDetail(context),
                                      ),
                                    ),
                                    TextSpan(
                                      text: "7MB ",
                                      style: AppTextStyle.captionSemiBold(
                                        context,
                                        AppColorStyle.textDetail(context),
                                      ),
                                    ),
                                    TextSpan(
                                      text: "in size.",
                                      style: AppTextStyle.captionRegular(
                                        context,
                                        AppColorStyle.textDetail(context),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30.0,
                            ),
                            ButtonWidget(
                              title: StringHelper.setUpManually,
                              onTap: () {
                                GoRoutesPage.go(
                                    mode: NavigatorMode.push,
                                    moveTo: RouteName.vevoCheckForm);
                              },
                              logActionEvent: FBActionEvent.fbActionVevoCheck,
                              buttonColor: AppColorStyle.redText(context),
                              textColor: AppColorStyle.red(context),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            InkWellWidget(
                              onTap: () {
                                context.pop();
                              },
                              child: Center(
                                child: Text(
                                  StringHelper.willDoIt,
                                  style: AppTextStyle.subTitleMedium(
                                      context, AppColorStyle.textHint(context)),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  openGalleryAndCameraOption(bool isCamera) {
    showModalBottomSheet(
      context: context,
      builder: (appContext) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isCamera ? StringHelper.scanDocument : StringHelper.uploadDocument,
                      style: AppTextStyle.subHeadlineSemiBold(
                        context,
                        AppColorStyle.text(context),
                      ),
                    ),
                    InkWellWidget(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: SvgPicture.asset(
                          IconsSVG.cross,
                          height: 20,
                          width: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 0.5,
                color: AppColorStyle.backgroundVariant(context),
              ),
              const SizedBox(
                height: 5.0,
              ),
              //PASSPORT
              InkWellWidget(
                onTap: () => onTapDocUpload(isCamera, StringHelper.passport),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 10.0),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        IconsSVG.icVevoScanPassport,
                        height: 24,
                        width: 24,
                        colorFilter: ColorFilter.mode(
                          AppColorStyle.red(context),
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(
                        width: 20.0,
                      ),
                      Text(
                        StringHelper.uploadPassport,
                        style: AppTextStyle.subTitleMedium(
                          context,
                          AppColorStyle.text(context),
                        ),
                      ),
                      const Spacer(),
                      SvgPicture.asset(
                        IconsSVG.arrowHalfRight,
                        colorFilter: ColorFilter.mode(
                          AppColorStyle.text(context),
                          BlendMode.srcIn,
                        ),
                        height: 24,
                        width: 24,
                      ),
                    ],
                  ),
                ),
              ),
              //VISA GRANT
              InkWellWidget(
                onTap: () => onTapDocUpload(isCamera, StringHelper.vrnDOC),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 10.0),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        IconsSVG.icVevoScanGrantLetter,
                        height: 24,
                        width: 24,
                        colorFilter: ColorFilter.mode(
                          AppColorStyle.red(context),
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(
                        width: 20.0,
                      ),
                      Text(
                        StringHelper.uploadVisaGrant,
                        style: AppTextStyle.subTitleMedium(
                          context,
                          AppColorStyle.text(context),
                        ),
                      ),
                      const Spacer(),
                      SvgPicture.asset(
                        IconsSVG.arrowHalfRight,
                        colorFilter: ColorFilter.mode(
                          AppColorStyle.text(context),
                          BlendMode.srcIn,
                        ),
                        height: 24,
                        width: 24,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
            ],
          ),
        );
      },
    );
  }

  onTapDocUpload(bool isCamera, String docType) async {
    Navigator.pop(context);
    if (isCamera) {
      // [CAMERA OPTION]
      PermissionStatus cameraStatus = await Permission.camera.request();
      if (cameraStatus.isGranted) {
        final picker = ImagePicker();
        final file = await picker.pickImage(
            source: ImageSource.camera, imageQuality: 100);
        final imgPath = file?.path;
        if (imgPath == null) return;
        vevoPassPortAPI(docType, imgPath);
      }
    } else {
      // [GALLERY OPTION]
      Permission permissionType = await Utility.getStoragePermissionType();
      if (await permissionType.status.isGranted) {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.custom, allowedExtensions: ['jpg', 'pdf']);
        if (result != null) {
          if (result.files.single.path != null) {
            if (result.files.single.extension == null ||
                (result.files.single.extension?.toLowerCase() != "pdf" &&
                    result.files.single.extension?.toLowerCase() != "jpg" &&
                    result.files.single.extension?.toLowerCase() != "jpeg")) {
              Toast.show(
                  message: StringHelper.pleaseChooseFile,
                  context,
                  duration: 3,
                  gravity: Toast.toastTop);
              return;
            }
            vevoPassPortAPI(docType, result.files.single.path!);
          }
        } else {
          // User canceled the picker
        }
      } else {
        PermissionStatus status =
            await requestPermission(permissionType, isCamera);
        if (status.isGranted) {
          FilePickerResult? result = await FilePicker.platform.pickFiles(
              type: FileType.custom, allowedExtensions: ['jpg', 'pdf']);
          if (result != null) {
            if (result.files.single.path != null) {
              if (result.files.single.extension == null ||
                  (result.files.single.extension?.toLowerCase() != "pdf" &&
                      result.files.single.extension?.toLowerCase() != "jpg" &&
                      result.files.single.extension?.toLowerCase() != "jpeg")) {
                Toast.show(
                    message: StringHelper.pleaseChooseFile,
                    context,
                    duration: 3,
                    gravity: Toast.toastTop);
                return;
              }
              vevoPassPortAPI(docType, result.files.single.path!);
            }
          } else {
            // User canceled the picker
          }
        }
      }
    }
  }

  Future<PermissionStatus> requestPermission(
      Permission permissionType, bool isCamera) async {
    var status = await permissionType.request();
    if (status.isDenied) {
      status = await permissionType.request();
    } else if (status.isPermanentlyDenied || status.isRestricted) {
      Toast.show(
          message: permissionType == Permission.camera
              ? "Please grant camera permission."
              : "Please grant file and media permission.",
          context,
          gravity: Toast.toastTop,
          duration: 2);
      await openAppSettings();
    } else if (status.isGranted) {
      openGalleryAndCameraOption(isCamera);
    }
    return status;
  }

  // API Check whether OCR for Passport or VRN Doc
  vevoPassPortAPI(String docType, String filePath) async {
    File file = File(filePath);
    final bytes = File(file.path).readAsBytesSync();
    String img64 = base64Encode(bytes);
    final extension = p.extension(file.path).replaceAll(".", "");

    if (Utility.getFileSize(file) <= 7.0) {
      if (docType == StringHelper.passport) {
        _vevoCheckBloc.fetchOCRPassportAPI(context, img64, extension);
      } else {
        _vevoCheckBloc.fetchOCRVrnAPI(context, img64, extension);
      }
    } else {
      Toast.show(
          message: StringHelper.fileSizeTooBig,
          context,
          duration: 3,
          gravity: Toast.toastTop);
    }
  }

  @override
  init() {}

  @override
  onResume() {}
}
