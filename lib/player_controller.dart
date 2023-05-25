import 'dart:io';

import 'package:cache_video/feed_item.dart';
import 'package:cache_video/progress.dart';
import 'package:dio/dio.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';





bool ShareB=false;
class PlayerController extends StatefulWidget {
  const PlayerController({Key? key}) : super(key: key);

  @override
  State<PlayerController> createState() => _PlayerControllerState();
}

class _PlayerControllerState extends State<PlayerController> {
  //properties




  //to check which index is currently played
  int currentIndex = 0;
  // String dr_path = "";
  // bool downloading = false;
  // double? progressstring ;

  //static content
  final List<String> urls = const [
    'https://drawing-how-to-draw.com/Inhouse/devotional_status/uploads/video/64508e9f261ba1.73303368.mp4',
    'https://drawing-how-to-draw.com/Inhouse/devotional_status/uploads/video/64508f8ea532c3.95517672.mp4',
    'https://drawing-how-to-draw.com/Inhouse/devotional_status/uploads/video/644232aa35fd85.77579842.mp4',
  ];

  // @override
  // void initState() {
  //   super.initState();
  //
  // } //===============Download process================




  //create folder............

  //Downloading.......

  //===============================================





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Video Stream"),

      actions: [
        IconButton(onPressed: (){

          String videoUrl = urls[currentIndex].toString();
          print(videoUrl); // Replace with your video URL
          Navigator.push(context,MaterialPageRoute(builder: (context) {
            return ValueNotifierExample(index: currentIndex,url: videoUrl);

          },));

        }, icon:Icon(Icons.download_for_offline_outlined)),
        IconButton(onPressed: () {



          setState(() {
            ShareB=true;
            String videoUrl = urls[currentIndex].toString();
            print(videoUrl); // Replace with your video URL
            Navigator.push(context,MaterialPageRoute(builder: (context) {
              return ValueNotifierExample(index: currentIndex,url: videoUrl);

            },));
          });

        }, icon:Icon(Icons.share)),

        ],
      ),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: urls.length,
          onPageChanged: (index) {
            setState(() {
              currentIndex = index;
              print(currentIndex);
            });
          },
          itemBuilder: (ctx, index) {
            return FeedItem(url: urls[index]);
          },
        ),
      ),
    );
  }






}


