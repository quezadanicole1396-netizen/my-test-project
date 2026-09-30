import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../categories/categories_screen.dart';
import '../products/products_screen.dart';
import '../users/users_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  final _pages = const [
    _DashboardPage(),
    UsersScreen(),
    CategoriesScreen(),
    ProductsScreen(),
  ];

  final _titles = const ['Cozy Shop', 'Users', 'Categories', 'Products'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_index],
            style: const TextStyle(fontWeight: FontWeight.w800)),
        backgroundColor: Colors.transparent,
        actions: [
          if (_index == 0)
            IconButton(
              tooltip: 'Logout',
              onPressed: () => _confirmLogout(context),
              icon: const Icon(Icons.logout_rounded),
            ),
        ],
      ),
      body: _pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.people_outline), label: 'Users'),
          NavigationDestination(
              icon: Icon(Icons.category_outlined), label: 'Categories'),
          NavigationDestination(
              icon: Icon(Icons.inventory_2_outlined), label: 'Products'),
        ],
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Leave the shop?'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Logout')),
        ],
      ),
    );

    if (shouldLogout == true) await AuthService().logout();
  }
}

class _DashboardPage extends StatelessWidget {
  const _DashboardPage();

  Stream<int> _count(String collection) {
    return FirebaseFirestore.instance
        .collection(collection)
        .snapshots()
        .map((snapshot) => snapshot.size);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFF2D4BE),
              borderRadius: BorderRadius.circular(28),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hello, shopkeeper ☕',
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.w800)),
                SizedBox(height: 8),
                Text(
                  'Keep your little shop organized, warm, and welcoming.',
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const Text('Your shop at a glance',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: 'Users',
                  icon: Icons.people_outline,
                  stream: _count('users'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  title: 'Categories',
                  icon: Icons.category_outlined,
                  stream: _count('categories'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _StatCard(
            title: 'Products',
            icon: Icons.inventory_2_outlined,
            stream: _count('products'),
            wide: true,
          ),
          const SizedBox(height: 22),
          const Text('Everything you need',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          const _TipCard(
            icon: Icons.auto_awesome_outlined,
            title: 'Keep it cozy',
            text: 'Add friendly product images and descriptions for a warmer shop experience.',
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Stream<int> stream;
  final bool wide;

  const _StatCard({
    required this.title,
    required this.icon,
    required this.stream,
    this.wide = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: StreamBuilder<int>(
          stream: stream,
          builder: (_, snapshot) {
            return Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFFF2E3D5),
                  child: Icon(icon, color: const Color(0xFF9A6848)),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title),
                    Text(
                      '${snapshot.data ?? 0}',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;

  const _TipCard({
    required this.icon,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFEAF1E6),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(icon, color: const Color(0xFF62825B)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(text),
        ),
      ),
    );
  }
}
