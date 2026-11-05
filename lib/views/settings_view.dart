import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/models/user_settings.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';
import 'package:southsea_cinema/widgets/primary_button.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() {
    return _SettingsViewState();
  }
}

class _SettingsViewState extends State<SettingsView> {
  late TextEditingController _addressController;
  late TextEditingController _emailController;
  late TextEditingController _patronNumberController;
  bool _receiveNewsletter = false;
  String _confirmationMessage = '';

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController();
    _emailController = TextEditingController();
    _patronNumberController = TextEditingController();
  }

  @override
  void dispose() {
    _addressController.dispose();
    _emailController.dispose();
    _patronNumberController.dispose();
    super.dispose();
  }

  void _saveSettings() {
    final String address = _addressController.text.trim();
    final String email = _emailController.text.trim();
    final int patronNumber =
        int.tryParse(_patronNumberController.text.trim()) ?? 0;

    final UserSettings settings = UserSettings(
      address: address,
      email: email,
      patronNumber: patronNumber,
      receiveNewsletter: _receiveNewsletter,
    );

    setState(() {
      _confirmationMessage = 'Settings saved.';
    });
  }

  void _cancel() {
    setState(() {
      _addressController.clear();
      _emailController.clear();
      _patronNumberController.clear();
      _receiveNewsletter = false;
      _confirmationMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        drawer: const NavDrawer(),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                'My Settings',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                'Address',
                style: TextStyle(fontSize: 16, color: cinemaFontMuted),
              ),
              TextField(
                controller: _addressController,
                maxLines: 3,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: cinemaSurface,
                  border: const OutlineInputBorder(),
                  labelText: 'Delivery address',
                  hintText: 'Enter delivery address',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _addressController.clear();
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Email Address',
                style: TextStyle(fontSize: 16, color: cinemaFontMuted),
              ),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: cinemaSurface,
                  border: const OutlineInputBorder(),
                  labelText: 'Email address',
                  hintText: 'Enter your email',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _emailController.clear();
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Patron Number',
                style: TextStyle(fontSize: 16, color: cinemaFontMuted),
              ),
              TextField(
                controller: _patronNumberController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: cinemaSurface,
                  border: const OutlineInputBorder(),
                  labelText: 'Patron Number',
                  hintText: 'Enter your patron number',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _patronNumberController.clear();
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Preferences',
                style: TextStyle(fontSize: 16, color: cinemaFontMuted),
              ),
              Row(
                children: [
                  const Expanded(
                    child: Text('Receive news by email'),
                  ),
                  Switch(
                    value: _receiveNewsletter,
                    onChanged: (bool value) {
                      setState(() {
                        _receiveNewsletter = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cinemaSurface,
                      foregroundColor: cinemaFontWhite,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    onPressed: _cancel,
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 20),
                  PrimaryButton(
                    label: 'Save Settings',
                    onPressed: _saveSettings,
                  ),
                ],
              ),
              if (_confirmationMessage.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  _confirmationMessage,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ])));
  }
}
