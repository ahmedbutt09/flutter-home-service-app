import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const HomeServeApp());

// -----------------------------------------------------------------------------
// HOME SERVE PRO — complete local demo
// Roles: Customer, Worker, Admin
// This build intentionally uses local in-memory data so it runs without backend
// credentials. Firebase/API integration can be added behind the repository layer.
// -----------------------------------------------------------------------------

const primary = Color(0xFF2563EB);
const secondary = Color(0xFF7C3AED);
const ink = Color(0xFF0F172A);
const muted = Color(0xFF64748B);
const surface = Color(0xFFF8FAFC);

class HomeServeApp extends StatefulWidget {
  const HomeServeApp({super.key});
  @override
  State<HomeServeApp> createState() => _HomeServeAppState();
}

class _HomeServeAppState extends State<HomeServeApp> {
  DemoStore store = DemoStore.seeded();
  AppRole? role;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HomeServe Pro',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: primary, brightness: Brightness.light),
        scaffoldBackgroundColor: surface,
        fontFamily: 'Roboto',
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFE2E8F0)),),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: primary, width: 1.5)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        ),
      ),
      home: role == null
          ? RoleLoginPage(onEnter: (r) => setState(() => role = r))
          : AppShell(role: role!, store: store, onLogout: () => setState(() => role = null)),
    );
  }
}

enum AppRole { customer, worker, admin }

enum JobStatus { pending, accepted, onTheWay, inProgress, completed, cancelled }

class ServiceItem {
  ServiceItem(this.id, this.name, this.category, this.description, this.price, this.icon, this.image, this.color);
  final String id, name, category, description, image;
  final double price;
  final IconData icon;
  final Color color;
}

class WorkerProfile {
  WorkerProfile({required this.id, required this.name, required this.skill, required this.rating, required this.jobs, required this.verified, this.online = true, this.rate = 25});
  final String id, name, skill;
  final double rating, rate;
  int jobs;
  bool verified, online;
}

class Booking {
  Booking({required this.id, required this.service, required this.customer, required this.address, required this.date, required this.time, required this.total, this.worker, this.status = JobStatus.pending, this.notes = '', this.rooms = 1, this.repeat = 'One time'});
  final String id, customer, address, time, notes, repeat;
  final ServiceItem service;
  final DateTime date;
  final double total;
  WorkerProfile? worker;
  JobStatus status;
  int rooms;
}

class DemoStore {
  DemoStore.seeded() {
    services = [
      ServiceItem('clean', 'Home Cleaning', 'Cleaning', 'Deep, regular and move-in cleaning', 35, Icons.cleaning_services_rounded, 'https://images.unsplash.com/photo-1581578731548-c64695cc6952?auto=format&fit=crop&w=900&q=80', const Color(0xFF0EA5E9)),
      ServiceItem('plumb', 'Plumbing', 'Repairs', 'Leaks, pipes, taps and fixtures', 45, Icons.plumbing_rounded, 'https://images.unsplash.com/photo-1607472586893-edb57bdc0e39?auto=format&fit=crop&w=900&q=80', const Color(0xFF2563EB)),
      ServiceItem('electric', 'Electrician', 'Repairs', 'Safe electrical repair and installation', 40, Icons.electrical_services_rounded, 'https://images.unsplash.com/photo-1621905252507-b35492cc74b4?auto=format&fit=crop&w=900&q=80', const Color(0xFFF59E0B)),
      ServiceItem('ac', 'AC Service', 'Appliance', 'AC maintenance, repair and installation', 30, Icons.ac_unit_rounded, 'https://images.unsplash.com/photo-1621905251918-48416bd8575a?auto=format&fit=crop&w=900&q=80', const Color(0xFF06B6D4)),
      ServiceItem('paint', 'Painting', 'Home Improvement', 'Walls, ceilings and touch-ups', 70, Icons.format_paint_rounded, 'https://images.unsplash.com/photo-1562259949-e8e7689d7828?auto=format&fit=crop&w=900&q=80', const Color(0xFF8B5CF6)),
      ServiceItem('car', 'Car Wash', 'Automotive', 'At-home exterior and interior cleaning', 20, Icons.local_car_wash_rounded, 'https://images.unsplash.com/photo-1520340356584-f9917d1eea6f?auto=format&fit=crop&w=900&q=80', const Color(0xFF14B8A6)),
      ServiceItem('moving', 'Moving Help', 'Moving', 'Packing, lifting and local moving help', 90, Icons.local_shipping_rounded, 'https://images.unsplash.com/photo-1600518464441-9154a4dea21b?auto=format&fit=crop&w=900&q=80', const Color(0xFFF97316)),
      ServiceItem('garden', 'Gardening', 'Outdoor', 'Lawn, plants and garden maintenance', 28, Icons.yard_rounded, 'https://images.unsplash.com/photo-1558904541-efa843a96f01?auto=format&fit=crop&w=900&q=80', const Color(0xFF22C55E)),
      ServiceItem('pest', 'Pest Control', 'Cleaning', 'Home pest inspection and treatment', 55, Icons.bug_report_rounded, 'https://images.unsplash.com/photo-1599940824399-b87987ceb72a?auto=format&fit=crop&w=900&q=80', const Color(0xFFEF4444)),
      ServiceItem('appliance', 'Appliance Repair', 'Appliance', 'Washing machine, fridge and appliance help', 50, Icons.home_repair_service_rounded, 'https://images.unsplash.com/photo-1581094794329-c8112a89af12?auto=format&fit=crop&w=900&q=80', const Color(0xFF6366F1)),
    ];
    workers = [
      WorkerProfile(id: 'w1', name: 'Arsalan Khan', skill: 'Plumber', rating: 4.9, jobs: 182, verified: true, rate: 35),
      WorkerProfile(id: 'w2', name: 'Ayesha Malik', skill: 'Home Cleaner', rating: 4.8, jobs: 241, verified: true, rate: 28),
      WorkerProfile(id: 'w3', name: 'Hamza Ali', skill: 'Electrician', rating: 4.7, jobs: 133, verified: true, rate: 40),
      WorkerProfile(id: 'w4', name: 'Sana Raza', skill: 'AC Technician', rating: 4.8, jobs: 97, verified: true, rate: 30),
      WorkerProfile(id: 'w5', name: 'Bilal Ahmed', skill: 'Painter', rating: 4.6, jobs: 88, verified: false, rate: 45),
    ];
    bookings = [
      Booking(id: 'B-1042', service: services[1], customer: 'Demo Customer', address: 'Main Boulevard, Kohat', date: DateTime.now(), time: '05:30 PM', total: 65, worker: workers[0], status: JobStatus.accepted, notes: 'Kitchen sink is leaking.'),
      Booking(id: 'B-1038', service: services[0], customer: 'Maria Khan', address: 'City Center', date: DateTime.now().add(const Duration(days: 1)), time: '11:00 AM', total: 55, worker: workers[1], status: JobStatus.pending, rooms: 2),
      Booking(id: 'B-1031', service: services[2], customer: 'Usman Shah', address: 'Cantt Road', date: DateTime.now().subtract(const Duration(days: 1)), time: '03:00 PM', total: 80, worker: workers[2], status: JobStatus.completed),
    ];
  }
  late List<ServiceItem> services;
  late List<WorkerProfile> workers;
  late List<Booking> bookings;
  int notifications = 3;

