import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartwallet/database/database.dart';
import 'package:smartwallet/pages/balance_controller.dart';
import 'package:smartwallet/setting/setting_controller.dart';
import 'package:smartwallet/utils/double_formatter.dart';
import 'package:smartwallet/l10n/l10n.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String emojiResponse() {
    double balance = WalletDb.instance.totalAmount();
    int day = BalanceController.instance.perDayNeed;
    if (day <= 0) {
      day = 1;
    }

    if ((balance / day) <= 2) {
      return "assets/twoday.gif";
    } else if ((balance / day) > 2 && (balance / day) <= 5) {
      return "assets/lt5d.gif";
    } else if ((balance / day) > 5 && (balance / day) <= 10) {
      return "assets/lt7d.gif";
    } else if ((balance / day) > 10 && (balance / day) <= 20) {
      return "assets/mt10d.gif";
    } else {
      return "assets/mt20d.gif";
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return StreamBuilder(
      stream: WalletDb.instance.snapshot(),
      builder: (context, snapshot) {
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      height: 140,
                      width: 140,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorScheme.primaryContainer,
                      ),
                      child: ClipOval(
                        child: Image(
                          image: AssetImage(emojiResponse())..evict(),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      L10n.tr(context, "financial_overview"),
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      L10n.tr(context, "wallet_health"),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final cardWidth = constraints.maxWidth > 520
                    ? (constraints.maxWidth - 12) / 2
                    : constraints.maxWidth;

                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    SizedBox(
                      width: cardWidth,
                      child: _SummaryCard(
                        icon: Icons.south_west_rounded,
                        title: L10n.tr(context, "total_added"),
                        color: colorScheme.primaryContainer,
                        child: FutureBuilder<double>(
                          future: WalletDb.instance.lifeTimeEntity(),
                          builder: (context, snapshot) {
                            return Text(
                              (snapshot.data != null)
                                  ? doubleFormatter(snapshot.data!)
                                  : "--",
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: cardWidth,
                      child: _SummaryCard(
                        icon: Icons.north_east_rounded,
                        title: L10n.tr(context, "total_used"),
                        color: colorScheme.errorContainer,
                        child: FutureBuilder<double>(
                          future: WalletDb.instance.lifeTimeUse(),
                          builder: (context, snapshot) {
                            return Text(
                              (snapshot.data != null)
                                  ? doubleFormatter(snapshot.data!)
                                  : "--",
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      L10n.tr(context, "actions"),
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    AnimatedBuilder(
                      animation: SettingsController.instance,
                      builder: (context, _) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    key: ValueKey(SettingsController.instance.locale),
                                    initialValue: SettingsController.instance.locale,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                      prefixIcon: const Icon(Icons.language_rounded, size: 20),
                                    ),
                                    items: const [
                                      DropdownMenuItem(value: "en", child: Text("English")),
                                      DropdownMenuItem(value: "bn", child: Text("বাংলা")),
                                    ],
                                    onChanged: (val) {
                                      if (val != null) SettingsController.instance.setLocale(val);
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    key: ValueKey(SettingsController.instance.currency),
                                    initialValue: SettingsController.instance.currency,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                      prefixIcon: const Icon(Icons.monetization_on_rounded, size: 20),
                                    ),
                                    items: const [
                                      DropdownMenuItem(value: "৳", child: Text("BDT (৳)")),
                                      DropdownMenuItem(value: "\$", child: Text("USD (\$)")),
                                    ],
                                    onChanged: (val) {
                                      if (val != null) SettingsController.instance.setCurrency(val);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.tonalIcon(
                            onPressed: () => _showConfirmationDialog(context),
                            icon: const Icon(Icons.delete_sweep_outlined),
                            label: Text(L10n.tr(context, "reset_all")),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AnimatedBuilder(
                            animation: SettingsController.instance,
                            builder: (context, snapshot) {
                              final brightness = Theme.of(context).brightness;
                              final isLight = brightness == Brightness.light;

                              return OutlinedButton.icon(
                                onPressed: () {
                                  SettingsController.instance.setThemeMode(
                                    isLight ? ThemeMode.dark : ThemeMode.light,
                                  );
                                },
                                icon: Icon(
                                  isLight
                                      ? Icons.dark_mode_outlined
                                      : Icons.light_mode_outlined,
                                ),
                                label:
                                    Text(isLight ? L10n.tr(context, "dark_mode") : L10n.tr(context, "light_mode")),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(L10n.tr(context, "confirm_reset")),
          content: Text(L10n.tr(context, "confirm_reset_desc")),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(L10n.tr(context, "cancel")),
            ),
            TextButton(
              onPressed: () async {
                final SharedPreferences pref =
                    await SharedPreferences.getInstance();
                WalletDb.instance.resetDb();
                pref.setDouble("life_time_use", 0);
                pref.setDouble("life_time_entry", 0);
                if (!context.mounted) {
                  return;
                }
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(L10n.tr(context, "reset")),
            ),
          ],
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.child,
  });

  final IconData icon;
  final String title;
  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon),
            const SizedBox(height: 10),
            Text(
              title,
              style: theme.textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}
