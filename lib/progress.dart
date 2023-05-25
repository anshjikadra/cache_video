import 'dart:io';

import 'package:cache_video/player_controller.dart';
import 'package:cross_file/cross_file.dart';
import 'package:dio/dio.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

class ValueNotifierExample extends StatefulWidget {
  String url;
  int index;

  ValueNotifierExample({required this.url, required this.index});

  @override
  State<ValueNotifierExample> createState() => _ValueNotifierExampleState();
}

class _ValueNotifierExampleState extends State<ValueNotifierExample> {
  final centerTextStyle = const TextStyle(
    fontSize: 35,
    color: Colors.lightBlue,
    fontWeight: FontWeight.bold,
  );

  String dr_path = "";
  bool downloading = false;
  double? progressstring;

  final List<String> urls = const [
    'https://drawing-how-to-draw.com/Inhouse/devotional_status/uploads/video/64508e9f261ba1.73303368.mp4',
    'https://drawing-how-to-draw.com/Inhouse/devotional_status/uploads/video/64508f8ea532c3.95517672.mp4',
    'https://drawing-how-to-draw.com/Inhouse/devotional_status/uploads/video/644232aa35fd85.77579842.mp4',
  ];

  String Pathname = '';

  @override
  void initState() {
    super.initState();
    valueNotifier = ValueNotifier(0.0);
    // folder();
    _saveNetworkVideo(widget.url);
  }

  //  folder() async {
  //    var path = await ExternalPath.getExternalStoragePublicDirectory(
  //        ExternalPath.DIRECTORY_DOWNLOADS);
  //    // Directory dr = Directory(path);
  //    print("+++++++${path}===========");
  //
  //    if (await Directory(path).exists()) {
  //      print("Already create");
  //    } else {
  //      //jo file create ny hoy to thashe
  //      await Directory(path).create();
  //    }
  //    dr_path = path;
  //    downloadFile(widget.url);
  //  }
  //
  // downloadFile(String videoUrl) async {
  //
  //    Dio dio = Dio();
  //    GallerySaver.saveVideo(urls[widget.index].split("/").last).then((success) async {});
  //
  //    try {
  //      var dir = await getApplicationDocumentsDirectory();
  //      print(widget.url);
  //
  //      await dio.download(videoUrl, "${dir.path}/${urls[widget.index].split("/").last}",
  //          onReceiveProgress: (rec, total) {
  //            print("Rec: $rec , Total: $total");
  //
  //            setState(() {
  //              downloading = true;
  //              progressstring = (rec / total) * 100;
  //              valueNotifier.value = double.parse(progressstring.toString());
  //              print("${valueNotifier.value}");
  //              if(valueNotifier.value==100)
  //                {
  //                  Future.delayed(Duration(seconds: 1)).then((value) => Navigator.pop(context));
  //                }
  //              if(ShareB==true && valueNotifier.value==100)
  //                {
  //                  Future.delayed(Duration(seconds: 2)).then((value) => Share.shareXFiles([XFile('${dir.path}/${dr_path}/${urls[widget.index].split("/").last}')]));
  //                  ShareB=false;
  //                  //
  //                }
  //
  //
  //
  //            });
  //          });
  //      print("+++++++++++---------+++++++++++${dir.path}+++++++++++--=-=---=-+++++++++++++++++++++");
  //    } catch (e) {
  //      print("++++++++++++++++++++++++${dr_path}++++++++++++++++++++++++++++++++++");
  //      print(e);
  //    }
  //
  //    setState(() {
  //      downloading = false;
  //      progressstring=null;
  //
  //    });
  //
  //    print("Download completed");
  //
  //  }

  late ValueNotifier<double> valueNotifier;

  void _saveNetworkVideo(String videoUrl) async {
    String path = videoUrl;
    Dio dio = Dio();
    GallerySaver.saveVideo(path).then((success) async {});
    try {
      var dir = await getApplicationDocumentsDirectory();
      await dio.download(
          videoUrl, "${dir.path}/${urls[widget.index].split("/").last}",
          onReceiveProgress: (rec, total) async {
        print("Rec: $rec , Total: $total");
        print("path : ${dir.path}/${urls[widget.index].split("/").last}");

        setState(() {
          downloading = true;
          progressstring = (rec / total) * 100;
          valueNotifier.value = double.parse(progressstring.toString());
          print("${valueNotifier.value}");
          if (valueNotifier.value == 100) {
            Future.delayed(Duration(seconds: 1))
                .then((value) => Navigator.pop(context));
          }
          if (ShareB == true && valueNotifier.value == 100) {
            Future.delayed(Duration(seconds: 2)).then((value) =>
                Share.shareXFiles([
                  XFile(
                      '${dir.path}/${dr_path}/${urls[widget.index].split("/").last}')
                ]));
            ShareB=false;

          }
        });
      });

      Pathname = "${dir.path}/${urls[widget.index].split("/").last}";
      print(Pathname);

      setState(() {
        downloading = false;
        // _chewieController?.play();
      });
    } catch (e) {
      print(e);
    }
    print("Download completed");

    // _chewieController?.pause();
    // progressString == "100%"?_showInterstitialAd():null ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xff0d324d),
              Color(0xff7f5a83),
            ],
          )),
          alignment: Alignment.center,
          child: Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              SimpleCircularProgressBar(
                size: 200,
                valueNotifier: valueNotifier,
                progressStrokeWidth: 10,
                backStrokeWidth: 10,
                mergeMode: true,
                onGetText: (value) {
                  return Text(
                    '${value.toInt()}%',
                    style: centerTextStyle,
                  );
                },
                progressColors: const [Colors.cyan, Colors.purple],
                backColor: Colors.black.withOpacity(0.4),
              ),
              SizedBox(
                height: 30,
              ),
              valueNotifier.value != 100 || valueNotifier.value == 0.0
                  ? Text(
                      "Downloading...",
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    )
                  : Text(
                      "Download Succesfully!",
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
            ],
          )),
    );
  }

  @override
  void dispose() {
    valueNotifier.dispose();
    super.dispose();
  }
}
