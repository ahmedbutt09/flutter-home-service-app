import 'package:flutter/material.dart';

import '../models/service.dart';
import 'home.dart';

class DateAndTimePage extends StatefulWidget {
  const DateAndTimePage({super.key, required this.service, required this.details});
  final Service service;
  final String details;

  @override
  State<DateAndTimePage> createState() => _DateAndTimePageState();
}

class _DateAndTimePageState extends State<DateAndTimePage> {
  late final List<DateTime> _days;
  DateTime? _selectedDay;
  String? _selectedTime;
  String _repeat = 'No repeat';
  final Set<String> _extras = {};

  final _times = const ['08:00', '09:30', '11:00', '12:30', '14:00', '15:30', '17:00', '18:30', '20:00'];
  final _repeatOptions = const ['No repeat', 'Every day', 'Every week', 'Every month'];
  final _extraOptions = const {'Washing machine': 10, 'Fridge': 8, 'Oven': 8, 'Windows': 20, 'Vehicle': 20};

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    _days = List.generate(14, (i) => DateTime(today.year, today.month, today.day + i));
    _selectedDay = _days.first;
  }

  @override
  Widget build(BuildContext context) {
    final canContinue = _selectedDay != null && _selectedTime != null;
    return Scaffold(
      appBar: AppBar(title: const Text('Date & time'), centerTitle: true),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
          children: [
            const Text('Pick a convenient day', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            SizedBox(
              height: 94,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _days.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final day = _days[index]; final selected = _selectedDay == day;
                  return InkWell(
                    onTap: () => setState(() => _selectedDay = day),
                    borderRadius: BorderRadius.circular(16),
                    child: AnimatedContainer(duration: const Duration(milliseconds: 200), width: 66, padding: const EdgeInsets.symmetric(vertical: 10), decoration: BoxDecoration(color: selected ? const Color(0xFF2563EB) : Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: selected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0))), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text(_weekday(day), style: TextStyle(color: selected ? Colors.white : Colors.grey.shade600, fontSize: 12)), const SizedBox(height: 5), Text('${day.day}', style: TextStyle(color: selected ? Colors.white : Colors.black87, fontSize: 21, fontWeight: FontWeight.w800)), Text(_month(day), style: TextStyle(color: selected ? Colors.white : Colors.grey.shade600, fontSize: 11))])),
                  );
                },
              ),
            ),
            const SizedBox(height: 26),
            const Text('Choose a time', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            Wrap(spacing: 10, runSpacing: 10, children: _times.map((time) => ChoiceChip(label: Text(time), selected: _selectedTime == time, onSelected: (_) => setState(() => _selectedTime = time))).toList()),
            const SizedBox(height: 26),
            const Text('Repeat', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: _repeatOptions.map((value) => Padding(padding: const EdgeInsets.only(right: 8), child: ChoiceChip(label: Text(value), selected: _repeat == value, onSelected: (_) => setState(() => _repeat = value)))).toList())),
            const SizedBox(height: 26),
            const Text('Additional services', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            Wrap(spacing: 10, runSpacing: 10, children: _extraOptions.entries.map((entry) => FilterChip(label: Text('${entry.key} +\$${entry.value}'), selected: _extras.contains(entry.key), onSelected: (value) => setState(() => value ? _extras.add(entry.key) : _extras.remove(entry.key)))).toList()),
            const SizedBox(height: 20),
            if (_selectedTime != null) Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xFFF0FDF4), borderRadius: BorderRadius.circular(14)), child: Text('Selected: ${_formatDate(_selectedDay!)} at $_selectedTime', style: const TextStyle(fontWeight: FontWeight.w600))),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 8, 20, 14),
        child: FilledButton(
          onPressed: canContinue ? _confirm : null,
          child: const Padding(padding: EdgeInsets.symmetric(vertical: 14), child: Text('Confirm booking', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
        ),
      ),
    );
  }

  void _confirm() {
    final booking = Booking(service: widget.service, date: _selectedDay!, time: _selectedTime!, repeat: _repeat, details: widget.details, extras: _extras.toList());
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => HomePage(booking: booking)), (route) => false);
  }

  String _weekday(DateTime d) => const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][d.weekday - 1];
  String _month(DateTime d) => const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][d.month - 1];
  String _formatDate(DateTime d) => '${_weekday(d)}, ${d.day} ${_month(d)} ${d.year}';
}
