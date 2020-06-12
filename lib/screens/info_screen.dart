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
          child: Column(
            children: <Widget>[
              Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10),
                    CustomText("RICEYE",
                        fontSize: 40, fontWeight: FontWeight.w500),
                    CustomText(
                      "vers. " +
                          (Platform.isIOS ? "iOS" : "Android") +
                          " 1.0.0",
                      fontSize: 24,
                    ),
                    CustomText(
                      "by bangk!t JKT3-E",
                      fontSize: 19,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomText(
                  '''Riceye is a Rice Plant Disease Detection Application that used Machine Learning to detect the disease. Riceye can detect 3 types of Rice Plant Disease such as Hispa, Brown Spot and Leaf Blast. The Dataset for this Machine Learning Model training are taken from Rice Diseases Image Dataset which are created by Huy Minh Do. This Application is also a part of Bangkit Final Project.\n\nRiceye are able to detect the disease from two sources:\n1. From the Camera Stream that are previewed in the Screen\n2. From the Gallery Image Picker''',
                  fontSize: 16,
                ),
              ),
            ],
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
