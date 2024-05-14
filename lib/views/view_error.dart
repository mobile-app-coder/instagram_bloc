import 'package:flutter/material.dart';

Widget error_view(String message) {
  return Center(
    child: Text(
      message,
      style: const TextStyle(color: Colors.red, fontSize: 20),
    ),
  );
}
