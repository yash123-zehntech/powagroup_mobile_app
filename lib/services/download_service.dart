import 'dart:io';
import 'package:dio/dio.dart';
import 'package:external_path/external_path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:powagroup/services/api_client.dart';
import 'package:powagroup/util/util.dart';
import 'package:share_plus/share_plus.dart';

abstract class DownloadService {
  Future<void> download({required String url, required bool isShare});
}

class MobileDownloadService implements DownloadService {
  @override
  Future<void> download({required String url, required bool isShare}) async {
    String token = await AppUtil.getLoginToken();

    // requests permission for downloading the file
    bool hasPermission = await _requestWritePermission();
    if (!hasPermission) return;

    String newPath = '';

    Directory? directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    List<String> paths = directory!.path.split('/');
    for (int x = 1; x < paths.length; x++) {
      String folder = paths[x];
      if (folder != 'Android') {
        newPath += '/' + folder;
      } else {
        break;
      }
    }

    String fileName = '${DateTime.now().millisecondsSinceEpoch.toString()}.pdf';

    directory = Directory(newPath);
    // ignore: avoid_slow_async_io
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    // ignore: avoid_slow_async_io
    if (await directory.exists()) {
      //AppUtil.showLoader();
      // if (!isShare) {
      //   AppUtil.showSnackBar('Downloading Please wait...');
      // }

      String DestinationDir = Platform.isAndroid
          ? await ExternalPath.getExternalStoragePublicDirectory(
              ExternalPath.DIRECTORY_DOWNLOADS)
          : directory.path + '/Download';

      Dio dio = Dio();
      Response response = await dio.download(
          ApiClient.BASE_URL + url,

          //"https://www.africau.edu/images/default/sample.pdf",
          "$DestinationDir/$fileName",
          onReceiveProgress: (count, total) {},
          options: Options(headers: {
            'Authorization': 'Bearer $token',
            // 'Content-Type': 'application/x-www-form-urlencoded'
          }));

      if (response.statusCode == 200) {
        if (isShare) {
          XFile file = new XFile("$DestinationDir/$fileName");

          Share.shareXFiles([file]);
        } else {
          AppUtil.showSnackBar('File downloaded to ${DestinationDir}');
        }
      } else {
        AppUtil.showDialogbox(AppUtil.getContext(),
            response.statusMessage ?? 'Oops Something went wrong');
      }
    }
  }

  // requests storage permission
  // Future<bool> _requestWritePermission() async {
  //   await Permission.storage.request();
  //   return await Permission.storage.request().isGranted;
  // }

  // Future<bool> _requestWritePermission() async {
  //   PermissionStatus status = await Permission.storage.request();
  //   return status.isGranted;
  // }
  Future<bool> _requestWritePermission() async {
    PermissionStatus status = await Permission.storage.request();

    if (status.isGranted) {
      return true; // Permission is granted.
    } else {
      return false; // Permission is not granted.
    }
  }
}
