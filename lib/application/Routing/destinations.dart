import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Destinations {
  final String label;
  final Icon icon;
  const Destinations({required this.label, required this.icon});
}

const List<Destinations> destinations = [
  Destinations(
      label: 'Home',
      icon: Icon(
        CupertinoIcons.home,
        color: Colors.white,
      )),
  Destinations(
      label: 'Search', icon: Icon(CupertinoIcons.search, color: Colors.white)),
  Destinations(
      label: 'Library', icon: Icon(CupertinoIcons.book, color: Colors.white)),
  Destinations(
      label: 'Upload',
      icon: Icon(CupertinoIcons.upload_circle, color: Colors.white))
];
