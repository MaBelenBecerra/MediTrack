import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MediTrackApp());
}

class MediTrackApp extends StatelessWidget {
  const MediTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MediTrack',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            useMaterial3: true,
          ),
          home: child,
        );
      },
      child: const Scaffold(
        body: Center(
          child: Text('MediTrack - Base Lista!'),
        ),
      ),
    );
  }
}