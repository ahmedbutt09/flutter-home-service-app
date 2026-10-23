import 'package:flutter/material.dart';

import '../models/service.dart';
import 'service_details.dart';

class SelectServicePage extends StatefulWidget {
  const SelectServicePage({super.key});

  @override
  State<SelectServicePage> createState() => _SelectServicePageState();
}

class _SelectServicePageState extends State<SelectServicePage> {
  int _selected = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose a service'), centerTitle: true),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 700 ? 3 : 2;
            return GridView.builder(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 110),
              itemCount: homeServices.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1.05,
              ),
              itemBuilder: (context, index) {
                final service = homeServices[index];
                final selected = _selected == index;
                return InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => setState(() => _selected = selected ? -1 : index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: selected ? const Color(0xFFEFF6FF) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: selected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0), width: selected ? 2 : 1),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(radius: 30, backgroundColor: selected ? const Color(0xFFDBEAFE) : const Color(0xFFF1F5F9), child: Icon(service.icon, size: 30, color: selected ? const Color(0xFF2563EB) : Colors.grey.shade700)),
                        const SizedBox(height: 12),
                        Text(service.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 5),
                        Text(service.description, maxLines: 2, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 8, 20, 14),
        child: FilledButton(
          onPressed: _selected < 0 ? null : () => Navigator.push(context, MaterialPageRoute(builder: (_) => ServiceDetailsPage(service: homeServices[_selected]))),
          child: const Padding(padding: EdgeInsets.symmetric(vertical: 14), child: Text('Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
        ),
      ),
    );
  }
}
