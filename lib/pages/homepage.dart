import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:smartwallet/database/database.dart';
import 'package:smartwallet/pages/balance_controller.dart';
import 'package:smartwallet/pages/history.dart';
import 'package:smartwallet/pages/profile.dart';
import 'package:smartwallet/utils/double_formatter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentTab = 0;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();

  @override
  void dispose() {
    amountController.dispose();
    reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: IndexedStack(
        index: currentTab,
        children: [
          _buildHomeTab(context),
          const HistoryPage(),
          const ProfilePage(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
        child: GNav(
          selectedIndex: currentTab,
          gap: 8,
          onTabChange: (value) {
            setState(() {
              currentTab = value;
            });
          },
          tabs: const [
            GButton(
              icon: Icons.home_rounded,
              text: "Home",
            ),
            GButton(
              icon: Icons.history,
              text: "History",
            ),
            GButton(
              icon: Icons.person_rounded,
              text: "Profile",
            ),
          ],
        ),
      ),
      floatingActionButton: (currentTab == 1)
          ? FloatingActionButton.extended(
              onPressed: () => WalletDb.instance
                  .exportHistoryToPdf(ScaffoldMessenger.of(context), context),
              icon: const Icon(Icons.picture_as_pdf_rounded),
              label: const Text("Export PDF"),
            )
          : null,
    );
  }

  AppBar? _buildAppBar() {
    if (currentTab == 1) {
      return AppBar(title: const Text("History"));
    }
    if (currentTab == 2) {
      return AppBar(title: const Text("Profile"));
    }
    return null;
  }

  Widget _buildHomeTab(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: StreamBuilder(
        stream: WalletDb.instance.snapshot(),
        builder: (context, snapshot) {
          final transactions = WalletDb.instance.getMoneyList();
          final recentTransactions = transactions.reversed.take(3).toList();

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
            children: [
              _buildBalanceCard(theme),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Add a transaction",
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: reasonController,
                          textInputAction: TextInputAction.next,
                          maxLength: 60,
                          decoration: const InputDecoration(
                            labelText: "Reason (optional)",
                            hintText: "Groceries, Salary, Rent...",
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6),
                          ],
                          validator: _amountValidator,
                          decoration: InputDecoration(
                            labelText: "Amount",
                            hintText: "0",
                            helperText:
                                "Whole number only • max ${WalletDb.maxTransactionAmount}",
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: FilledButton.icon(
                                onPressed: () => _submitTransaction(
                                  isAddition: false,
                                ),
                                icon: const Icon(Icons.remove_circle_rounded, size: 24),
                                label: const Text(
                                  "Use",
                                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                                ),
                                style: FilledButton.styleFrom(
                                  backgroundColor: theme.colorScheme.errorContainer,
                                  foregroundColor: theme.colorScheme.onErrorContainer,
                                  padding: const EdgeInsets.symmetric(vertical: 24),
                                  shape: const StadiumBorder(), // Perfect expressive pill shape
                                  elevation: 0,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: FilledButton.icon(
                                onPressed: () => _submitTransaction(
                                  isAddition: true,
                                ),
                                icon: const Icon(Icons.add_circle_rounded, size: 24),
                                label: const Text(
                                  "Add",
                                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                                ),
                                style: FilledButton.styleFrom(
                                  backgroundColor: theme.colorScheme.primary,
                                  foregroundColor: theme.colorScheme.onPrimary,
                                  padding: const EdgeInsets.symmetric(vertical: 24),
                                  shape: const StadiumBorder(), // Perfect expressive pill shape
                                  elevation: 0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (recentTransactions.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      "No transactions yet. Add your first entry above.",
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                )
              else
                Card(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Text(
                            "Recent transactions",
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                        const SizedBox(height: 8),
                        for (int i = 0; i < recentTransactions.length; i++)
                          HistoryListTile(
                            money: recentTransactions[i],
                            balance: doubleFormatter(
                              WalletDb.instance
                                  .balanceAtIndex(transactions.length - i - 1),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBalanceCard(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    final balance = WalletDb.instance.totalAmount();
    final daysLeft = BalanceController.instance.dayLeft();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer, // Solid expressive color, no gradient
        borderRadius: BorderRadius.circular(44), // Massive expressive squircle
      ),
      child: Stack(
        children: [
          // Background Decorative Circle in expressive soft transparent 
          Positioned(
            right: -20,
            top: -40,
            child: CircleAvatar(
              radius: 90,
              backgroundColor: colorScheme.onPrimaryContainer.withValues(alpha: 0.05),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Wallet Balance",
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Icon(
                      Icons.account_balance_wallet_rounded, 
                      color: colorScheme.onPrimaryContainer, 
                      size: 28,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    doubleFormatter(balance),
                    style: theme.textTheme.displayMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  decoration: BoxDecoration(
                    color: colorScheme.onPrimaryContainer.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(24), // Expressive inner pill
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.timer_rounded, color: colorScheme.onPrimaryContainer, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        "Est. $daysLeft days remaining",
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String? _amountValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Enter an amount";
    }

    final parsedAmount = int.tryParse(value);
    if (parsedAmount == null) {
      return "Amount must be a whole number";
    }
    if (parsedAmount <= 0) {
      return "Amount must be greater than 0";
    }
    if (parsedAmount > WalletDb.maxTransactionAmount) {
      return "Maximum amount is ${WalletDb.maxTransactionAmount}";
    }

    return null;
  }

  void _submitTransaction({required bool isAddition}) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final parsedAmount = int.parse(amountController.text.trim());
    final currentBalance = WalletDb.instance.totalAmount();
    if (!isAddition && parsedAmount > currentBalance) {
      _showMessage("Not enough balance for this transaction.");
      return;
    }

    final trimmedReason = reasonController.text.trim();
    final fallbackReason = isAddition ? "Money added" : "Money used";
    final success = WalletDb.instance.addMoney(
      Money(
        isAddition ? parsedAmount.toDouble() : -parsedAmount.toDouble(),
        reason: trimmedReason.isEmpty ? fallbackReason : trimmedReason,
      ),
    );

    if (!success) {
      _showMessage(
          "Amount must be between 1 and ${WalletDb.maxTransactionAmount}.");
      return;
    }

    amountController.clear();
    reasonController.clear();
    FocusScope.of(context).unfocus();
    _showMessage(isAddition ? "Money added." : "Money used.");
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message)),
      );
  }
}
