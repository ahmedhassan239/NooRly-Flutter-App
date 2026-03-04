import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_app/core/api/api_client.dart';
import 'package:flutter_app/core/auth/token_storage.dart';
import 'package:flutter_app/core/providers/core_providers.dart';
import 'package:flutter_app/core/config/endpoints.dart';
import 'package:flutter_app/features/auth/providers/auth_provider.dart';

class DebugAuthScreen extends ConsumerWidget {
  const DebugAuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    
    return Scaffold(
      appBar: AppBar(title: const Text('Debug Auth')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('Auth State'),
          Text('Is Authenticated: ${authState.isAuthenticated}'),
          Text('Is Guest: ${authState.isGuest}'),
          Text('Is Loading: ${authState.isLoading}'),
          if (authState.errorMessage != null)
            Text('Error: ${authState.errorMessage}', style: const TextStyle(color: Colors.red)),
            
          const Divider(),
          _buildSectionTitle('Current User'),
          if (user != null) ...[
            Text('ID: ${user.id}'),
            Text('Name: ${user.name}'),
            Text('Email: ${user.email}'),
          ] else
            const Text('No User'),

          const Divider(),
          _buildSectionTitle('Actions'),
          ElevatedButton.icon(
            onPressed: () => context.push('/auth/debug/network'), 
            icon: const Icon(Icons.network_check),
            label: const Text('Open Network Diagnostics / Prod Safety'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, foregroundColor: Colors.white),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () async {
              try {
                final client = ref.read(apiClientProvider);
                final response = await client.get<Map<String, dynamic>>('/health');
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Health Check: ${response.status ? "OK" : "Failed"}')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Health Check Error: $e'), backgroundColor: Colors.red),
                  );
                }
              }
            }, 
            child: const Text('Check API Health (/health)'),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () async {
              try {
                final client = ref.read(apiClientProvider);
                final response = await client.get<Map<String, dynamic>>(AuthEndpoints.me);
                if (context.mounted) {
                   ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Me Check: ${response.status ? "OK" : "Failed"} ${response.data}')),
                  );
                }
              } catch (e) {
                 if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Me Check Error: $e'), backgroundColor: Colors.red),
                  );
                }
              }
            },
            child: const Text('Call /auth/me'),
          ),
           const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
                ref.read(authProvider.notifier).logout();
            }, 
            child: const Text('Logout'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
          ),
          
          const Divider(),
          _buildSectionTitle('Token Storage'),
          FutureBuilder<String?>(
            future: ref.read(tokenStorageProvider).getAccessToken(),
            builder: (context, snapshot) {
               return Text('Access Token: ${snapshot.data != null ? "${snapshot.data!.substring(0, 10)}..." : "None"}');
            }
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
    );
  }
}
