import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Platform Channel Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const MethodChannel _channel =
  MethodChannel('platformchannel.companyname.com/deviceinfo');

  String _deviceInfo = '';

  @override
  void initState() {
    super.initState();
    _getDeviceInfo();
  }

  Future<void> _getDeviceInfo() async {
    String info;
    try {
      final result = await _channel.invokeMethod<String>('getDeviceInfo');
      info = result ?? 'No info returned';
    } on PlatformException catch (e) {
      info = "Failed to get device info: '${e.message}'.";
    }
    if (!mounted) return;
    setState(() => _deviceInfo = info);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Platform Channel')),
      body: SafeArea(
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          title: const Text('Device info:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          subtitle: Text(_deviceInfo,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getDeviceInfo,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}