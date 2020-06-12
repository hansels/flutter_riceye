import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riceye/helpers/camera_helper.dart';
import 'package:flutter_riceye/widgets/custom_text.dart';

class InfoScreen extends StatefulWidget {
  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Information",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Column(
              children: <Widget>[
                CustomText("RICEYE", fontSize: 40, fontWeight: FontWeight.w500),
                CustomText(
                  (Platform.isIOS ? "iOS" : "Android") + " v.1.0.0",
                  fontSize: 24,
                ),
                CustomText(
                  "by bangk!t JKT3-E",
                  fontSize: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _willPopCallback() async {
    await CameraHelper.startCamera();
    return true;
  }
}
