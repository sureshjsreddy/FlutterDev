import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:torch_light/torch_light.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const TorchApp());
}

class TorchApp extends StatelessWidget {
  const TorchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Retro Torch',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Colors.tealAccent,
          secondary: Colors.amberAccent,
        ),
      ),
      home: const TorchHomePage(),
    );
  }
}

class TorchHomePage extends StatefulWidget {
  const TorchHomePage({super.key});

  @override
  State<TorchHomePage> createState() => _TorchHomePageState();
}

class _TorchHomePageState extends State<TorchHomePage> {
  bool _isTorchOn = false;

  Future<void> _toggleTorch() async {
    try {
      final isAvailable = await TorchLight.isTorchAvailable();
      if (!isAvailable) {
        _showError('Torch not available on this device.');
        return;
      }

      // Try toggling torch without requesting permission
      try {
        await _switchTorch();
      } catch (e) {
        final errorMessage = e.toString().toLowerCase();
        if (errorMessage.contains('permission') || errorMessage.contains('camera')) {
          final result = await Permission.camera.request();
          if (!result.isGranted) {
            _showError(
              'Camera permission is required to use the torch.\nPlease enable it in settings.',
            );
            return;
          }
          // Retry after permission granted
          await _switchTorch();
        } else {
          _showError('Torch error: $e');
        }
      }

      HapticFeedback.mediumImpact();
    } catch (e) {
      _showError('Unexpected error: $e');
    }
  }

  Future<void> _switchTorch() async {
    if (_isTorchOn) {
      await TorchLight.disableTorch();
    } else {
      await TorchLight.enableTorch();
    }
    setState(() {
      _isTorchOn = !_isTorchOn;
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Retro Torch'),
        backgroundColor: Colors.grey[900],
      ),
      body: Center(
        child: GestureDetector(
          onTap: _toggleTorch,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: _isTorchOn
                  ? [
                BoxShadow(
                  color: Colors.amberAccent.withAlpha((0.6 * 255).toInt()),
                  blurRadius: 40,
                  spreadRadius: 20,
                ),
              ]
                  : [],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/vintage_flashlight.png',
                  width: 250,
                  fit: BoxFit.contain,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Icon(
                    _isTorchOn ? Icons.flashlight_on : Icons.flashlight_off,
                    size: 40,
                    color: _isTorchOn ? Colors.amberAccent : Colors.grey,
                  ),
                ),
                if (_isTorchOn)
                  Align(
                    alignment: Alignment.center,
                    child: Transform.translate(
                      offset: const Offset(0, -114),
                      child: Container(
                        width: 15,
                        height: 15,
                        decoration: const BoxDecoration(
                          color: Colors.amberAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}