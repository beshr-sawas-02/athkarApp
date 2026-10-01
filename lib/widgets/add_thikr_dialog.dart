import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/thikr_category.dart';
import '../utils/app_theme.dart';

class AddThikrDialog extends StatefulWidget {
  final void Function(String name, int goal, ThikrCategory category) onAdd;

  const AddThikrDialog({
    super.key,
    required this.onAdd,
  });

  @override
  State<AddThikrDialog> createState() => _AddThikrDialogState();
}

class _AddThikrDialogState extends State<AddThikrDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _goalController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ThikrCategory _category = ThikrCategory.custom;

  @override
  void initState() {
    super.initState();
    _goalController.text = '100';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final goal = int.tryParse(_goalController.text) ?? 100;
      Navigator.of(context).pop();
      widget.onAdd(name, goal, _category);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.15),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: AppTheme.goldGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.add_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'إضافة ذكر جديد',
                      style: AppTheme.arabicTitleStyle.copyWith(
                        color:
                            isDark ? AppTheme.darkText : AppTheme.lightText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameController,
                  textDirection: TextDirection.rtl,
                  style: AppTheme.arabicBodyStyle.copyWith(
                    color: isDark ? AppTheme.darkText : AppTheme.lightText,
                  ),
                  decoration: InputDecoration(
                    labelText: 'اسم الذكر',
                    labelStyle: TextStyle(
                      color: isDark
                          ? AppTheme.darkTextSecondary
                          : AppTheme.lightTextSecondary,
                    ),
                    hintText: 'مثال: سبحان الله',
                    filled: true,
                    fillColor: isDark
                        ? AppTheme.darkSurfaceVariant
                        : AppTheme.lightBackground,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppTheme.primaryGold,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'يرجى إدخال اسم الذكر';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _goalController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppTheme.darkText : AppTheme.lightText,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    labelText: 'الهدف',
                    filled: true,
                    fillColor: isDark
                        ? AppTheme.darkSurfaceVariant
                        : AppTheme.lightBackground,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppTheme.primaryGold,
                        width: 2,
                      ),
                    ),
                    prefixIcon: const Icon(
                      Icons.flag_rounded,
                      color: AppTheme.primaryGold,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال الهدف';
                    }
                    final number = int.tryParse(value);
                    if (number == null || number <= 0) {
                      return 'يرجى إدخال رقم صحيح أكبر من صفر';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  alignment: WrapAlignment.center,
                  children: [33, 100, 1000].map((v) {
                    return ActionChip(
                      label: Text('$v'),
                      onPressed: () =>
                          setState(() => _goalController.text = '$v'),
                      backgroundColor: isDark
                          ? AppTheme.darkSurfaceVariant
                          : AppTheme.lightBackground,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<ThikrCategory>(
                  initialValue: _category,
                  decoration: InputDecoration(
                    labelText: 'التصنيف',
                    filled: true,
                    fillColor: isDark
                        ? AppTheme.darkSurfaceVariant
                        : AppTheme.lightBackground,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: ThikrCategory.values
                      .map(
                        (c) => DropdownMenuItem(
                          value: c,
                          child: Text(c.labelAr),
                        ),
                      )
                      .toList(),
                  onChanged: (c) {
                    if (c != null) setState(() => _category = c);
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          'إلغاء',
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark
                                ? AppTheme.darkTextSecondary
                                : AppTheme.lightTextSecondary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryGold,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'إضافة',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
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
    );
  }
}