  List<Booking> get customerBookings => bookings.where((b) => b.customer == 'Demo Customer').toList();
  List<Booking> get workerJobs => bookings.where((b) => b.worker?.id == 'w1').toList();

  void addBooking(Booking b) { bookings.insert(0, b); }
}

class RoleLoginPage extends StatefulWidget {
  const RoleLoginPage({super.key, required this.onEnter});
  final ValueChanged<AppRole> onEnter;
  @override State<RoleLoginPage> createState() => _RoleLoginPageState();
}
class _RoleLoginPageState extends State<RoleLoginPage> with SingleTickerProviderStateMixin {
  AppRole selected = AppRole.customer;
  late AnimationController controller;
  @override void initState() { super.initState(); controller = AnimationController(vsync: this, duration: const Duration(seconds: 8))..repeat(); }
  @override void dispose() { controller.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) {
    return Scaffold(body: Stack(children: [
      AnimatedBuilder(animation: controller, builder: (_, __) => Positioned(top: -80 + controller.value * 30, right: -90, child: _Blob(color: primary.withOpacity(.16), size: 300))),
      Positioned(bottom: -100, left: -90, child: _Blob(color: secondary.withOpacity(.12), size: 320)),
      SafeArea(child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 520), child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: Column(children: [
        const SizedBox(height: 30),
        Hero(tag: 'logo', child: Container(width: 78, height: 78, decoration: BoxDecoration(gradient: const LinearGradient(colors: [primary, secondary]), borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: primary.withOpacity(.25), blurRadius: 28, offset: Offset(0, 12))]), child: const Icon(Icons.home_work_rounded, color: Colors.white, size: 42))),
        const SizedBox(height: 20), const Text('HomeServe Pro', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: ink)),
        const SizedBox(height: 8), Text('One platform. Every home service.', style: TextStyle(color: muted, fontSize: 16)),
        const SizedBox(height: 28),
        _FeatureBanner(), const SizedBox(height: 20),
        Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Continue as', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)), const SizedBox(height: 14),
          Row(children: [
            Expanded(child: _RoleTile(role: AppRole.customer, selected: selected == AppRole.customer, onTap: () => setState(() => selected = AppRole.customer))),
            const SizedBox(width: 10), Expanded(child: _RoleTile(role: AppRole.worker, selected: selected == AppRole.worker, onTap: () => setState(() => selected = AppRole.worker))),
            const SizedBox(width: 10), Expanded(child: _RoleTile(role: AppRole.admin, selected: selected == AppRole.admin, onTap: () => setState(() => selected = AppRole.admin))),
          ]), const SizedBox(height: 20),
          FilledButton(onPressed: () => widget.onEnter(selected), style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(54), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))), child: Text('Open ${roleName(selected)} dashboard')),
        ])),),
        const SizedBox(height: 16), Text('Demo mode • No account or internet required', style: TextStyle(color: muted, fontSize: 12)),
      ]))))),
    ]));
  }
}

String roleName(AppRole r) => r == AppRole.customer ? 'Customer' : r == AppRole.worker ? 'Worker' : 'Admin';
IconData roleIcon(AppRole r) => r == AppRole.customer ? Icons.person_rounded : r == AppRole.worker ? Icons.handyman_rounded : Icons.admin_panel_settings_rounded;

class _RoleTile extends StatelessWidget { const _RoleTile({required this.role, required this.selected, required this.onTap}); final AppRole role; final bool selected; final VoidCallback onTap; @override Widget build(BuildContext c) => InkWell(onTap: onTap, borderRadius: BorderRadius.circular(16), child: AnimatedContainer(duration: const Duration(milliseconds: 220), padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 6), decoration: BoxDecoration(color: selected ? primary.withOpacity(.08) : Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: selected ? primary : const Color(0xFFE2E8F0), width: selected ? 1.5 : 1)), child: Column(children: [Icon(roleIcon(role), color: selected ? primary : muted), const SizedBox(height: 8), Text(roleName(role), style: TextStyle(fontWeight: FontWeight.w700, color: selected ? primary : ink, fontSize: 12))]))); }
class _Blob extends StatelessWidget { const _Blob({required this.color, required this.size}); final Color color; final double size; @override Widget build(BuildContext c) => Container(width: size, height: size, decoration: BoxDecoration(shape: BoxShape.circle, color: color)); }
class _FeatureBanner extends StatelessWidget {
  @override
  Widget build(BuildContext c) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF111827), Color(0xFF334155)]),
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Row(
          children: [
            Icon(Icons.auto_awesome_rounded, color: Colors.amber, size: 30),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Fast, trusted & trackable', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
                  SizedBox(height: 4),
                  Text('Book • assign • track • review', style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
          ],
        ),
      );
}

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.role, required this.store, required this.onLogout});
  final AppRole role; final DemoStore store; final VoidCallback onLogout;
  @override State<AppShell> createState() => _AppShellState();
}
class _AppShellState extends State<AppShell> {
  int index = 0;
  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  @override Widget build(BuildContext context) {
    final pages = widget.role == AppRole.customer ? [CustomerHome(store: widget.store, onChanged: refresh), CustomerBookings(store: widget.store, onChanged: refresh), ServicesPage(store: widget.store, onBooked: refresh), MessagesPage(), ProfilePage(role: widget.role, onLogout: widget.onLogout)] : widget.role == AppRole.worker ? [WorkerHome(store: widget.store, onChanged: refresh), WorkerJobs(store: widget.store, onChanged: refresh), WorkerEarnings(store: widget.store), WorkerProfilePage(store: widget.store), ProfilePage(role: widget.role, onLogout: widget.onLogout)] : [AdminHome(store: widget.store, onChanged: refresh), AdminBookings(store: widget.store, onChanged: refresh), AdminPeople(store: widget.store), AdminServices(store: widget.store), ProfilePage(role: widget.role, onLogout: widget.onLogout)];
    final labels = widget.role == AppRole.customer ? ['Home', 'Bookings', 'Services', 'Messages', 'Profile'] : widget.role == AppRole.worker ? ['Dashboard', 'Jobs', 'Earnings', 'Profile', 'Account'] : ['Overview', 'Bookings', 'People', 'Services', 'Account'];
    final icons = widget.role == AppRole.customer ? [Icons.home_rounded, Icons.calendar_month_rounded, Icons.grid_view_rounded, Icons.chat_bubble_rounded, Icons.person_rounded] : widget.role == AppRole.worker ? [Icons.dashboard_rounded, Icons.work_history_rounded, Icons.payments_rounded, Icons.badge_rounded, Icons.person_rounded] : [Icons.insights_rounded, Icons.receipt_long_rounded, Icons.groups_rounded, Icons.miscellaneous_services_rounded, Icons.settings_rounded];
    return LayoutBuilder(builder: (context, box) {
      final wide = box.maxWidth >= 900;
      return Scaffold(key: key, drawer: wide ? null : AppDrawer(role: widget.role, index: index, labels: labels, icons: icons, onSelect: (i) { setState(() => index = i); Navigator.pop(context); }, onLogout: widget.onLogout), body: Row(children: [
        if (wide) NavigationRailExtended(role: widget.role, index: index, labels: labels, icons: icons, onSelect: (i) => setState(() => index = i), onLogout: widget.onLogout),
        Expanded(child: AnimatedSwitcher(duration: const Duration(milliseconds: 300), transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: SlideTransition(position: Tween(begin: const Offset(.03, 0), end: Offset.zero).animate(anim), child: child)), child: KeyedSubtree(key: ValueKey(index), child: pages[index]))),
      ]), bottomNavigationBar: wide ? null : NavigationBar(selectedIndex: index, onDestinationSelected: (i) => setState(() => index = i), destinations: List.generate(labels.length, (i) => NavigationDestination(icon: Icon(icons[i]), label: labels[i]))));
    });
  }
  void refresh() => setState(() {});
}

