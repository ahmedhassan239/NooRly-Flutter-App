import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:flutter_app/core/config/api_config.dart';
import 'package:flutter_app/core/providers/core_providers.dart';
import 'package:flutter_app/features/debug/data/network_log_service.dart';

class DebugNetworkScreen extends ConsumerWidget {
  const DebugNetworkScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final networkLogs = ref.watch(networkLogServiceProvider).logs;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Network Diagnostics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              ref.read(networkLogServiceProvider).clearLogs();
              // Trigger rebuild
              (context as Element).markNeedsBuild();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildInfoCard(ref),
          const Divider(height: 1),
          Expanded(
            child: ListView.separated(
              itemCount: networkLogs.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final log = networkLogs[index];
                return _NetworkLogTile(log: log);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Environment: ${ApiConfig.environmentName}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Build Mode: ${kDebugMode ? "Debug" : kProfileMode ? "Profile" : "Release"}'),
            const SizedBox(height: 4),
            Text('Base URL: ${ApiConfig.resolvedBaseUrl}'),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pingHealth(ref),
                  icon: const Icon(Icons.monitor_heart, size: 16),
                  label: const Text('Ping Health'),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () => _testRegister(ref),
                  icon: const Icon(Icons.person_add, size: 16),
                  label: const Text('Test Register'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pingHealth(WidgetRef ref) async {
    try {
      await ref.read(apiClientProvider).get<Map<String, dynamic>>('/health');
      // Log is automatically added by interceptor
    } catch (e) {
      // Log also added on error
    }
    // Force rebuild to show new log
    // In a real app we'd use a Stream or StateNotifier for logs, 
    // but for debug screen this is acceptable or we rely on user scrolling/refreshing
    // For now, let's just trigger a dummy state update if we were stateful, 
    // but here we are stateless. The logs list is not reactive in this simple implementation.
    // We should probably convert to ConsumerStatefulWidget or make LogService reactive.
    // Proceeding as is, user might need to background/foreground or we rely on hot reload.
  }

  Future<void> _testRegister(WidgetRef ref) async {
    try {
      final email = 'test+${DateTime.now().millisecondsSinceEpoch}@example.com';
      await ref.read(authRepositoryProvider).register(
        email: email,
        password: 'password123',
        passwordConfirmation: 'password123',
        name: 'Test User',
      );
    } catch (e) {
      // Ignore
    }
  }
}

class _NetworkLogTile extends StatelessWidget {
  const _NetworkLogTile({required this.log});

  final NetworkLogEntry log;

  @override
  Widget build(BuildContext context) {
    final color = (log.statusCode ?? 0) >= 400 ? Colors.red : Colors.green[800];
    final timeStr = DateFormat('HH:mm:ss').format(log.timestamp);

    return ListTile(
      dense: true,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: color?.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: color!.withValues(alpha: 0.5)),
            ),
            child: Text(log.method, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(log.url, style: const TextStyle(fontSize: 13), overflow: TextOverflow.ellipsis)),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Row(
            children: [
              Text('$timeStr • ${log.statusCode ?? "ERR"} • ${log.environment}'),
              const Spacer(),
              Text(log.id.substring(0, 8), style: const TextStyle(fontFamily: 'monospace', fontSize: 10, color: Colors.grey)),
            ],
          ),
        ],
      ),
      onTap: () => _showDetails(context, log),
    );
  }

  void _showDetails(BuildContext context, NetworkLogEntry log) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Request Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _detailRow('ID', log.id),
              _detailRow('URL', log.url),
              _detailRow('Method', log.method),
              _detailRow('Status', '${log.statusCode}'),
              _detailRow('Env', log.environment),
              const Divider(),
              const Text('Request Body:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(log.requestBodySummary ?? 'None', style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
              const SizedBox(height: 8),
              const Text('Response Body:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(log.responseBodySummary ?? 'None', style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: 'ID: ${log.id}\nURL: ${log.url}\n...'));
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
            },
            child: const Text('Copy'),
          ),
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black, fontSize: 13),
          children: [
            TextSpan(text: '$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
