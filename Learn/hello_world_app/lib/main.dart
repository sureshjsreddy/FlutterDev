import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For haptic feedback
import 'package:torch_light/torch_light.dart';

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

      if (_isTorchOn) {
        await TorchLight.disableTorch();
      } else {
        await TorchLight.enableTorch();
      }

      setState(() {
        _isTorchOn = !_isTorchOn;
      });

      // Trigger haptic feedback
      HapticFeedback.mediumImpact();

    } catch (e) {
      _showError('Error toggling torch: $e');
    }
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
                  'assets/vintage_flashlight.png', // Replace with your actual image path
                  width: 250,
                  fit: BoxFit.contain,
                ),
                // Torch icon at center (unchanged)
                Align(
                  alignment: Alignment.center,
                  child: Icon(
                    _isTorchOn ? Icons.flashlight_on : Icons.flashlight_off,
                    size: 40,
                    color: _isTorchOn ? Colors.amberAccent : Colors.grey,
                  ),
                ),
                // Small amberAccent circle at the top, visible only when torch is on
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