class NavigationRailExtended extends StatelessWidget { const NavigationRailExtended({super.key, required this.role, required this.index, required this.labels, required this.icons, required this.onSelect, required this.onLogout}); final AppRole role; final int index; final List<String> labels; final List<IconData> icons; final ValueChanged<int> onSelect; final VoidCallback onLogout; @override Widget build(BuildContext c) => Container(width: 250, color: Colors.white, child: SafeArea(child: Column(children: [const SizedBox(height: 24), Row(mainAxisAlignment: MainAxisAlignment.center, children: [Hero(tag: 'logo', child: Container(width: 42, height: 42, decoration: BoxDecoration(gradient: const LinearGradient(colors: [primary, secondary]), borderRadius: BorderRadius.circular(13)), child: const Icon(Icons.home_work_rounded, color: Colors.white))), const SizedBox(width: 10), const Text('HomeServe', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18))]), const SizedBox(height: 30), ...List.generate(labels.length, (i) => _NavItem(label: labels[i], icon: icons[i], selected: index == i, onTap: () => onSelect(i))), const Spacer(), Padding(padding: const EdgeInsets.all(14), child: ListTile(leading: const Icon(Icons.logout_rounded), title: const Text('Sign out'), onTap: onLogout))]))); }
class _NavItem extends StatelessWidget { const _NavItem({required this.label, required this.icon, required this.selected, required this.onTap}); final String label; final IconData icon; final bool selected; final VoidCallback onTap; @override Widget build(BuildContext c) => Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3), child: ListTile(onTap: onTap, selected: selected, selectedTileColor: primary.withOpacity(.09), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), leading: Icon(icon, color: selected ? primary : muted), title: Text(label, style: TextStyle(fontWeight: selected ? FontWeight.w800 : FontWeight.w600, color: selected ? primary : ink)))); }

class AppDrawer extends StatelessWidget { const AppDrawer({super.key, required this.role, required this.index, required this.labels, required this.icons, required this.onSelect, required this.onLogout}); final AppRole role; final int index; final List<String> labels; final List<IconData> icons; final ValueChanged<int> onSelect; final VoidCallback onLogout; @override Widget build(BuildContext c) => Drawer(child: SafeArea(child: Column(children: [const SizedBox(height: 20), const CircleAvatar(radius: 32, child: Icon(Icons.home_work_rounded, size: 32)), const SizedBox(height: 10), Text(roleName(role), style: const TextStyle(fontWeight: FontWeight.w800)), const SizedBox(height: 20), ...List.generate(labels.length, (i) => ListTile(selected: index == i, leading: Icon(icons[i]), title: Text(labels[i]), onTap: () => onSelect(i))), const Spacer(), ListTile(leading: const Icon(Icons.logout_rounded), title: const Text('Sign out'), onTap: onLogout)]))); }

class PageFrame extends StatelessWidget { const PageFrame({super.key, required this.title, this.subtitle, required this.child, this.actions, this.onMenu}); final String title; final String? subtitle; final Widget child; final List<Widget>? actions; final VoidCallback? onMenu; @override Widget build(BuildContext c) => SafeArea(child: Column(children: [Padding(padding: const EdgeInsets.fromLTRB(20, 18, 20, 10), child: Row(children: [if (onMenu != null) IconButton(onPressed: onMenu, icon: const Icon(Icons.menu_rounded)), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: ink)), if (subtitle != null) Text(subtitle!, style: const TextStyle(color: muted))])), ...(actions ?? [])])), Expanded(child: child)])); }

class CustomerHome extends StatelessWidget { const CustomerHome({super.key, required this.store, required this.onChanged}); final DemoStore store; final VoidCallback onChanged; @override Widget build(BuildContext c) { return PageFrame(title: 'Good evening 👋', subtitle: 'What can we help you with?', actions: [IconButton(onPressed: () => showSnack(c, 'No new notifications'), icon: const Icon(Icons.notifications_none_rounded))], child: ListView(padding: const EdgeInsets.fromLTRB(20, 8, 20, 30), children: [
  _HeroBooking(onTap: () => Navigator.push(c, MaterialPageRoute(builder: (_) => BookingWizard(store: store, service: store.services.first, onDone: onChanged)))), const SizedBox(height: 22),
  const SectionTitle('Popular services', action: 'View all'), const SizedBox(height: 12), SizedBox(height: 190, child: ListView.separated(scrollDirection: Axis.horizontal, itemCount: store.services.length, separatorBuilder: (_, __) => const SizedBox(width: 14), itemBuilder: (_, i) => ServiceCard(service: store.services[i], onTap: () => Navigator.push(c, MaterialPageRoute(builder: (_) => BookingWizard(store: store, service: store.services[i], onDone: onChanged)))))), const SizedBox(height: 24),
  const SectionTitle('Why HomeServe?',), const SizedBox(height: 12), Wrap(spacing: 10, runSpacing: 10, children: const [MiniFeature(icon: Icons.verified_rounded, title: 'Verified pros'), MiniFeature(icon: Icons.location_on_rounded, title: 'Live tracking'), MiniFeature(icon: Icons.shield_rounded, title: 'Secure booking'), MiniFeature(icon: Icons.support_agent_rounded, title: '24/7 support')]), const SizedBox(height: 24),
  const SectionTitle('Recommended professionals'), const SizedBox(height: 12), ...store.workers.take(3).map((w) => WorkerTile(worker: w, onTap: () => showWorkerSheet(c, w))),
])); } }

class _HeroBooking extends StatefulWidget { const _HeroBooking({required this.onTap}); final VoidCallback onTap; @override State<_HeroBooking> createState() => _HeroBookingState(); }
class _HeroBookingState extends State<_HeroBooking> with SingleTickerProviderStateMixin { late AnimationController controller; @override void initState(){super.initState(); controller=AnimationController(vsync:this,duration:const Duration(seconds:2))..repeat(reverse:true);} @override void dispose(){controller.dispose();super.dispose();} @override Widget build(BuildContext c)=>AnimatedBuilder(animation:controller,builder:(_,__)=>Transform.translate(offset:Offset(0,-3*controller.value),child:Container(padding:const EdgeInsets.all(22),decoration:BoxDecoration(gradient:const LinearGradient(colors:[Color(0xFF1D4ED8),Color(0xFF7C3AED)]),borderRadius:BorderRadius.circular(28)),child:Row(children:[Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[const Text('Need a hand at home?',style:TextStyle(color:Colors.white,fontSize:22,fontWeight:FontWeight.w900)),const SizedBox(height:8),const Text('Book a trusted professional in minutes.',style:TextStyle(color:Colors.white70)),const SizedBox(height:16),FilledButton.tonal(onPressed:widget.onTap,style:FilledButton.styleFrom(backgroundColor:Colors.white,foregroundColor:primary),child:const Text('Book a service'))])),const SizedBox(width:10),const Icon(Icons.home_work_rounded,color:Colors.white24,size:92)])))); }

