import 'package:flutter/material.dart';
import 'package:flutter_riceye/configs/enum.dart';
import 'package:flutter_riceye/widgets/infographics.dart';

class ResultScreen extends StatefulWidget {
  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      bottomSheet: BottomSheet(
        enableDrag: true,
        onClosing: () {},
        builder: (context) => Infographics(PlantDisease.Healthy),
      ),
    );
  }
}
