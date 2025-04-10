import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart'; // ✅ استيراد مكتبة تهيئة التاريخ
import 'screens/splash_screen.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ✅ تهيئة Flutter قبل تشغيل التطبيق
  await initializeDateFormatting('fr_FR', null); // ✅ تهيئة بيانات التاريخ باللغة الفرنسية
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrap the DoctorHomeScreen with a Stack that also includes the hidden preloader
    return MaterialApp(
      title: 'VetOnCall',
      theme: ThemeData(
        fontFamily: 'Roboto', // ✅ جعل Roboto الخط الافتراضي لكل النصوص
        primaryColor: const Color(0xFF4CAF50),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4CAF50)),
      ),
      debugShowCheckedModeBanner: false,
      home: Stack(
        children: const [
          SplashScreen(),
          AIScreenPreloader(),
        ],
      ),
    );
  }
}

// New widget to preload the AI website in background on app launch.
class AIScreenPreloader extends StatefulWidget {
  const AIScreenPreloader({super.key});

  @override
  _AIScreenPreloaderState createState() => _AIScreenPreloaderState();
}

class _AIScreenPreloaderState extends State<AIScreenPreloader> {
  @override
  Widget build(BuildContext context) {
    return Offstage(
      // Offstage makes this widget not visible in the layout
      offstage: true,
      child: SizedBox(
        width: 0,
        height: 0,
        child: InAppWebView(
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
              cacheEnabled: true,
              mediaPlaybackRequiresUserGesture: false,
            ),
            android: AndroidInAppWebViewOptions(
              useHybridComposition: true,
            ),
          ),
          initialUrlRequest: URLRequest(
            url: WebUri('vet-on-call-ai.on.websim.ai'),
          ),
          onWebViewCreated: (_) {
            // No need to store the controller, so we ignore it.
          },
          onLoadStop: (controller, url) {
            // Optionally, you can call functions like hiding the logo here if needed.
          },
          onLoadError: (controller, url, code, message) {},
          onReceivedError: (controller, request, error) {},
        ),
      ),
    );
  }
}
