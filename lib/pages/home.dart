import 'package:flutter/material.dart';

import '../models/service.dart';
import 'select_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.booking});
  final Booking booking;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [IconButton(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No new notifications.'))), icon: const Icon(Icons.notifications_none_rounded))],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)]), borderRadius: BorderRadius.circular(24)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Booking confirmed', style: TextStyle(color: Colors.white70, fontSize: 14)),
                const SizedBox(height: 7),
                Row(children: [CircleAvatar(radius: 27, backgroundColor: Colors.white24, child: Icon(booking.service.icon, color: Colors.white, size: 28)), const SizedBox(width: 13), Expanded(child: Text(booking.service.name, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)))]),
                const SizedBox(height: 18),
                _InfoRow(icon: Icons.calendar_today_rounded, text: _date(booking.date)),
                _InfoRow(icon: Icons.schedule_rounded, text: booking.time),
                _InfoRow(icon: Icons.repeat_rounded, text: booking.repeat),
                if (booking.extras.isNotEmpty) _InfoRow(icon: Icons.add_circle_outline, text: booking.extras.join(', ')),
              ]),
            ),
            const SizedBox(height: 20),
            if (booking.details.isNotEmpty) ...[
              const Text('Request details', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))), child: Text(booking.details, style: TextStyle(color: Colors.grey.shade700, height: 1.45))),
              const SizedBox(height: 24),
            ],
            const Text('Popular services', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            SizedBox(height: 112, child: ListView.separated(scrollDirection: Axis.horizontal, itemCount: homeServices.length, separatorBuilder: (_, __) => const SizedBox(width: 10), itemBuilder: (_, index) => _ServiceCard(service: homeServices[index]))),
            const SizedBox(height: 24),
            const Text('Top rated professionals', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            ...const [
              _Professional(name: 'Alfredo Schafer', job: 'Plumber', rating: 4.8, icon: Icons.plumbing_rounded),
              _Professional(name: 'Michelle Baldwin', job: 'Cleaner', rating: 4.6, icon: Icons.cleaning_services_rounded),
              _Professional(name: 'Brenon Kalu', job: 'Driver', rating: 4.4, icon: Icons.directions_car_rounded),
            ],
            const SizedBox(height: 16),
            FilledButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SelectServicePage())), icon: const Icon(Icons.add), label: const Padding(padding: EdgeInsets.symmetric(vertical: 13), child: Text('Book another service'))),
          ],
        ),
      ),
    );
  }

  String _date(DateTime d) => '${d.day}/${d.month}/${d.year}';
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});
  final IconData icon; final String text;
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(top: 9), child: Row(children: [Icon(icon, size: 17, color: Colors.white70), const SizedBox(width: 8), Expanded(child: Text(text, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)))]));
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.service});
  final Service service;
  @override
  Widget build(BuildContext context) => Container(width: 118, padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFE2E8F0))), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(service.icon, color: const Color(0xFF2563EB), size: 30), const SizedBox(height: 8), Text(service.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700))]));
}

class _Professional extends StatelessWidget {
  const _Professional({required this.name, required this.job, required this.rating, required this.icon});
  final String name, job; final double rating; final IconData icon;
  @override
  Widget build(BuildContext context) => Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(13), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFE2E8F0))), child: Row(children: [CircleAvatar(backgroundColor: const Color(0xFFEFF6FF), child: Icon(icon, color: const Color(0xFF2563EB))), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(name, style: const TextStyle(fontWeight: FontWeight.w800)), const SizedBox(height: 3), Text(job, style: TextStyle(color: Colors.grey.shade600))])), const Icon(Icons.star_rounded, color: Colors.orange), const SizedBox(width: 3), Text(rating.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.w800))]));
}
