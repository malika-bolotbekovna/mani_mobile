import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend_flutter/screens/root_screen.dart';
import 'package:image_picker/image_picker.dart';

import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final auth = AuthService();
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  final picker = ImagePicker();
  File? avatarFile;

  bool loading = false;
  String errorText = '';

  static const bg = Color(0xFFF6EEDF);
  static const btn = Color(0xFFE9A0B2);
  static const textMain = Color(0xFF2B2B2B);

  Future<void> _pickAvatar() async {
    final x = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (x == null) return;
    setState(() => avatarFile = File(x.path));
  }

  Future<void> _register() async {
    setState(() {
      loading = true;
      errorText = '';
    });

    try {
      await auth.register(
        name: nameCtrl.text,
        email: emailCtrl.text,
        password: passwordCtrl.text,
        avatar: avatarFile, // если null — отправим без файла
      );

      // сразу логин
      final tokens = await auth.login(
        email: emailCtrl.text,
        password: passwordCtrl.text,
      );

      final me = await auth.getMe();
      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => RootScreen(me: me, access: tokens.access),
        ),
      );
    } catch (e) {
      setState(() {
        errorText = e.toString();
        loading = false;
      });
      return;
    }

    setState(() => loading = false);
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
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
                'Регистрация',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: textMain,
                ),
              ),
              const SizedBox(height: 18),

              // Avatar picker (в стиле)
              GestureDetector(
                onTap: loading ? null : _pickAvatar,
                child: Container(
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(18),
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
                      const SizedBox(width: 18),
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.black.withValues(alpha: 0.06),
                        backgroundImage: avatarFile != null
                            ? FileImage(avatarFile!)
                            : null,
                        child: avatarFile == null
                            ? const Icon(
                                Icons.person,
                                size: 18,
                                color: Colors.black54,
                              )
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          avatarFile == null
                              ? 'Выбрать аватар'
                              : 'Аватар выбран',
                          style: TextStyle(
                            color: Colors.black.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: 16),
                        child: Icon(Icons.photo, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 14),

              _RoundedField(hint: 'Имя', controller: nameCtrl),
              const SizedBox(height: 14),
              _RoundedField(
                hint: 'Email',
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 14),
              _RoundedField(
                hint: 'Пароль',
                controller: passwordCtrl,
                obscureText: true,
              ),

              const SizedBox(height: 18),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: loading ? null : _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: btn,
                    disabledBackgroundColor: btn.withValues(alpha: 0.6),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: loading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          'Создать аккаунт',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 16),

              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('📝', style: TextStyle(fontSize: 22)),
                  SizedBox(width: 12),
                  Text('🔐', style: TextStyle(fontSize: 22)),
                  SizedBox(width: 12),
                  Text('✅', style: TextStyle(fontSize: 22)),
                ],
              ),

              if (errorText.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(errorText, style: const TextStyle(color: Colors.red)),
              ],

              const Spacer(),

              _BottomLink(
                question: 'Есть аккаунт?',
                action: 'Войти',
                onTap: () => Navigator.of(context).pop(),
              ),

              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoundedField extends StatelessWidget {
  const _RoundedField({
    required this.hint,
    required this.controller,
    this.obscureText = false,
    this.keyboardType,
  });

  final String hint;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 14,
            offset: const Offset(0, 8),
            color: Colors.black.withValues(alpha: 0.05),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}

class _BottomLink extends StatelessWidget {
  const _BottomLink({
    required this.question,
    required this.action,
    required this.onTap,
  });

  final String question;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: RichText(
          text: TextSpan(
            style: TextStyle(
              color: Colors.black.withValues(alpha: 0.55),
              fontSize: 14,
            ),
            children: [
              TextSpan(text: '$question '),
              TextSpan(
                text: action,
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w700,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
