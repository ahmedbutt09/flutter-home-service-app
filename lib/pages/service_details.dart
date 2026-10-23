import 'package:flutter/material.dart';

import '../models/service.dart';
import 'date_time.dart';

class ServiceDetailsPage extends StatefulWidget {
  const ServiceDetailsPage({super.key, required this.service});
  final Service service;

  @override
  State<ServiceDetailsPage> createState() => _ServiceDetailsPageState();
}

class _ServiceDetailsPageState extends State<ServiceDetailsPage> {
  final Map<String, int> _rooms = {'Living room': 1, 'Bedroom': 1, 'Bathroom': 1, 'Kitchen': 0, 'Office': 0};
  final Set<String> _selectedOptions = {};
  final _notesController = TextEditingController();

  final _genericOptions = const {
    'Plumber': ['Tap repair', 'Pipe repair', 'Drain cleaning', 'Installation'],
    'Electrician': ['Switch/socket', 'Lights', 'Fan repair', 'Wiring'],
    'Painter': ['Single room', 'Multiple rooms', 'Touch-up', 'Full repaint'],
    'Carpenter': ['Furniture repair', 'Door repair', 'Cabinet work', 'Custom work'],
    'Gardener': ['Lawn care', 'Trimming', 'Planting', 'Full cleanup'],
    'Tailor': ['Alteration', 'Stitching', 'Repair', 'Custom fitting'],
    'Maid': ['Daily cleaning', 'Weekly cleaning', 'Kitchen help', 'Laundry'],
    'Driver': ['Local trip', 'Airport transfer', 'Daily driver', 'Outstation'],
    'Cook': ['Daily meals', 'Lunch/Dinner', 'Event cooking', 'Meal prep'],
  };

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isCleaning = widget.service.name == 'Cleaning';
    final options = _genericOptions[widget.service.name] ?? const <String>[];
    return Scaffold(
      appBar: AppBar(title: Text(widget.service.name), centerTitle: true),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
          children: [
            _Header(service: widget.service),
            const SizedBox(height: 22),
            Text(isCleaning ? 'What should we clean?' : 'What do you need?', style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            if (isCleaning) ..._rooms.entries.map((entry) => _RoomTile(name: entry.key, count: entry.value, onMinus: entry.value == 0 ? null : () => setState(() => _rooms[entry.key] = entry.value - 1), onPlus: () => setState(() => _rooms[entry.key] = entry.value + 1))),
            if (!isCleaning) Wrap(
              spacing: 10,
              runSpacing: 10,
              children: options.map((option) => FilterChip(label: Text(option), selected: _selectedOptions.contains(option), onSelected: (value) => setState(() => value ? _selectedOptions.add(option) : _selectedOptions.remove(option)))).toList(),
            ),
            const SizedBox(height: 22),
            const Text('Additional notes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            TextField(controller: _notesController, maxLines: 4, textInputAction: TextInputAction.newline, onChanged: (_) => setState(() {}), decoration: const InputDecoration(hintText: 'Tell the professional anything important...', alignLabelWithHint: true)),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 8, 20, 14),
        child: FilledButton(
          onPressed: _canContinue(isCleaning) ? _continue : null,
          child: const Padding(padding: EdgeInsets.symmetric(vertical: 14), child: Text('Choose date & time', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
        ),
      ),
    );
  }

  bool _canContinue(bool cleaning) {
    if (cleaning) return _rooms.values.any((value) => value > 0);
    return _selectedOptions.isNotEmpty || _notesController.text.trim().isNotEmpty;
  }

  void _continue() {
    final cleaningDetails = _rooms.entries.where((e) => e.value > 0).map((e) => '${e.key}: ${e.value}').join(', ');
    final options = _selectedOptions.join(', ');
    final details = [cleaningDetails, options, _notesController.text.trim()].where((s) => s.isNotEmpty).join(' • ');
    Navigator.push(context, MaterialPageRoute(builder: (_) => DateAndTimePage(service: widget.service, details: details)));
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.service});
  final Service service;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(22)),
    child: Row(children: [CircleAvatar(radius: 28, backgroundColor: Colors.white, child: Icon(service.icon, color: const Color(0xFF2563EB), size: 28)), const SizedBox(width: 14), Expanded(child: Text(service.description, style: TextStyle(color: Colors.grey.shade700, height: 1.3)))]),
  );
}

class _RoomTile extends StatelessWidget {
  const _RoomTile({required this.name, required this.count, required this.onMinus, required this.onPlus});
  final String name; final int count; final VoidCallback? onMinus; final VoidCallback onPlus;
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
    child: Row(children: [Expanded(child: Text(name, style: const TextStyle(fontWeight: FontWeight.w600))), IconButton(onPressed: onMinus, icon: const Icon(Icons.remove_circle_outline)), Text('$count', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)), IconButton(onPressed: onPlus, icon: const Icon(Icons.add_circle_outline))]),
  );
}
