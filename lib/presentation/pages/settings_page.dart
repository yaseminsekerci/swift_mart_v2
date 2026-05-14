import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swift_mart/domain/entities/user_profile.dart';
import 'package:swift_mart/presentation/cubit/user_profile_cubit.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _language = 'Türkçe';

  void _openProfileEditor(BuildContext context, UserProfile current) {
    final nameCtrl = TextEditingController(text: current.displayName);
    final emailCtrl = TextEditingController(text: current.email);

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Profil bilgileri',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Ad Soyad',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'E-posta',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('İptal'),
            ),
            FilledButton(
              onPressed: () {
                final name = nameCtrl.text.trim();
                final email = emailCtrl.text.trim();
                if (name.isEmpty || email.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Ad ve e-posta boş olamaz.'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  return;
                }
                context.read<UserProfileCubit>().updateProfile(
                  displayName: name,
                  email: email,
                );
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profil güncellendi'),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Color(0xFF00B4D8),
                  ),
                );
              },
              child: const Text('Kaydet'),
            ),
          ],
        );
      },
    );
  }

  void _showLanguageDialog() {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Dil seç',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 12),
            ...['Türkçe', 'English', 'Français', 'Deutsch'].map((language) {
              return ListTile(
                title: Text(language),
                trailing: _language == language
                    ? const Icon(Icons.check, color: Color(0xFF00B4D8))
                    : null,
                onTap: () {
                  setState(() {
                    _language = language;
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Dil ${language == 'English' ? 'English' : language} olarak seçildi',
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              );
            }),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  void _showPrivacyDialog() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Gizlilik Politikası',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'SwiftMart, kişisel bilgilerinizi güvenle saklar. Sadece demo amaçlı veri kullanılmaktadır.',
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Kapat'),
            ),
          ],
        );
      },
    );
  }

  void _showSupportDialog() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Yardım ve Destek',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Herhangi bir sorun için destek@swiftmart.com adresine e-posta gönderin veya uygulama içi yardım bölümünü ziyaret edin.',
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Tamam'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Ayarlar',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          BlocBuilder<UserProfileCubit, UserProfile>(
            builder: (context, profile) {
              return _buildSettingItem(
                Icons.badge_outlined,
                'Profil bilgileri',
                '${profile.displayName} · ${profile.email}',
                () => _openProfileEditor(context, profile),
              );
            },
          ),
          _buildToggleItem(
            Icons.notifications_outlined,
            'Bildirimler',
            _notificationsEnabled ? 'Açık' : 'Kapalı',
            _notificationsEnabled,
            (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
          _buildToggleItem(
            Icons.dark_mode_outlined,
            'Karanlık mod',
            _darkModeEnabled ? 'Aktif' : 'Pasif',
            _darkModeEnabled,
            (value) {
              setState(() {
                _darkModeEnabled = value;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Tema ${value ? 'Karanlık' : 'Aydınlık'} moda ayarlandı',
                  ),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          _buildSettingItem(
            Icons.language_outlined,
            'Dil',
            _language,
            _showLanguageDialog,
          ),
          _buildSettingItem(
            Icons.privacy_tip_outlined,
            'Gizlilik',
            'Gizlilik politikasını görüntüleyin',
            _showPrivacyDialog,
          ),
          _buildSettingItem(
            Icons.help_outline,
            'Yardım ve destek',
            'Destek merkezi',
            _showSupportDialog,
          ),
          _buildSettingItem(
            Icons.info_outline,
            'Hakkında',
            'Uygulama bilgileri',
            () {
              showAboutDialog(
                context: context,
                applicationName: 'SwiftMart',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(Icons.shopping_bag, size: 48),
                children: const [
                  Text('Teknoloji ürünleri alışveriş uygulaması'),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF00B4D8)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: Colors.grey,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildToggleItem(
    IconData icon,
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF00B4D8)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        trailing: Switch(
          value: value,
          activeThumbColor: const Color(0xFF00B4D8),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
