import 'package:flutter/material.dart';

import '../../../../theme/tokens.dart';

/// Renders the end-to-end NatHealth system architecture topology diagram,
/// highlighting NFC Hardware, Native Kotlin APDU Channel, Flutter UI,
/// background WorkManager offline queue & SQLite cache, and TPA Backend.
class NfcArchitectureDiagram extends StatelessWidget {
  final bool isDesktop;
  final bool isDark;

  const NfcArchitectureDiagram({
    super.key,
    required this.isDesktop,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(isDesktop ? 16 : 12),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: isDark ? 0.05 : 0.02),
        borderRadius: BorderRadius.circular(AppRadius.smd),
        border: Border.all(color: scheme.primary.withValues(alpha: isDark ? 0.15 : 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.account_tree_rounded, size: 12, color: scheme.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'SYSTEM ARCHITECTURE TOPOLOGY',
                  style: TextStyle(
                    fontFamily: 'Courier',
                    color: scheme.primary,
                    fontSize: isDesktop ? 10.0 : 9.0,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildArchNode('NFC Hardware\n(ISO-7816)', Icons.nfc_rounded, scheme),
                _buildArchArrow(scheme),
                _buildArchNode('Native Kotlin\nAPDU Channel', Icons.android_rounded, scheme),
                _buildArchArrow(scheme),
                _buildArchNode('Flutter UI\n(Clean Arch)', Icons.layers_rounded, scheme),
                _buildArchArrow(scheme),
                Column(
                  children: [
                    _buildArchNode('WorkManager\n(Offline Queue)', Icons.sync_rounded, scheme),
                    const SizedBox(height: 6),
                    _buildArchNode('SQLite DB\n(Encrypted Cache)', Icons.storage_rounded, scheme),
                  ],
                ),
                _buildArchArrow(scheme),
                _buildArchNode('TPA Backend\n(REST API)', Icons.cloud_done_rounded, scheme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArchNode(String label, IconData icon, ColorScheme scheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? Colors.black45 : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: scheme.primary.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: scheme.primary),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 8.5,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white70 : AppColors.slate700,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArchArrow(ColorScheme scheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Icon(
        Icons.arrow_right_alt_rounded,
        size: 16,
        color: scheme.primary.withValues(alpha: 0.5),
      ),
    );
  }
}
