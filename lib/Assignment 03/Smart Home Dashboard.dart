import 'package:flutter/material.dart';

void main() {
  runApp(const SmartHomeApp());
}

class SmartHomeApp extends StatelessWidget {
  const SmartHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Home Dashboard',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[50],

        appBarTheme: const AppBarTheme(
          elevation: 2,
          centerTitle: true,
        ),

        cardTheme: CardThemeData(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14)),
          ),
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}

enum DeviceType { Light, Fan, AC, Camera }

class Device {
  String name;
  DeviceType type;
  String room;
  bool isOn;
  double value;

  Device({
    required this.name,
    required this.type,
    required this.room,
    this.isOn = false,
    double? value,
  }) : value = value ?? (type == DeviceType.Light ? 0.8 : 0.5);
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<Device> devices = [
    Device(name: 'Living Room Light', type: DeviceType.Light, room: 'Living', isOn: true, value: 0.9),
    Device(name: 'Bedroom Fan', type: DeviceType.Fan, room: 'Bedroom', isOn: false, value: 0.4),
    Device(name: 'Kitchen AC', type: DeviceType.AC, room: 'Kitchen', isOn: false, value: 22),
    Device(name: 'Front Camera', type: DeviceType.Camera, room: 'Outside', isOn: true),
  ];

  int? pressedIndex;

  IconData _iconFor(DeviceType t) {
    switch (t) {
      case DeviceType.Light:
        return Icons.lightbulb;
      case DeviceType.Fan:
        return Icons.toys;
      case DeviceType.AC:
        return Icons.ac_unit;
      case DeviceType.Camera:
        return Icons.videocam;
    }
  }

  void _openAddDeviceDialog() {
    String name = '';
    String room = '';
    DeviceType type = DeviceType.Light;
    bool status = false;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx2, setStateDialog) {
          return AlertDialog(
            title: const Text('Add New Device'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: 'Device Name'),
                    onChanged: (v) => name = v,
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<DeviceType>(
                    value: type,
                    items: DeviceType.values
                        .map((d) => DropdownMenuItem(
                      value: d,
                      child: Text(d.name),
                    ))
                        .toList(),
                    onChanged: (v) => setStateDialog(() => type = v!),
                    decoration: const InputDecoration(labelText: 'Device Type'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Room Name'),
                    onChanged: (v) => room = v,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('Status'),
                      const SizedBox(width: 16),
                      Switch(
                        value: status,
                        onChanged: (v) => setStateDialog(() => status = v),
                      )
                    ],
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (name.isEmpty || room.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill all fields')));
                    return;
                  }

                  setState(() {
                    devices.add(Device(
                      name: name,
                      type: type,
                      room: room,
                      isOn: status,
                    ));
                  });
                  Navigator.of(ctx).pop();
                },
                child: const Text('Add'),
              ),
            ],
          );
        });
      },
    );
  }

  void _openDetails(Device d) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DeviceDetailsScreen(
          device: d,
          onChanged: () => setState(() {}),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size.width;
    final crossAxisCount = mq > 600 ? 3 : 2;

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.indigo),
              child: Text(
                'Smart Home Menu',
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () {
                Navigator.pop(context); // Drawer close
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About App'),
              onTap: () {},
            ),
          ],
        ),
      ),

      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // 🔥 Drawer open
              },
            );
          },
        ),
        title: const Text('Smart Home Dashboard'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: CircleAvatar(child: Text("BA")), // Profile Avatar
          )
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: devices.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 1.1,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (ctx, i) {
            final d = devices[i];
            return GestureDetector(
              onTap: () => _openDetails(d),
              child: AnimatedScale(
                scale: pressedIndex == i ? 0.95 : 1.0,
                duration: const Duration(milliseconds: 120),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(_iconFor(d.type), size: 30),
                            const Spacer(),
                            Switch(
                              value: d.isOn,
                              onChanged: (v) => setState(() => d.isOn = v),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(d.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        Text("${d.room} • ${d.type.name}",
                            style: TextStyle(color: Colors.grey[700])),
                        const Spacer(),
                        Text(d.isOn ? "Status: ON" : "Status: OFF",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color:
                                d.isOn ? Colors.green[700] : Colors.red)),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: _openAddDeviceDialog,
      ),
    );
  }
}

class DeviceDetailsScreen extends StatefulWidget {
  final Device device;
  final VoidCallback onChanged;

  const DeviceDetailsScreen(
      {super.key, required this.device, required this.onChanged});

  @override
  State<DeviceDetailsScreen> createState() => _DeviceDetailsScreenState();
}

class _DeviceDetailsScreenState extends State<DeviceDetailsScreen> {
  IconData _iconFor(DeviceType t) {
    switch (t) {
      case DeviceType.Light:
        return Icons.lightbulb;
      case DeviceType.Fan:
        return Icons.wind_power;
      case DeviceType.AC:
        return Icons.ac_unit;
      case DeviceType.Camera:
        return Icons.videocam;
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.device;

    return Scaffold(
      appBar: AppBar(
        title: Text(d.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            Icon(_iconFor(d.type), size: 120, color: Colors.indigo),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text("Power", style: TextStyle(fontSize: 18)),
                const Spacer(),
                Switch(
                  value: d.isOn,
                  onChanged: (v) {
                    setState(() => d.isOn = v);
                    widget.onChanged();
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (d.type == DeviceType.Light || d.type == DeviceType.Fan)
              Slider(
                value: d.value,
                min: 0,
                max: 1,
                divisions: 10,
                label: "${(d.value * 100).round()}%",
                onChanged: d.isOn
                    ? (v) {
                  setState(() => d.value = v);
                  widget.onChanged();
                }
                    : null,
              ),
            if (d.type == DeviceType.AC)
              Slider(
                value: d.value,
                min: 16,
                max: 30,
                divisions: 14,
                label: "${d.value.round()}°C",
                onChanged: d.isOn
                    ? (v) {
                  setState(() => d.value = v);
                  widget.onChanged();
                }
                    : null,
              ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                widget.onChanged();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.save),
              label: const Text("Save & Back"),
            )
          ],
        ),
      ),
    );
  }
}
