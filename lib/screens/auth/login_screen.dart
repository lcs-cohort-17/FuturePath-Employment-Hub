import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'FuturePath',
                style: TextStyle(
                  color: Color(0xFFF0EDE8),
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Employment Hub',
                style: TextStyle(
                  color: Color(0xFF9E9B96),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Welcome back',
                style: TextStyle(
                  color: Color(0xFFF0EDE8),
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Sign in to your account',
                style: TextStyle(
                  color: Color(0xFF9E9B96),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Email address',
                style: TextStyle(
                  color: Color(0xFF9E9B96),
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF2E2E2E), width: 0.5),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: const TextField(
                  style: TextStyle(color: Color(0xFFF0EDE8), fontSize: 12),
                  decoration: InputDecoration(
                    hintText: 'you@example.com',
                    hintStyle: TextStyle(color: Color(0xFF5C5A57), fontSize: 12),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Password',
                style: TextStyle(
                  color: Color(0xFF9E9B96),
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF2E2E2E), width: 0.5),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: const TextField(
                  obscureText: true,
                  style: TextStyle(color: Color(0xFFF0EDE8), fontSize: 12),
                  decoration: InputDecoration(
                    hintText: '••••••••',
                    hintStyle: TextStyle(color: Color(0xFF5C5A57), fontSize: 12),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to Staff Dashboard for demo
                    Navigator.pushReplacementNamed(context, '/staff/dashboard');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE03A2F),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}