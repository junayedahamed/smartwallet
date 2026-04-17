import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartwallet/database/database.dart';
import 'package:smartwallet/pages/balance_controller.dart';

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
                          "Welcome to SmartWallet",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Set your starting values once. You can update your tracking anytime.",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: balanceController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6),
                          ],
                          validator: _validateBalance,
                          decoration: InputDecoration(
                            labelText: "Initial balance",
                            helperText:
                                "Whole number only • max ${WalletDb.maxTransactionAmount}",
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
                          decoration: const InputDecoration(
                            labelText: "Daily need",
                            helperText: "Must be greater than 0",
                            prefixIcon: Icon(Icons.calendar_today_rounded),
                          ),
                        ),
                        const SizedBox(height: 20),
                        FilledButton.icon(
                          onPressed: _submitSetup,
                          icon: const Icon(Icons.trending_up_rounded),
                          label: const Text("Start Tracking"),
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
      return "Please add your starting balance";
    }

    final parsed = int.tryParse(value);
    if (parsed == null) {
      return "Balance must be a whole number";
    }
    if (parsed < 0) {
      return "Balance cannot be negative";
    }
    if (parsed > WalletDb.maxTransactionAmount) {
      return "Maximum balance is ${WalletDb.maxTransactionAmount}";
    }
    return null;
  }

  String? _validateDailyNeed(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please add your daily need";
    }

    final parsed = int.tryParse(value);
    if (parsed == null) {
      return "Daily need must be a whole number";
    }
    if (parsed <= 0) {
      return "Daily need must be greater than 0";
    }
    if (parsed > WalletDb.maxTransactionAmount) {
      return "Please enter a realistic daily value";
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
