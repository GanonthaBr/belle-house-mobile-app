// Example of how to use connectivity checks in your app

import 'package:flutter/material.dart';
import 'package:mobile_app/services/connectivity_service.dart';
import 'package:mobile_app/utils/connectivity_utils.dart';

class ExampleConnectivityUsage extends StatefulWidget {
  const ExampleConnectivityUsage({super.key});

  @override
  State<ExampleConnectivityUsage> createState() =>
      _ExampleConnectivityUsageState();
}

class _ExampleConnectivityUsageState extends State<ExampleConnectivityUsage> {
  final ConnectivityService _connectivityService = ConnectivityService();
  bool _isConnected = false;
  String _connectionStatus = 'Checking...';

  @override
  void initState() {
    super.initState();
    _checkInitialConnectivity();
    _listenToConnectivityChanges();
  }

  // Check connectivity when the widget loads
  void _checkInitialConnectivity() async {
    final isConnected = await _connectivityService.hasInternetConnection();
    final status = await ConnectivityUtils.getConnectivityStatus();

    setState(() {
      _isConnected = isConnected;
      _connectionStatus = status;
    });
  }

  // Listen to real-time connectivity changes
  void _listenToConnectivityChanges() {
    ConnectivityUtils.watchConnectivityStatus().listen((status) {
      setState(() {
        _connectionStatus = status;
        _isConnected =
            status.contains('Connected') && !status.contains('No Internet');
      });
    });
  }

  // Example of checking connectivity before performing an action
  void _performNetworkAction() async {
    if (await ConnectivityUtils.checkConnectivityWithMessage()) {
      // Proceed with network action
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Performing network action...')),
      );

      // Your API call here - it will automatically check connectivity
      // Example: await apiService.get('some-endpoint');
    } else {
      // Show no internet message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No internet connection. Please check your network.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connectivity Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(
                      _isConnected ? Icons.wifi : Icons.wifi_off,
                      size: 48,
                      color: _isConnected ? Colors.green : Colors.red,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Connection Status: $_connectionStatus',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _isConnected ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _isConnected ? 'Online' : 'Offline',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _performNetworkAction,
              child: const Text('Test Network Action'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Benefits of our connectivity implementation:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              '• All API calls automatically check internet connectivity\n'
              '• User-friendly error messages for connectivity issues\n'
              '• Real-time connectivity status monitoring\n'
              '• Automatic retry mechanisms for network failures\n'
              '• Prevents unnecessary API calls when offline',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