class SectionTitle extends StatelessWidget { const SectionTitle(this.title,{super.key,this.action}); final String title; final String? action; @override Widget build(BuildContext c)=>Row(children:[Expanded(child:Text(title,style:const TextStyle(fontSize:18,fontWeight:FontWeight.w900))),if(action!=null)TextButton(onPressed:(){},child:Text(action!))]); }
class MiniFeature extends StatelessWidget { const MiniFeature({required this.icon,required this.title}); final IconData icon; final String title; @override Widget build(BuildContext c)=>Container(width:MediaQuery.sizeOf(c).width>600?210:160,padding:const EdgeInsets.all(14),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(18),border:Border.all(color:const Color(0xFFE2E8F0))),child:Row(children:[CircleAvatar(backgroundColor:primary.withOpacity(.09),child:Icon(icon,color:primary)),const SizedBox(width:10),Expanded(child:Text(title,style:const TextStyle(fontWeight:FontWeight.w700)))])); }

class ServiceCard extends StatelessWidget { const ServiceCard({super.key,required this.service,required this.onTap}); final ServiceItem service; final VoidCallback onTap; @override Widget build(BuildContext c)=>InkWell(onTap:onTap,borderRadius:BorderRadius.circular(22),child:Container(width:180,decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(22),boxShadow:[BoxShadow(color:Colors.black.withOpacity(.05),blurRadius:18,offset:const Offset(0,8))]),clipBehavior:Clip.antiAlias,child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[SizedBox(height:108,width:double.infinity,child:Stack(fit:StackFit.expand,children:[Image.network(service.image,fit:BoxFit.cover,errorBuilder:(_,__,___)=>Container(color:service.color.withOpacity(.13),child:Icon(service.icon,size:48,color:service.color))),Container(decoration:BoxDecoration(gradient:LinearGradient(begin:Alignment.topCenter,end:Alignment.bottomCenter,colors:[Colors.transparent,Colors.black.withOpacity(.35)]))),Positioned(left:12,bottom:10,child:CircleAvatar(radius:20,backgroundColor:Colors.white,child:Icon(service.icon,color:service.color)))])),Padding(padding:const EdgeInsets.fromLTRB(13,11,13,3),child:Text(service.name,maxLines:1,overflow:TextOverflow.ellipsis,style:const TextStyle(fontWeight:FontWeight.w900))),Padding(padding:const EdgeInsets.fromLTRB(13,0,13,12),child:Text('From \$${service.price.toStringAsFixed(0)}',style:const TextStyle(color:muted,fontSize:12,fontWeight:FontWeight.w600))) ]))); }

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key, required this.store, required this.onBooked});
  final DemoStore store;
  final VoidCallback onBooked;

  @override
  Widget build(BuildContext c) => PageFrame(
        title: 'All services',
        subtitle: 'Choose what you need today',
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
          children: [
            const TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search_rounded),
                hintText: 'Search cleaning, plumbing, AC...',
              ),
            ),
            const SizedBox(height: 18),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 330,
                mainAxisExtent: 220,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              itemCount: store.services.length,
              itemBuilder: (_, i) => ServiceCard(
                service: store.services[i],
                onTap: () => Navigator.push(
                  c,
                  MaterialPageRoute(
                    builder: (_) => BookingWizard(
                      store: store,
                      service: store.services[i],
                      onDone: onBooked,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}


class BookingWizard extends StatefulWidget { const BookingWizard({super.key,required this.store,required this.service,required this.onDone}); final DemoStore store; final ServiceItem service; final VoidCallback onDone; @override State<BookingWizard> createState()=>_BookingWizardState(); }
class _BookingWizardState extends State<BookingWizard> {
  int step = 0;
  int rooms = 1;
  WorkerProfile? worker;
  DateTime date = DateTime.now().add(const Duration(days: 1));
  TimeOfDay time = const TimeOfDay(hour: 11, minute: 0);
  String repeat = 'One time';
  final notes = TextEditingController();
  final address = TextEditingController(text: 'Main Boulevard, Kohat');

  @override
  void dispose() {
    notes.dispose();
    address.dispose();
    super.dispose();
  }

  double get total => widget.service.price + (rooms - 1) * 10 + (worker?.rate ?? 0) * .25;

  @override
  Widget build(BuildContext c) {
    final titles = ['Service details', 'Date & time', 'Choose professional', 'Confirm'];
    return Scaffold(
      appBar: AppBar(title: Text(titles[step]), centerTitle: true),
      body: SafeArea(
        child: Column(
          children: [
            LinearProgressIndicator(value: (step + 1) / 4, minHeight: 4),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: KeyedSubtree(
                  key: ValueKey(step),
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      if (step == 0) _bookingDetails(),
                      if (step == 1) _dateTime(),
                      if (step == 2) _workerPick(),
                      if (step == 3) _confirmStep(),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Row(
                children: [
                  if (step > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => setState(() => step--),
                        child: const Text('Back'),
                      ),
                    ),
                  if (step > 0) const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: FilledButton(
                      onPressed: step < 3 ? () => setState(() => step++) : _confirm,
                      style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                      child: Text(step == 3 ? 'Confirm booking' : 'Continue'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bookingDetails() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ServiceCard(service: widget.service, onTap: () {}),
          const SizedBox(height: 22),
          const Text('How many rooms?', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: List.generate(
              5,
              (i) => ChoiceChip(
                label: Text('${i + 1}'),
                selected: rooms == i + 1,
                onSelected: (_) => setState(() => rooms = i + 1),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Address', style: TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          TextField(controller: address, maxLines: 2, decoration: const InputDecoration(prefixIcon: Icon(Icons.location_on_rounded), hintText: 'Service address')),
          const SizedBox(height: 20),
          const Text('Additional notes', style: TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          TextField(controller: notes, maxLines: 4, decoration: const InputDecoration(hintText: 'Describe the work, access instructions, etc.')),
        ],
      );

  Widget _dateTime() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Pick a date', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
          const SizedBox(height: 12),
          CalendarDatePicker(
            initialDate: date,
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 60)),
            onDateChanged: (d) => setState(() => date = d),
          ),
          const SizedBox(height: 16),
          const Text('Pick a time', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['09:00 AM', '11:00 AM', '01:30 PM', '03:00 PM', '05:30 PM', '07:00 PM'].map((t) {
              return ChoiceChip(
                label: Text(t),
                selected: timeLabel() == t,
                onSelected: (_) {
                  final parts = t.split(' ');
                  final hm = parts[0].split(':');
                  var h = int.parse(hm[0]);
                  if (parts[1] == 'PM' && h != 12) h += 12;
                  if (parts[1] == 'AM' && h == 12) h = 0;
                  setState(() => time = TimeOfDay(hour: h, minute: int.parse(hm[1])));
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          const Text('Repeat booking', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: ['One time', 'Weekly', 'Monthly'].map((x) => ChoiceChip(label: Text(x), selected: repeat == x, onSelected: (_) => setState(() => repeat = x))).toList(),
          ),
        ],
      );

  String timeLabel() {
    final h = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    return '${h.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} ${time.period == DayPeriod.am ? 'AM' : 'PM'}';
  }

  Widget _workerPick() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Available professionals', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20)),
          const SizedBox(height: 8),
          const Text('Pick a verified pro or let us assign the best match.', style: TextStyle(color: muted)),
          const SizedBox(height: 16),
          ...widget.store.workers.map((w) => SelectableWorker(worker: w, selected: worker?.id == w.id, onTap: () => setState(() => worker = w))),
        ],
      );

  Widget _confirmStep() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Review booking', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22)),
          const SizedBox(height: 16),
          SummaryCard(rows: {
            'Service': widget.service.name,
            'Date': formatDate(date),
            'Time': timeLabel(),
            'Address': address.text,
            'Professional': worker?.name ?? 'Auto assign',
            'Repeat': repeat,
            'Total': '\$${total.toStringAsFixed(2)}',
          }),
          const SizedBox(height: 16),
          const Text('Payment method', style: TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          const Card(child: ListTile(leading: CircleAvatar(child: Icon(Icons.payments_rounded)), title: Text('Cash on service'), subtitle: Text('Change payment method later'))),
        ],
      );

  void _confirm() {
    final b = Booking(
      id: 'B-${1000 + widget.store.bookings.length}',
      service: widget.service,
      customer: 'Demo Customer',
      address: address.text,
      date: date,
      time: timeLabel(),
      total: total,
      worker: worker,
      status: worker == null ? JobStatus.pending : JobStatus.accepted,
      notes: notes.text,
      rooms: rooms,
      repeat: repeat,
    );
    widget.store.addBooking(b);
    widget.onDone();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => BookingSuccess(booking: b)));
  }
}


class SelectableWorker extends StatelessWidget { const SelectableWorker({super.key,required this.worker,required this.selected,required this.onTap}); final WorkerProfile worker; final bool selected; final VoidCallback onTap; @override Widget build(BuildContext c)=>InkWell(onTap:onTap,borderRadius:BorderRadius.circular(18),child:Container(margin:const EdgeInsets.only(bottom:10),padding:const EdgeInsets.all(14),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(18),border:Border.all(color:selected?primary:const Color(0xFFE2E8F0),width:selected?2:1)),child:Row(children:[CircleAvatar(radius:25,backgroundColor:primary.withOpacity(.1),child:Text(worker.name.substring(0,1),style:const TextStyle(fontWeight:FontWeight.w900,color:primary))),const SizedBox(width:12),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Row(children:[Text(worker.name,style:const TextStyle(fontWeight:FontWeight.w900)),if(worker.verified)const Padding(padding:EdgeInsets.only(left:5),child:Icon(Icons.verified_rounded,size:16,color:Colors.blue))]),Text(worker.skill,style:const TextStyle(color:muted)),Text('★ ${worker.rating} • ${worker.jobs} jobs',style:const TextStyle(fontSize:12,color:muted))])),Icon(selected?Icons.radio_button_checked_rounded:Icons.radio_button_off_rounded,color:selected?primary:muted)]))); }
class SummaryCard extends StatelessWidget { const SummaryCard({super.key,required this.rows}); final Map<String,String> rows; @override Widget build(BuildContext c)=>Card(child:Padding(padding:const EdgeInsets.all(16),child:Column(children:rows.entries.map((e)=>Padding(padding:const EdgeInsets.symmetric(vertical:7),child:Row(children:[Expanded(child:Text(e.key,style:const TextStyle(color:muted))),Flexible(child:Text(e.value,textAlign:TextAlign.right,style:const TextStyle(fontWeight:FontWeight.w800)))]))).toList()))); }

class BookingSuccess extends StatefulWidget {
  const BookingSuccess({super.key, required this.booking});
  final Booking booking;
  @override State<BookingSuccess> createState() => _BookingSuccessState();
}

class _BookingSuccessState extends State<BookingSuccess> with SingleTickerProviderStateMixin {
  late AnimationController c;
  @override
  void initState() {
    super.initState();
    c = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))..forward();
  }
  @override
  void dispose() { c.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ScaleTransition(
            scale: CurvedAnimation(parent: c, curve: Curves.elasticOut),
            child: Column(
              children: [
                Container(width: 90, height: 90, decoration: BoxDecoration(color: Colors.green.withOpacity(.1), shape: BoxShape.circle), child: const Icon(Icons.check_rounded, color: Colors.green, size: 55)),
                const SizedBox(height: 20),
                const Text('Booking confirmed!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                Text(widget.booking.service.name, style: const TextStyle(color: muted, fontSize: 16)),
                const SizedBox(height: 24),
                SummaryCard(rows: {
                  'Booking ID': widget.booking.id,
                  'Date': formatDate(widget.booking.date),
                  'Time': widget.booking.time,
                  'Professional': widget.booking.worker?.name ?? 'Finding best match',
                  'Total': '\$${widget.booking.total.toStringAsFixed(2)}',
                }),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.home_rounded),
                  label: const Padding(padding: EdgeInsets.symmetric(vertical: 13), child: Text('Back to dashboard')),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}


class CustomerBookings extends StatelessWidget { const CustomerBookings({super.key,required this.store,required this.onChanged}); final DemoStore store; final VoidCallback onChanged; @override Widget build(BuildContext c){final list=store.customerBookings; return PageFrame(title:'My bookings',subtitle:'Track and manage your services',child:list.isEmpty?const EmptyState(title:'No bookings yet',icon:Icons.calendar_month_rounded):ListView(padding:const EdgeInsets.fromLTRB(20,8,20,30),children:list.map((b)=>BookingCard(booking:b,onTap:()=>showBookingSheet(c,b,onChanged))).toList()));}}
class BookingCard extends StatelessWidget { const BookingCard({super.key,required this.booking,required this.onTap}); final Booking booking; final VoidCallback onTap; @override Widget build(BuildContext c)=>InkWell(onTap:onTap,borderRadius:BorderRadius.circular(20),child:Card(margin:const EdgeInsets.only(bottom:12),child:Padding(padding:const EdgeInsets.all(14),child:Row(children:[Container(width:58,height:58,decoration:BoxDecoration(color:booking.service.color.withOpacity(.1),borderRadius:BorderRadius.circular(16)),child:Icon(booking.service.icon,color:booking.service.color,size:30)),const SizedBox(width:12),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(booking.service.name,style:const TextStyle(fontWeight:FontWeight.w900)),const SizedBox(height:4),Text('${formatDate(booking.date)} • ${booking.time}',style:const TextStyle(color:muted,fontSize:12)),const SizedBox(height:7),StatusPill(booking.status)])),const Icon(Icons.chevron_right_rounded,color:muted)])))); }
class StatusPill extends StatelessWidget { const StatusPill(this.status,{super.key}); final JobStatus status; @override Widget build(BuildContext c){Color col;String t;switch(status){case JobStatus.pending:col=Colors.orange;t='Pending';break;case JobStatus.accepted:col=Colors.blue;t='Accepted';break;case JobStatus.onTheWay:col=Colors.indigo;t='On the way';break;case JobStatus.inProgress:col=Colors.deepPurple;t='In progress';break;case JobStatus.completed:col=Colors.green;t='Completed';break;case JobStatus.cancelled:col=Colors.red;t='Cancelled';}return Container(padding:const EdgeInsets.symmetric(horizontal:9,vertical:5),decoration:BoxDecoration(color:col.withOpacity(.1),borderRadius:BorderRadius.circular(20)),child:Text(t,style:TextStyle(color:col,fontWeight:FontWeight.w800,fontSize:11)));}}

class WorkerHome extends StatelessWidget { const WorkerHome({super.key,required this.store,required this.onChanged}); final DemoStore store; final VoidCallback onChanged; @override Widget build(BuildContext c){final jobs=store.workerJobs;final active=jobs.where((b)=>b.status!=JobStatus.completed&&b.status!=JobStatus.cancelled).length;return PageFrame(title:'Worker dashboard',subtitle:'Good work starts with a good plan.',actions:[IconButton(onPressed:()=>showSnack(c,'You are online and accepting jobs.'),icon:const Icon(Icons.notifications_none_rounded))],child:ListView(padding:const EdgeInsets.fromLTRB(20,8,20,30),children:[Container(padding:const EdgeInsets.all(20),decoration:BoxDecoration(gradient:const LinearGradient(colors:[Color(0xFF0F172A),Color(0xFF334155)]),borderRadius:BorderRadius.circular(24)),child:Row(children:[const CircleAvatar(radius:28,backgroundColor:Colors.white12,child:Icon(Icons.handyman_rounded,color:Colors.white,size:28)),const SizedBox(width:14),const Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('Arsalan Khan',style:TextStyle(color:Colors.white,fontSize:20,fontWeight:FontWeight.w900)),Text('Plumber • Verified professional',style:TextStyle(color:Colors.white70))])),Container(padding:const EdgeInsets.symmetric(horizontal:10,vertical:7),decoration:BoxDecoration(color:Colors.green.withOpacity(.15),borderRadius:BorderRadius.circular(20)),child:const Text('ONLINE',style:TextStyle(color:Colors.greenAccent,fontWeight:FontWeight.w900,fontSize:11)))])),const SizedBox(height:16),GridView.count(crossAxisCount:2,shrinkWrap:true,physics:const NeverScrollableScrollPhysics(),crossAxisSpacing:10,mainAxisSpacing:10,childAspectRatio:1.65,children:[StatCard(title:'Active jobs',value:'$active',icon:Icons.work_history_rounded),StatCard(title:'Completed',value:'182',icon:Icons.task_alt_rounded),StatCard(title:'Rating',value:'4.9',icon:Icons.star_rounded),StatCard(title:'This month',value:'\$1,240',icon:Icons.payments_rounded)]),const SizedBox(height:22),const SectionTitle('Next job'),const SizedBox(height:10),if(jobs.isNotEmpty)JobCard(booking:jobs.first,onChanged:onChanged)else const EmptyState(title:'No assigned jobs',icon:Icons.work_off_rounded),const SizedBox(height:22),const SectionTitle('Quick actions'),const SizedBox(height:10),Wrap(spacing:10,runSpacing:10,children:[ActionButton(icon:Icons.toggle_on_rounded,label:'Availability',onTap:()=>showSnack(c,'Availability toggled')),ActionButton(icon:Icons.chat_rounded,label:'Message customer',onTap:()=>showSnack(c,'Opening customer chat...')),ActionButton(icon:Icons.navigation_rounded,label:'Open route',onTap:()=>showSnack(c,'Navigation demo opened'))]) ]));}}
class StatCard extends StatelessWidget { const StatCard({super.key,required this.title,required this.value,required this.icon}); final String title,value; final IconData icon; @override Widget build(BuildContext c)=>Card(child:Padding(padding:const EdgeInsets.all(14),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Icon(icon,color:primary),const Spacer(),Text(value,style:const TextStyle(fontSize:22,fontWeight:FontWeight.w900)),Text(title,style:const TextStyle(color:muted,fontSize:12))]))); }
class ActionButton extends StatelessWidget { const ActionButton({super.key,required this.icon,required this.label,required this.onTap}); final IconData icon;final String label;final VoidCallback onTap; @override Widget build(BuildContext c)=>OutlinedButton.icon(onPressed:onTap,icon:Icon(icon),label:Text(label),style:OutlinedButton.styleFrom(padding:const EdgeInsets.symmetric(horizontal:14,vertical:12))); }
class WorkerJobs extends StatelessWidget { const WorkerJobs({super.key,required this.store,required this.onChanged}); final DemoStore store; final VoidCallback onChanged; @override Widget build(BuildContext c)=>PageFrame(title:'My jobs',subtitle:'Accept, start and complete jobs',child:ListView(padding:const EdgeInsets.fromLTRB(20,8,20,30),children:store.workerJobs.map((b)=>JobCard(booking:b,onChanged:onChanged)).toList())); }
class JobCard extends StatelessWidget {
  const JobCard({super.key, required this.booking, required this.onChanged});
  final Booking booking;
  final VoidCallback onChanged;
  @override
  Widget build(BuildContext c) => Card(
    margin: const EdgeInsets.only(bottom: 12),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Expanded(child: Text(booking.service.name, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17))), StatusPill(booking.status)]),
        const SizedBox(height: 10),
        Text(booking.customer, style: const TextStyle(fontWeight: FontWeight.w700)),
        Text(booking.address, style: const TextStyle(color: muted)),
        Text('${formatDate(booking.date)} • ${booking.time}', style: const TextStyle(color: muted)),
        if (booking.notes.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 10), child: Text('Note: ${booking.notes}', style: const TextStyle(fontStyle: FontStyle.italic))),
        const SizedBox(height: 14),
        Wrap(spacing: 8, runSpacing: 8, children: [
          if (booking.status == JobStatus.pending) FilledButton.icon(onPressed: () { booking.status = JobStatus.accepted; onChanged(); }, icon: const Icon(Icons.check), label: const Text('Accept')),
          if (booking.status == JobStatus.accepted) FilledButton.icon(onPressed: () { booking.status = JobStatus.onTheWay; onChanged(); }, icon: const Icon(Icons.navigation_rounded), label: const Text('Start route')),
          if (booking.status == JobStatus.onTheWay) FilledButton.icon(onPressed: () { booking.status = JobStatus.inProgress; onChanged(); }, icon: const Icon(Icons.play_arrow_rounded), label: const Text('Start job')),
          if (booking.status == JobStatus.inProgress) FilledButton.icon(onPressed: () { booking.status = JobStatus.completed; onChanged(); }, icon: const Icon(Icons.task_alt_rounded), label: const Text('Complete')),
          OutlinedButton.icon(onPressed: () => showSnack(c, 'Customer chat opened'), icon: const Icon(Icons.chat_rounded), label: const Text('Chat')),
        ]),
      ]),
    ),
  );
}
class WorkerEarnings extends StatelessWidget {
  const WorkerEarnings({super.key, required this.store});
  final DemoStore store;
  @override
  Widget build(BuildContext c) => PageFrame(
    title: 'Earnings',
    subtitle: 'Your income at a glance',
    child: ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF16A34A), Color(0xFF15803D)]), borderRadius: BorderRadius.circular(24)),
          child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Available balance', style: TextStyle(color: Colors.white70)),
            SizedBox(height: 5),
            Text('\$2,840.50', style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w900)),
            SizedBox(height: 12),
            Text('+18.4% from last month', style: TextStyle(color: Colors.white70)),
          ]),
        ),
        const SizedBox(height: 18),
        const SectionTitle('Recent payouts'),
        const SizedBox(height: 8),
        ...['B-1031 • Electrician • \$80', 'B-1024 • Plumbing • \$65', 'B-1019 • Plumbing • \$95'].map((x) => Card(
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.payments_rounded)),
            title: Text(x),
            subtitle: const Text('Paid • Completed'),
            trailing: const Icon(Icons.check_circle, color: Colors.green),
          ),
        )),
      ],
    ),
  );
}
class WorkerProfilePage extends StatelessWidget {
  const WorkerProfilePage({super.key, required this.store});
  final DemoStore store;
  @override
  Widget build(BuildContext c) => PageFrame(
    title: 'Professional profile',
    subtitle: 'Build trust and get more jobs',
    child: ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
      children: [
        const Center(child: Column(children: [
          CircleAvatar(radius: 48, backgroundColor: Color(0xFFEFF6FF), child: Icon(Icons.handyman_rounded, size: 48, color: primary)),
          SizedBox(height: 10),
          Text('Arsalan Khan', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
          Text('Plumber • 4.9 ★', style: TextStyle(color: muted)),
        ])),
        const SizedBox(height: 22),
        SettingTile(icon: Icons.verified_rounded, title: 'Verification', subtitle: 'Identity verified', trailing: const Icon(Icons.check_circle, color: Colors.green)),
        SettingTile(icon: Icons.schedule_rounded, title: 'Availability', subtitle: 'Mon–Sat • 9 AM–8 PM', trailing: Switch(value: true, onChanged: (_) {})),
        SettingTile(icon: Icons.location_on_rounded, title: 'Service area', subtitle: 'Kohat and nearby areas', trailing: const Icon(Icons.chevron_right)),
        SettingTile(icon: Icons.photo_library_rounded, title: 'Portfolio', subtitle: '12 photos uploaded', trailing: const Icon(Icons.chevron_right)),
      ],
    ),
  );
}
class AdminHome extends StatelessWidget {
  const AdminHome({super.key, required this.store, required this.onChanged});
  final DemoStore store;
  final VoidCallback onChanged;
  @override
  Widget build(BuildContext c) => PageFrame(
    title: 'Admin overview',
    subtitle: 'Manage the HomeServe marketplace',
    actions: [IconButton(onPressed: () => showSnack(c, 'All systems operational'), icon: const Icon(Icons.notifications_none_rounded))],
    child: ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
      children: [
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.6,
          children: [
            const StatCard(title: 'Today revenue', value: '\$1,840', icon: Icons.payments_rounded),
            StatCard(title: 'Bookings', value: '${store.bookings.length + 17}', icon: Icons.receipt_long_rounded),
            StatCard(title: 'Workers', value: '${store.workers.length + 42}', icon: Icons.engineering_rounded),
            const StatCard(title: 'Customers', value: '1,284', icon: Icons.people_rounded),
          ],
        ),
        const SizedBox(height: 22),
        const SectionTitle('Marketplace health'),
        const SizedBox(height: 10),
        const Card(child: Padding(padding: EdgeInsets.all(18), child: Column(children: [
          ProgressLine(label: 'Booking success', value: .91),
          ProgressLine(label: 'Worker acceptance', value: .78),
          ProgressLine(label: 'Customer satisfaction', value: .96),
          ProgressLine(label: 'On-time arrival', value: .84),
        ]))),
        const SizedBox(height: 22),
        const SectionTitle('Pending approvals'),
        const SizedBox(height: 10),
        ...store.workers.where((w) => !w.verified).map((w) => Card(child: ListTile(
          leading: const CircleAvatar(child: Icon(Icons.person)),
          title: Text(w.name),
          subtitle: Text('${w.skill} • Verification required'),
          trailing: FilledButton(onPressed: () { w.verified = true; onChanged(); }, child: const Text('Approve')),
        ))),
      ],
    ),
  );
}
class ProgressLine extends StatelessWidget { const ProgressLine({super.key,required this.label,required this.value}); final String label; final double value; @override Widget build(BuildContext c)=>Padding(padding:const EdgeInsets.symmetric(vertical:7),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Row(children:[Expanded(child:Text(label)),Text('${(value*100).round()}%',style:const TextStyle(fontWeight:FontWeight.w900))]),const SizedBox(height:6),LinearProgressIndicator(value:value,minHeight:8,borderRadius:BorderRadius.circular(8))])); }
class AdminBookings extends StatelessWidget { const AdminBookings({super.key,required this.store,required this.onChanged}); final DemoStore store; final VoidCallback onChanged; @override Widget build(BuildContext c)=>PageFrame(title:'Booking management',subtitle:'Monitor every order',child:ListView(padding:const EdgeInsets.fromLTRB(20,8,20,30),children:store.bookings.map((b)=>Card(margin:const EdgeInsets.only(bottom:10),child:ListTile(leading:CircleAvatar(backgroundColor:b.service.color.withOpacity(.1),child:Icon(b.service.icon,color:b.service.color)),title:Text('${b.id} • ${b.service.name}',style:const TextStyle(fontWeight:FontWeight.w800)),subtitle:Text('${b.customer} • ${b.worker?.name ?? 'Unassigned'}\n${b.address}'),isThreeLine:true,trailing:PopupMenuButton<String>(onSelected:(v){if(v=='cancel')b.status=JobStatus.cancelled;if(v=='complete')b.status=JobStatus.completed;onChanged();},itemBuilder:(_)=>const [PopupMenuItem(value:'complete',child:Text('Mark completed')),PopupMenuItem(value:'cancel',child:Text('Cancel booking'))])))).toList())); }
class AdminPeople extends StatelessWidget { const AdminPeople({super.key,required this.store}); final DemoStore store; @override Widget build(BuildContext c)=>PageFrame(title:'People',subtitle:'Customers and service professionals',child:ListView(padding:const EdgeInsets.fromLTRB(20,8,20,30),children:[const SectionTitle('Professionals'),...store.workers.map((w)=>Card(child:ListTile(leading:CircleAvatar(child:Text(w.name[0])),title:Text(w.name),subtitle:Text('${w.skill} • ${w.rating} ★'),trailing:Switch(value:w.online,onChanged:(_){ })))),const SizedBox(height:18),const SectionTitle('Customers'),...['Demo Customer','Maria Khan','Usman Shah','Hira Ahmed'].map((n)=>Card(child:ListTile(leading:const CircleAvatar(child:Icon(Icons.person)),title:Text(n),subtitle:const Text('Active customer'),trailing:const Icon(Icons.chevron_right)) ))])); }
class AdminServices extends StatelessWidget { const AdminServices({super.key,required this.store}); final DemoStore store; @override Widget build(BuildContext c)=>PageFrame(title:'Service catalog',subtitle:'Manage services and pricing',child:ListView(padding:const EdgeInsets.fromLTRB(20,8,20,30),children:[FilledButton.icon(onPressed:()=>showSnack(c,'Add-service form opened'),icon:const Icon(Icons.add),label:const Text('Add new service')),const SizedBox(height:12),...store.services.map((s)=>Card(child:ListTile(leading:CircleAvatar(backgroundColor:s.color.withOpacity(.1),child:Icon(s.icon,color:s.color)),title:Text(s.name,style:const TextStyle(fontWeight:FontWeight.w800)),subtitle:Text('${s.category} • From \$${s.price.toStringAsFixed(0)}'),trailing:IconButton(onPressed:()=>showSnack(c,'Edit ${s.name}'),icon:const Icon(Icons.edit_rounded)))))])); }

