
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import './app.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized(); 
  await dotenv.load(fileName: ".env");
  runApp(
  ProviderScope(
    observers: [
      // TalkerRiverpodObserver(),
    ],
    child: App(),
  )
 );
}
