import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/theme/app_theme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          children: [
            _buildSection(
              title: 'Conta',
              children: [
                _SettingsTile(
                  icon: Icons.person_outline_rounded,
                  label: 'Perfil',
                  subtitle: 'Editar nome e e-mail',
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: Icons.lock_outline_rounded,
                  label: 'Alterar senha',
                  subtitle: 'Atualizar sua senha de acesso',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Financeiro',
              children: [
                _SettingsTile(
                  icon: Icons.account_balance_wallet_rounded,
                  label: 'Configuração financeira',
                  subtitle: 'Renda, limites e metas',
                  onTap: () =>
                      Navigator.pushNamed(context, '/finance-config'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Preferências',
              children: [
                _SettingsSwitch(
                  icon: Icons.notifications_outlined,
                  label: 'Notificações',
                  subtitle: 'Alertas de vencimento e resumos',
                  value: _notificationsEnabled,
                  onChanged: (value) {
                    setState(() => _notificationsEnabled = value);
                  },
                ),
                _SettingsTile(
                  icon: Icons.attach_money_rounded,
                  label: 'Moeda',
                  subtitle: 'BRL (R\$)',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Conta',
              children: [
                _SettingsTile(
                  icon: Icons.info_outline_rounded,
                  label: 'Sobre',
                  subtitle: 'Versão 1.0.0',
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: Icons.logout_rounded,
                  label: 'Sair da conta',
                  textColor: AppColors.error,
                  iconColor: AppColors.error,
                  onTap: () => _confirmLogout(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColors.cinzaClaro.withValues(alpha: 0.7),
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.verdeEscuro,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              for (int i = 0; i < children.length; i++) ...[
                if (i > 0)
                  Divider(
                    height: 1,
                    color: AppColors.cinzaEscuro.withValues(alpha: 0.3),
                  ),
                children[i],
              ],
            ],
          ),
        ),
      ],
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.verdeEscuro,
        title: const Text(
          'Sair da conta',
          style: TextStyle(color: AppColors.branco),
        ),
        content: const Text(
          'Tem certeza que deseja sair?',
          style: TextStyle(color: AppColors.cinzaClaro),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: AppColors.cinzaClaro),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              const storage = FlutterSecureStorage();
              await storage.deleteAll();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
            child: const Text(
              'Sair',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback? onTap;
  final Color? textColor;
  final Color? iconColor;

  const _SettingsTile({
    required this.icon,
    required this.label,
    this.subtitle,
    this.onTap,
    this.textColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? AppColors.verdeDestaque,
        size: 22,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: textColor ?? AppColors.branco,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: TextStyle(
                color: AppColors.cinzaClaro.withValues(alpha: 0.6),
                fontSize: 12,
              ),
            )
          : null,
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: AppColors.cinzaClaro.withValues(alpha: 0.5),
        size: 20,
      ),
      onTap: onTap,
    );
  }
}

class _SettingsSwitch extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const _SettingsSwitch({
    required this.icon,
    required this.label,
    this.subtitle,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: Icon(
        icon,
        color: AppColors.verdeDestaque,
        size: 22,
      ),
      title: Text(
        label,
        style: const TextStyle(
          color: AppColors.branco,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: TextStyle(
                color: AppColors.cinzaClaro.withValues(alpha: 0.6),
                fontSize: 12,
              ),
            )
          : null,
      value: value,
      onChanged: onChanged,
      activeThumbColor: AppColors.verdeDestaque,
    );
  }
}
