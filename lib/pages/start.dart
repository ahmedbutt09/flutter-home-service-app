import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../models/service.dart';
import 'select_service.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  Timer? _timer;
  int _highlighted = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (!mounted) return;
      setState(() => _highlighted = Random().nextInt(homeServices.length));
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight - 48),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    const Icon(Icons.home_work_rounded, size: 52, color: Color(0xFF2563EB)),
                    const SizedBox(height: 10),
                    const Text('Home Services', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 6),
                    Text('Reliable help for every corner of your home.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade600)),
                    const SizedBox(height: 28),
                    LayoutBuilder(
                      builder: (context, gridConstraints) {
                        final columns = gridConstraints.maxWidth >= 650 ? 5 : 3;
                        final aspect = columns == 5 ? 1.15 : 0.95;
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: homeServices.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: columns,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: aspect,
                          ),
                          itemBuilder: (context, index) {
                            final service = homeServices[index];
                            final selected = _highlighted == index;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 350),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: selected ? Colors.white : const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: selected ? const Color(0xFFBFDBFE) : Colors.transparent, width: 2),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(service.icon, size: 30, color: selected ? const Color(0xFF2563EB) : Colors.grey.shade700),
                                  const SizedBox(height: 7),
                                  Text(service.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600)),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(42)),
                      ),
                      child: Column(
                        children: [
                          const Text('Easy, reliable way to take care of your home', textAlign: TextAlign.center, style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 12),
                          Text('Choose a service, customize your request, pick a convenient time and confirm.', textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: Colors.grey.shade600, height: 1.4)),
                          const SizedBox(height: 22),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SelectServicePage())),
                              icon: const Icon(Icons.arrow_forward_rounded),
                              label: const Padding(padding: EdgeInsets.symmetric(vertical: 15), child: Text('Get Started', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700))),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