class CustomerProfileDummy extends StatelessWidget { const CustomerProfileDummy({super.key}); @override Widget build(BuildContext c)=>const SizedBox(); }
class MessagesPage extends StatelessWidget { const MessagesPage({super.key}); @override Widget build(BuildContext c)=>PageFrame(title:'Messages',subtitle:'Chat with professionals and support',child:ListView(padding:const EdgeInsets.all(20),children:[MessageTile(name:'Arsalan Khan',message:'I will arrive in 20 minutes.',online:true),MessageTile(name:'HomeServe Support',message:'Your booking is confirmed.',online:false),MessageTile(name:'Ayesha Malik',message:'Thank you for the great review!',online:false)])); }
class MessageTile extends StatelessWidget {
  const MessageTile({super.key, required this.name, required this.message, required this.online});
  final String name, message;
  final bool online;
  @override
  Widget build(BuildContext c) => Card(
    child: ListTile(
      onTap: () => showChat(c, name),
      leading: Stack(children: [
        const CircleAvatar(radius: 25, child: Icon(Icons.person)),
        if (online) Positioned(
          right: 0, bottom: 0,
          child: Container(width: 13, height: 13, decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2))),
        ),
      ]),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.w800)),
      subtitle: Text(message, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: const Icon(Icons.chevron_right_rounded),
    ),
  );
}
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.role, required this.onLogout});
  final AppRole role;
  final VoidCallback onLogout;
  @override
  Widget build(BuildContext c) => PageFrame(
    title: 'Profile',
    subtitle: 'Account and preferences',
    child: ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
      children: [
        Card(child: Padding(padding: const EdgeInsets.all(18), child: Row(children: [
          const CircleAvatar(radius: 30, child: Icon(Icons.person_rounded)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(role == AppRole.admin ? 'Business Owner' : role == AppRole.worker ? 'Arsalan Khan' : 'Demo Customer', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
            Text(roleName(role), style: const TextStyle(color: muted)),
          ])),
          IconButton(onPressed: () => showSnack(c, 'Edit profile opened'), icon: const Icon(Icons.edit_rounded)),
        ]))),
        const SizedBox(height: 14),
        SettingTile(icon: Icons.notifications_rounded, title: 'Notifications', subtitle: 'Booking and message alerts', trailing: Switch(value: true, onChanged: (_) {})),
        SettingTile(icon: Icons.lock_rounded, title: 'Security', subtitle: 'Password, PIN and login devices', trailing: const Icon(Icons.chevron_right)),
        SettingTile(icon: Icons.help_center_rounded, title: 'Help & support', subtitle: 'FAQs and contact support', trailing: const Icon(Icons.chevron_right)),
        SettingTile(icon: Icons.info_outline_rounded, title: 'About', subtitle: 'HomeServe Pro v2.0 demo', trailing: const Icon(Icons.chevron_right)),
        const SizedBox(height: 18),
        OutlinedButton.icon(onPressed: onLogout, icon: const Icon(Icons.logout_rounded), label: const Text('Sign out')),
      ],
    ),
  );
}
class SettingTile extends StatelessWidget { const SettingTile({super.key,required this.icon,required this.title,required this.subtitle,required this.trailing}); final IconData icon;final String title,subtitle;final Widget trailing; @override Widget build(BuildContext c)=>Card(child:ListTile(leading:CircleAvatar(backgroundColor:primary.withOpacity(.08),child:Icon(icon,color:primary)),title:Text(title,style:const TextStyle(fontWeight:FontWeight.w800)),subtitle:Text(subtitle),trailing:trailing)); }
class EmptyState extends StatelessWidget { const EmptyState({super.key,required this.title,required this.icon}); final String title;final IconData icon; @override Widget build(BuildContext c)=>Center(child:Padding(padding:const EdgeInsets.all(50),child:Column(mainAxisSize:MainAxisSize.min,children:[Icon(icon,size:64,color:primary.withOpacity(.25)),const SizedBox(height:12),Text(title,style:const TextStyle(fontWeight:FontWeight.w800,color:muted))]))); }

