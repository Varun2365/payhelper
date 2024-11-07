// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class Small extends StatefulWidget {
  double fontSize;
  Small({super.key,required this.fontSize});

  @override
  State<Small> createState() => _SmallState();
}

class _SmallState extends State<Small> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("This is sample text",style: TextStyle(fontSize: widget.fontSize),),),
    );
  }
}