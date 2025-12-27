import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final AppUser me;
  final String access;

  const ProfileScreen({super.key, required this.me, required this.access});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final auth = AuthService();

  late AppUser me;
  bool refreshing = false;
  String errorText = '';

  static const bg = Color(0xFFF6EEDF);
  static const btn = Color(0xFFE9A0B2);
  static const textMain = Color(0xFF2B2B2B);

  @override
  void initState() {
    super.initState();
    me = widget.me;
  }

  Future<void> _refresh() async {
    setState(() {
      refreshing = true;
      errorText = '';
    });

    try {
      final currentAccess = await auth.getAccessToken();
      if (currentAccess == null || currentAccess.isEmpty) {
        throw Exception('Сессия закончилась. Войдите заново.');
      }

      final updated = await auth.getMe();

      setState(() {
        me = updated;
        refreshing = false;
      });
    } catch (e) {
      setState(() {
        errorText = e.toString();
        refreshing = false;
      });
    }
  }

  Future<void> _logout() async {
    await auth.logout();
    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 26),
              const Text(
                'Профиль',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: textMain,
                ),
              ),
              const SizedBox(height: 12),

              Center(child: Image.asset('assets/fox.webp', height: 120)),

              const SizedBox(height: 14),

              _ProfileHeader(
                name: me.name,
                email: me.email,
                avatarUrl: me.avatarUrl, // ✅ используем avatar_url
              ),

              const SizedBox(height: 14),

              _InfoCard(
                title: 'Данные',
                children: [
                  _kv('ID', me.id.toString()),
                  _kv('Имя', me.name.isEmpty ? '-' : me.name),
                  _kv('Email', me.email.isEmpty ? '-' : me.email),
                ],
              ),

              if (errorText.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(errorText, style: const TextStyle(color: Colors.red)),
              ],

              const Spacer(),

              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        onPressed: refreshing ? null : _refresh,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: btn,
                          disabledBackgroundColor: btn.withValues(alpha: 0.6),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: refreshing
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Обновить',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 54,
                      child: OutlinedButton(
                        onPressed: _logout,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: Colors.black.withValues(alpha: 0.18),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: const Text(
                          'Выйти',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget _kv(String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              k,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.black.withValues(alpha: 0.7),
              ),
            ),
          ),
          Expanded(
            child: Text(v, style: const TextStyle(color: Colors.black87)),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final String? avatarUrl;

  static const textMain = Color(0xFF2B2B2B);

  const _ProfileHeader({
    required this.name,
    required this.email,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            blurRadius: 14,
            offset: const Offset(0, 8),
            color: Colors.black.withValues(alpha: 0.05),
          ),
        ],
      ),
      child: Row(
        children: [
          _Avatar(avatarUrl: avatarUrl),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.isEmpty ? 'Без имени' : name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: textMain,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  email.isEmpty ? '-' : email,
                  style: TextStyle(
                    color: Colors.black.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String? avatarUrl;
  const _Avatar({required this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    final placeholder = CircleAvatar(
      radius: 26,
      backgroundColor: Colors.black.withValues(alpha: 0.06),
      child: const Icon(Icons.person, color: Colors.black54),
    );

    if (avatarUrl == null || avatarUrl!.isEmpty) return placeholder;

    return CircleAvatar(
      radius: 26,
      backgroundColor: Colors.black.withValues(alpha: 0.06),
      backgroundImage: NetworkImage(avatarUrl!),
      onBackgroundImageError: (_, __) {},
      child: const SizedBox.shrink(),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _InfoCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            blurRadius: 14,
            offset: const Offset(0, 8),
            color: Colors.black.withValues(alpha: 0.05),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2B2B2B),
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}