class WorkerTile extends StatelessWidget { const WorkerTile({super.key,required this.worker,required this.onTap}); final WorkerProfile worker;final VoidCallback onTap; @override Widget build(BuildContext c)=>Card(margin:const EdgeInsets.only(bottom:10),child:ListTile(onTap:onTap,leading:CircleAvatar(radius:25,backgroundColor:primary.withOpacity(.1),child:Text(worker.name[0],style:const TextStyle(color:primary,fontWeight:FontWeight.w900))),title:Row(children:[Text(worker.name,style:const TextStyle(fontWeight:FontWeight.w900)),if(worker.verified)const Icon(Icons.verified,color:Colors.blue,size:16)]),subtitle:Text('${worker.skill} • ${worker.jobs} jobs'),trailing:Column(mainAxisAlignment:MainAxisAlignment.center,children:[const Icon(Icons.star,color:Colors.amber,size:18),Text(worker.rating.toStringAsFixed(1),style:const TextStyle(fontWeight:FontWeight.w800))]))); }

void showWorkerSheet(BuildContext c, WorkerProfile w) {
  showModalBottomSheet(
    context: c,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
    builder: (_) => Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 30),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        CircleAvatar(radius: 38, child: Text(w.name[0], style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900))),
        const SizedBox(height: 10),
        Text(w.name, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w900)),
        Text('${w.skill} • ${w.rating} ★ • ${w.jobs} jobs', style: const TextStyle(color: muted)),
        const SizedBox(height: 18),
        Row(children: [
          Expanded(child: ActionButton(icon: Icons.chat_rounded, label: 'Message', onTap: () => showChat(c, w.name))),
          const SizedBox(width: 10),
          Expanded(child: FilledButton.icon(onPressed: () => Navigator.pop(c), icon: const Icon(Icons.check), label: const Text('Select'))),
        ]),
      ]),
    ),
  );
}

