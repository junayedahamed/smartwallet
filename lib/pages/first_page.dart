import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartwallet/database/database.dart';
import 'package:smartwallet/pages/balance_controller.dart';
import 'package:smartwallet/setting/setting_controller.dart';
import 'package:smartwallet/l10n/l10n.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController balanceController = TextEditingController();
  final TextEditingController dayController = TextEditingController();

  @override
  void dispose() {
    balanceController.dispose();
    dayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            "assets/animated/intro2.gif",
                            height: 180,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          L10n.tr(context, "welcome"),
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          L10n.tr(context, "set_starting_values"),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        // Currency Dropdown
                        AnimatedBuilder(
                            animation: SettingsController.instance,
                            builder: (context, _) {
                              return DropdownButtonFormField<String>(
                                key: ValueKey(
                                    SettingsController.instance.currency),
                                initialValue:
                                    SettingsController.instance.currency,
                                decoration: InputDecoration(
                                  labelText: L10n.tr(context, "currency"),
                                  prefixIcon:
                                      const Icon(Icons.monetization_on_rounded),
                                ),
                                items: const [
                                  DropdownMenuItem(
                                      value: "৳",
                                      child: Text("BDT (৳) - Taka")),
                                  DropdownMenuItem(
                                      value: "\$",
                                      child: Text("USD (\$) - Dollar")),
                                ],
                                onChanged: (val) {
                                  if (val != null) {
                                    SettingsController.instance
                                        .setCurrency(val);
                                  }
                                },
                              );
                            }),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: balanceController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6),
                          ],
                          validator: _validateBalance,
                          decoration: InputDecoration(
                            labelText: L10n.tr(context, "initial_balance"),
                            helperText:
                                "${L10n.tr(context, 'whole_number_max')} ${WalletDb.maxTransactionAmount}",
                            prefixIcon:
                                const Icon(Icons.account_balance_wallet),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: dayController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6),
                          ],
                          validator: _validateDailyNeed,
                          decoration: InputDecoration(
                            labelText: L10n.tr(context, "daily_need"),
                            helperText: L10n.tr(context, "greater_than_0"),
                            prefixIcon:
                                const Icon(Icons.calendar_today_rounded),
                          ),
                        ),
                        const SizedBox(height: 20),
                        FilledButton.icon(
                          onPressed: _submitSetup,
                          icon: const Icon(Icons.trending_up_rounded),
                          label: Text(L10n.tr(context, "start_tracking")),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? _validateBalance(String? value) {
    if (value == null || value.trim().isEmpty) {
      return L10n.tr(context, "add_initial_balance");
    }

    final parsed = int.tryParse(value);
    if (parsed == null) {
      return L10n.tr(context, "balance_whole_number");
    }
    if (parsed < 0) {
      return L10n.tr(context, "balance_not_negative");
    }
    if (parsed > WalletDb.maxTransactionAmount) {
      return "${L10n.tr(context, 'max_balance_is')} ${WalletDb.maxTransactionAmount}";
    }
    return null;
  }

  String? _validateDailyNeed(String? value) {
    if (value == null || value.trim().isEmpty) {
      return L10n.tr(context, "add_daily_need");
    }

    final parsed = int.tryParse(value);
    if (parsed == null) {
      return L10n.tr(context, "balance_whole_number");
    }
    if (parsed <= 0) {
      return L10n.tr(context, "greater_than_0");
    }
    if (parsed > WalletDb.maxTransactionAmount) {
      return "${L10n.tr(context, 'max_balance_is')} ${WalletDb.maxTransactionAmount}";
    }
    return null;
  }

  void _submitSetup() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final initialBalance = int.parse(balanceController.text.trim());
    final perDayNeed = int.parse(dayController.text.trim());

    final success = WalletDb.instance.addMoney(
      Money(
        initialBalance.toDouble(),
        reason: "Initial balance",
      ),
    );
    if (!success) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              "Initial balance must be at most ${WalletDb.maxTransactionAmount}.",
            ),
          ),
        );
      return;
    }

    BalanceController.instance.setPerDay(perDayNeed);
    FocusScope.of(context).unfocus();
  }
}
