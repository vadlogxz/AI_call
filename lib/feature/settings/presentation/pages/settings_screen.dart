import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _autoSend = true;
  bool _hapticFeedback = true;
  bool _saveHistory = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020817),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const Text(
                'Settings',
                style: TextStyle(
                  color: Color(0xFFF8FAFC),
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 32),

              _SectionLabel('Audio'),
              const SizedBox(height: 10),
              _SettingsGroup(
                children: [
                  ShadSwitch(
                    value: _autoSend,
                    onChanged: (v) => setState(() => _autoSend = v),
                    label: const Text('Auto-send on silence'),
                    sublabel: const Text('Send to STT when speech ends'),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                  const Divider(color: Color(0xFF1E293B), height: 1),
                  ShadSwitch(
                    value: _hapticFeedback,
                    onChanged: (v) => setState(() => _hapticFeedback = v),
                    label: const Text('Haptic feedback'),
                    sublabel: const Text('Vibrate on speech detection'),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              _SectionLabel('Privacy'),
              const SizedBox(height: 10),
              _SettingsGroup(
                children: [
                  ShadSwitch(
                    value: _saveHistory,
                    onChanged: (v) => setState(() => _saveHistory = v),
                    label: const Text('Save session history'),
                    sublabel: const Text('Store transcriptions locally'),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              _SectionLabel('About'),
              const SizedBox(height: 10),
              _SettingsGroup(
                children: [
                  _InfoRow('Version', '1.0.0'),
                  const Divider(color: Color(0xFF1E293B), height: 1),
                  _InfoRow('VAD Model', 'Silero v5'),
                  const Divider(color: Color(0xFF1E293B), height: 1),
                  _InfoRow('Sample Rate', '16 000 Hz'),
                  const Divider(color: Color(0xFF1E293B), height: 1),
                  _InfoRow('Encoder', 'PCM 16-bit'),
                ],
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        color: Color(0xFF475569),
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(color: Color(0xFFF8FAFC), fontSize: 14),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
          ),
        ],
      ),
    );
  }
}