void showBookingSheet(BuildContext c, Booking b, VoidCallback changed) {
  showModalBottomSheet(
    context: c,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
    builder: (_) => Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 30),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(b.service.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
        const SizedBox(height: 10),
        StatusPill(b.status),
        const SizedBox(height: 16),
        SummaryCard(rows: {'Booking ID': b.id, 'Date': formatDate(b.date), 'Time': b.time, 'Worker': b.worker?.name ?? 'Finding match', 'Address': b.address, 'Total': '\$${b.total.toStringAsFixed(2)}'}),
        const SizedBox(height: 14),
        if (b.status != JobStatus.completed && b.status != JobStatus.cancelled)
          FilledButton.icon(onPressed: () { b.status = JobStatus.onTheWay; changed(); Navigator.pop(c); showSnack(c, 'Live tracking started'); }, icon: const Icon(Icons.location_searching_rounded), label: const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Text('Track service'))),
      ]),
    ),
  );
}

void showChat(BuildContext c, String name) {
  final controller = TextEditingController();
  showModalBottomSheet(
    context: c,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
    builder: (_) => Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.viewInsetsOf(c).bottom + 20),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
        const SizedBox(height: 12),
        const Card(child: Padding(padding: EdgeInsets.all(14), child: Text('Hi! How can we help you today?'))),
        const SizedBox(height: 10),
        TextField(controller: controller, decoration: InputDecoration(hintText: 'Type a message', suffixIcon: IconButton(onPressed: () { controller.clear(); showSnack(c, 'Message sent'); }, icon: const Icon(Icons.send_rounded)))),
      ]),
    ),
  );
  // The controller belongs to this short-lived sheet.
}
void showSnack(BuildContext c,String message)=>ScaffoldMessenger.of(c)..hideCurrentSnackBar()..showSnackBar(SnackBar(content:Text(message),behavior:SnackBarBehavior.floating));
String formatDate(DateTime d)=>'${d.day.toString().padLeft(2,'0')}/${d.month.toString().padLeft(2,'0')}/${d.year}';
