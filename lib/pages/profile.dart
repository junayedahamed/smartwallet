import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartwallet/database/database.dart';
import 'package:smartwallet/pages/balance_controller.dart';
import 'package:smartwallet/setting/setting_controller.dart';
import 'package:smartwallet/utils/double_formatter.dart';

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
                      "Financial overview",
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "A quick summary of your wallet health.",
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
                        title: "Total Added",
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
                        title: "Total Used",
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
                      "Actions",
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.tonalIcon(
                            onPressed: () => _showConfirmationDialog(context),
                            icon: const Icon(Icons.delete_sweep_outlined),
                            label: const Text("Reset all"),
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
                                    Text(isLight ? "Dark mode" : "Light mode"),
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
          title: const Text("Confirm Reset"),
          content: const Text(
              "Are you sure you want to reset the database? This action cannot be undone."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
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
              child: const Text("Reset"),
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
