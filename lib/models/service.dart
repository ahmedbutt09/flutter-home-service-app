import 'package:flutter/material.dart';

class Service {
  const Service({required this.name, required this.icon, this.description = ''});

  final String name;
  final IconData icon;
  final String description;
}

const homeServices = <Service>[
  Service(name: 'Cleaning', icon: Icons.cleaning_services_rounded, description: 'Home and deep cleaning'),
  Service(name: 'Plumber', icon: Icons.plumbing_rounded, description: 'Pipes, taps and repairs'),
  Service(name: 'Electrician', icon: Icons.electrical_services_rounded, description: 'Electrical repairs'),
  Service(name: 'Painter', icon: Icons.format_paint_rounded, description: 'Walls and touch-ups'),
  Service(name: 'Carpenter', icon: Icons.handyman_rounded, description: 'Furniture and woodwork'),
  Service(name: 'Gardener', icon: Icons.grass_rounded, description: 'Garden maintenance'),
  Service(name: 'Tailor', icon: Icons.content_cut_rounded, description: 'Alterations and stitching'),
  Service(name: 'Maid', icon: Icons.person_rounded, description: 'Regular home help'),
  Service(name: 'Driver', icon: Icons.directions_car_rounded, description: 'Personal driving service'),
  Service(name: 'Cook', icon: Icons.restaurant_rounded, description: 'Home cooking support'),
];

class Booking {
  const Booking({
    required this.service,
    required this.date,
    required this.time,
    required this.repeat,
    required this.details,
    this.extras = const [],
  });

  final Service service;
  final DateTime date;
  final String time;
  final String repeat;
  final String details;
  final List<String> extras;
}
