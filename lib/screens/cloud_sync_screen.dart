import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import '../providers/cloud_sync_provider.dart';
import '../l10n/app_localizations.dart';

class CloudSyncScreen extends ConsumerWidget {
  const CloudSyncScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CloudSyncState syncState = ref.watch(cloudSyncProvider);
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    // Listen for state changes to show SnackBar
    ref.listen<CloudSyncState>(cloudSyncProvider, (previous, next) {
      if (next.status == SyncStatus.success) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.syncSuccess)));
      } else if (next.status == SyncStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.syncError(next.errorMessage ?? 'Unknown')),
          ),
        );
      } else if (next.status == SyncStatus.noConnection) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.noInternet)));
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(l10n.cloudSync)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: Lottie.asset('assets/lottie/privacy.json', repeat: true),
            ),
            const SizedBox(height: 40),
            Text(
              l10n.cloudSync,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.privacyDescription,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 48),
            if (syncState.userEmail == null)
              _buildUnauthenticatedState(context, ref, l10n)
            else
              _buildAuthenticatedState(context, ref, l10n, syncState, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildUnauthenticatedState(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: () => ref.read(cloudSyncProvider.notifier).signIn(),
        icon: const Icon(Icons.login),
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(l10n.signInWithGoogle),
        ),
      ),
    );
  }

  Widget _buildAuthenticatedState(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    CloudSyncState state,
    ThemeData theme,
  ) {
    final lastSyncedStr = state.lastSynced != null
        ? DateFormat.yMMMd().add_jm().format(state.lastSynced!)
        : '---';

    return Column(
      children: [
        Card(
          elevation: 0,
          color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: theme.colorScheme.outlineVariant),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Icon(
                    Icons.person,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.userEmail!,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        l10n.lastSynced(lastSyncedStr),
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: state.status == SyncStatus.syncing
                ? null
                : () => ref.read(cloudSyncProvider.notifier).syncNow(),
            icon: state.status == SyncStatus.syncing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.sync),
            label: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                state.status == SyncStatus.syncing
                    ? l10n.syncing
                    : l10n.syncNow,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextButton.icon(
          onPressed: () => ref.read(cloudSyncProvider.notifier).signOut(),
          icon: const Icon(Icons.logout),
          label: Text(l10n.signOut),
          style: TextButton.styleFrom(foregroundColor: theme.colorScheme.error),
        ),
      ],
    );
  }
}
