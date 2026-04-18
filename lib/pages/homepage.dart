import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:smartwallet/database/database.dart';
import 'package:smartwallet/pages/balance_controller.dart';
import 'package:smartwallet/pages/history.dart';
import 'package:smartwallet/pages/profile.dart';
import 'package:smartwallet/utils/double_formatter.dart';
import 'package:smartwallet/l10n/l10n.dart';

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
      bottomNavigationBar: _buildFloatingNavBar(context),
      floatingActionButton: (currentTab == 1)
          ? FloatingActionButton.extended(
              onPressed: () => WalletDb.instance
                  .exportHistoryToPdf(ScaffoldMessenger.of(context), context),
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedPdf01,
                color: Colors.white,
                size: 22,
              ),
              label: const Text("Export PDF"),
            )
          : null,
    );
  }

  AppBar? _buildAppBar() {
    if (currentTab == 1) {
      return AppBar(title: Text(L10n.tr(context, "history")));
    }
    if (currentTab == 2) {
      return AppBar(title: Text(L10n.tr(context, "profile")));
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
                          L10n.tr(context, "add_transaction"),
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: reasonController,
                          textInputAction: TextInputAction.next,
                          maxLength: 60,
                          decoration: InputDecoration(
                            labelText: L10n.tr(context, "reason_optional"),
                            hintText: L10n.tr(context, "reason_hint"),
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
                            labelText: L10n.tr(context, "amount"),
                            hintText: "0",
                            helperText:
                                "${L10n.tr(context, 'whole_number_max')} ${WalletDb.maxTransactionAmount}",
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
                                icon: HugeIcon(
                                    icon: HugeIcons.strokeRoundedMinusSign,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onErrorContainer,
                                    size: 24),
                                label: Text(
                                  L10n.tr(context, "use"),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 18),
                                ),
                                style: FilledButton.styleFrom(
                                  backgroundColor:
                                      theme.colorScheme.errorContainer,
                                  foregroundColor:
                                      theme.colorScheme.onErrorContainer,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 24),
                                  shape:
                                      const StadiumBorder(), // Perfect expressive pill shape
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
                                icon: HugeIcon(
                                    icon: HugeIcons.strokeRoundedPlusSign,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    size: 24),
                                label: Text(
                                  L10n.tr(context, "add"),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 18),
                                ),
                                style: FilledButton.styleFrom(
                                  backgroundColor: theme.colorScheme.primary,
                                  foregroundColor: theme.colorScheme.onPrimary,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 24),
                                  shape:
                                      const StadiumBorder(), // Perfect expressive pill shape
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
                      L10n.tr(context, "no_transactions_add_first"),
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
                            L10n.tr(context, "recent_transactions"),
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
        color:
            colorScheme.primaryContainer, // Solid expressive color, no gradient
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
              backgroundColor:
                  colorScheme.onPrimaryContainer.withValues(alpha: 0.05),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 32.0, vertical: 36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      L10n.tr(context, "wallet_balance"),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer
                            .withValues(alpha: 0.8),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    HugeIcon(
                      icon: HugeIcons.strokeRoundedWallet01,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  decoration: BoxDecoration(
                    color:
                        colorScheme.onPrimaryContainer.withValues(alpha: 0.1),
                    borderRadius:
                        BorderRadius.circular(24), // Expressive inner pill
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      HugeIcon(
                          icon: HugeIcons.strokeRoundedClock01,
                          color: colorScheme.onPrimaryContainer,
                          size: 18),
                      const SizedBox(width: 8),
                      Text(
                        L10n.tr(context, "est_days_remaining",
                            {"days": daysLeft.toString()}),
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
      return L10n.tr(context, "balance_whole_number"); // Fallback
    }

    final parsedAmount = int.tryParse(value);
    if (parsedAmount == null) {
      return L10n.tr(context, "balance_whole_number");
    }
    if (parsedAmount <= 0) {
      return L10n.tr(context, "greater_than_0");
    }
    if (parsedAmount > WalletDb.maxTransactionAmount) {
      return "${L10n.tr(context, 'max_balance_is')} ${WalletDb.maxTransactionAmount}";
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
      _showMessage(L10n.tr(context, "not_enough_balance"));
      return;
    }

    final trimmedReason = reasonController.text.trim();
    final fallbackReason = isAddition
        ? L10n.tr(context, "money_added")
        : L10n.tr(context, "money_used");
    final success = WalletDb.instance.addMoney(
      Money(
        isAddition ? parsedAmount.toDouble() : -parsedAmount.toDouble(),
        reason: trimmedReason.isEmpty ? fallbackReason : trimmedReason,
      ),
    );

    if (!success) {
      _showMessage(
          "${L10n.tr(context, 'max_balance_is')} ${WalletDb.maxTransactionAmount}");
      return;
    }

    amountController.clear();
    reasonController.clear();
    FocusScope.of(context).unfocus();
    _showMessage(isAddition
        ? L10n.tr(context, "money_added")
        : L10n.tr(context, "money_used"));
  }

  Widget _buildFloatingNavBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final items = [
      (
        HugeIcons.strokeRoundedHome01,
        HugeIcons.strokeRoundedHome01,
        L10n.tr(context, "home")
      ),
      (
        HugeIcons.strokeRoundedClock01,
        HugeIcons.strokeRoundedClock01,
        L10n.tr(context, "history")
      ),
      (
        HugeIcons.strokeRoundedUser,
        HugeIcons.strokeRoundedUser,
        L10n.tr(context, "profile")
      ),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Container(
        height: 68,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.10),
              blurRadius: 24,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: List.generate(items.length, (i) {
            final selected = currentTab == i;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => currentTab = i),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeInOutCubicEmphasized,
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: selected
                        ? colorScheme.primaryContainer
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      HugeIcon(
                        icon: items[i].$1,
                        size: 22,
                        color: selected
                            ? colorScheme.onPrimaryContainer
                            : colorScheme.onSurfaceVariant,
                      ),
                      if (selected) ...[
                        const SizedBox(width: 8),
                        Text(
                          items[i].$3,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message)),
      );
  }
}
