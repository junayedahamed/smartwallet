import 'package:flutter/material.dart';
import 'package:smartwallet/setting/setting_controller.dart';

class L10n {
  static const Map<String, Map<String, String>> _localizedValues = {
    "welcome": {
      "en": "Welcome to SmartWallet",
      "bn": "স্মার্টওয়ালেটে স্বাগতম",
    },
    "set_starting_values": {
      "en": "Set your starting values once. You can update your tracking anytime.",
      "bn": "আপনার প্রারম্ভিক হিসাব একবার যুক্ত করুন। আপনি যে কোন সময় তা পরিবর্তন করতে পারবেন।",
    },
    "initial_balance": {
      "en": "Initial balance",
      "bn": "প্রারম্ভিক জের",
    },
    "whole_number_max": {
      "en": "Whole number only • max",
      "bn": "শুধুমাত্র পূর্ণ সংখ্যা • সর্বোচ্চ",
    },
    "daily_need": {
      "en": "Daily need",
      "bn": "দৈনিক প্রয়োজন",
    },
    "greater_than_0": {
      "en": "Must be greater than 0",
      "bn": "শূন্যের অধিক হতে হবে",
    },
    "start_tracking": {
      "en": "Start Tracking",
      "bn": "হিসাব শুরু করুন",
    },
    "add_initial_balance": {
      "en": "Please add your starting balance",
      "bn": "অনুগ্রহ করে আপনার প্রারম্ভিক জের প্রদান করুন",
    },
    "balance_whole_number": {
      "en": "Balance must be a whole number",
      "bn": "জের একটি পূর্ণ সংখ্যা হতে হবে",
    },
    "balance_not_negative": {
      "en": "Balance cannot be negative",
      "bn": "জের ঋণাত্মক হতে পারে না",
    },
    "max_balance_is": {
      "en": "Maximum balance is",
      "bn": "সর্বোচ্চ জের হলো",
    },
    "add_daily_need": {
      "en": "Please add your daily need",
      "bn": "অনুগ্রহ করে আপনার দৈনিক প্রয়োজন উল্লেখ করুন",
    },
    "wallet_balance": {
      "en": "Wallet Balance",
      "bn": "বর্তমান তহবিল",
    },
    "est_days_remaining": {
      "en": "Est. @days days remaining",
      "bn": "আনুমানিক @days দিন ব্যবহারযোগ্য",
    },
    "add_transaction": {
      "en": "Add a transaction",
      "bn": "নতুন লেনদেন যুক্ত করুন",
    },
    "reason_optional": {
      "en": "Reason (optional)",
      "bn": "বিবরণ (ঐচ্ছিক)",
    },
    "reason_hint": {
      "en": "Groceries, Salary, Rent...",
      "bn": "মুদি, বেতন, বাসা ভাড়া...",
    },
    "amount": {
      "en": "Amount",
      "bn": "পরিমাণ",
    },
    "use": {
      "en": "Use",
      "bn": "ব্যয়",
    },
    "add": {
      "en": "Add",
      "bn": "জমা",
    },
    "no_transactions_add_first": {
      "en": "No transactions yet. Add your first entry above.",
      "bn": "এখনও কোন লেনদেন হয়নি। উপরে আপনার প্রথম হিসাব যুক্ত করুন।",
    },
    "recent_transactions": {
      "en": "Recent transactions",
      "bn": "সাম্প্রতিক লেনদেনসমূহ",
    },
    "money_added": {
      "en": "Money added.",
      "bn": "তহবিল জমা করা হয়েছে।",
    },
    "money_used": {
      "en": "Money used.",
      "bn": "তহবিল ব্যয় করা হয়েছে।",
    },
    "not_enough_balance": {
      "en": "Not enough balance for this transaction.",
      "bn": "এই লেনদেনের জন্য পর্যাপ্ত জের নেই।",
    },
    "no_history_yet": {
      "en": "No transaction history yet.",
      "bn": "কোনো লেনদেনের ইতিহাস নেই।",
    },
    "transaction_timeline": {
      "en": "Transaction timeline",
      "bn": "লেনদেনের সময়রেখা",
    },
    "filter_by_date": {
      "en": "Filter by date",
      "bn": "তারিখ অনুযায়ী নির্বাচন করুন",
    },
    "all_time": {
      "en": "All time",
      "bn": "সকল সময়",
    },
    "last_1_day": {
      "en": "Last 1 day",
      "bn": "গত ১ দিন",
    },
    "last_3_days": {
      "en": "Last 3 days",
      "bn": "গত ৩ দিন",
    },
    "last_7_days": {
      "en": "Last 7 days",
      "bn": "গত ৭ দিন",
    },
    "last_30_days": {
      "en": "Last 30 days",
      "bn": "গত ৩০ দিন",
    },
    "pick_date": {
      "en": "Pick date",
      "bn": "তারিখ নির্বাচন করুন",
    },
    "no_transactions_found_period": {
      "en": "No transactions found for this period.",
      "bn": "এই সময়ে কোন লেনদেন পাওয়া যায়নি।",
    },
    "total": {
      "en": "Total:",
      "bn": "সর্বমোট:",
    },
    "today": {
      "en": "Today",
      "bn": "আজ",
    },
    "yesterday": {
      "en": "Yesterday",
      "bn": "গতকাল",
    },
    "income": {
      "en": "Income",
      "bn": "আয়",
    },
    "expense": {
      "en": "Expense",
      "bn": "ব্যয়",
    },
    "language": {
      "en": "Language",
      "bn": "ভাষা",
    },
    "currency": {
      "en": "Currency",
      "bn": "মুদ্রা",
    },
    "home": {
      "en": "Home",
      "bn": "প্রধান পাতা",
    },
    "history": {
      "en": "History",
      "bn": "অতীতের খবর",
    },
    "profile": {
      "en": "Profile",
      "bn": "ব্যবহারকারী",
    },
    "export_pdf": {
      "en": "Export PDF",
      "bn": "পিডিএফ তৈরি করুন",
    },
    "theme": {
      "en": "Theme",
      "bn": "রূপরেখা",
    },
    "system_settings": {
      "en": "System Settings",
      "bn": "ডিভাইস সেটিংস",
    },
    "light_mode": {
      "en": "Light Mode",
      "bn": "উজ্জ্বল আলো",
    },
    "dark_mode": {
      "en": "Dark Mode",
      "bn": "অন্ধকার আলো",
    },
    "file_saved": {
      "en": "File saved.",
      "bn": "ফাইল সংরক্ষণ করা হয়েছে।",
    },
    "enter_name": {
      "en": "Enter a name",
      "bn": "একটি নাম প্রদান করুন",
    },
    "financial_overview": {
      "en": "Financial overview",
      "bn": "আর্থিক সারাংশ",
    },
    "wallet_health": {
      "en": "A quick summary of your wallet health.",
      "bn": "আপনার লেনদেনের সংক্ষিপ্ত বিবরণী।",
    },
    "total_added": {
      "en": "Total Added",
      "bn": "মোট জমাকৃত",
    },
    "total_used": {
      "en": "Total Used",
      "bn": "মোট ব্যয়কৃত",
    },
    "actions": {
      "en": "Actions",
      "bn": "পদক্ষেপসমূহ",
    },
    "reset_all": {
      "en": "Reset all",
      "bn": "সব মুছে ফেলুন",
    },
    "confirm_reset": {
      "en": "Confirm Reset",
      "bn": "তথ্য মুছে ফেলা নিশ্চিত করুন",
    },
    "confirm_reset_desc": {
      "en": "Are you sure you want to reset the database? This action cannot be undone.",
      "bn": "আপনি কি নিশ্চিত যে সমস্ত তথ্য মুছে ফেলতে চান? এটি আর ফেরানো যাবে না।",
    },
    "cancel": {
      "en": "Cancel",
      "bn": "বাতিল",
    },
    "reset": {
      "en": "Reset",
      "bn": "মুছে ফেলুন",
    },
  };

  static String tr(BuildContext context, String key, [Map<String, String>? params]) {
    return trByCode(SettingsController.instance.locale, key, params);
  }

  static String trByCode(String langCode, String key, [Map<String, String>? params]) {
    String text = _localizedValues[key]?[langCode] ?? key;
    if (params != null) {
      params.forEach((k, v) {
        text = text.replaceAll("@$k", v);
      });
    }
    return text;
  }
}
