import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Orders'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Active'),
              Tab(text: 'Completed'),
              Tab(text: 'Cancelled'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Active Orders
            _buildEmptyState(
              icon: Icons.local_shipping_outlined,
              title: 'No Active Orders',
              subtitle: 'Your active orders will appear here',
            ),
            // Completed Orders
            _buildEmptyState(
              icon: Icons.check_circle_outline,
              title: 'No Order History',
              subtitle: 'Your completed orders will appear here',
            ),
            // Cancelled Orders
            _buildEmptyState(
              icon: Icons.cancel_outlined,
              title: 'No Cancelled Orders',
              subtitle: 'Your cancelled orders will appear here',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // TODO: Navigate to explore
            },
            child: const Text('Browse Products'),
          ),
        ],
      ),
    );
  }
}
