import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:snap_spot/features/auth/presentation/pages/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _phoneController = TextEditingController();
  DateTime? _dob;

  bool _isLoading = false;

  void _onRegisterPressed() async {
    if (!_formKey.currentState!.validate()) return;

    if (_dob == null) {
      _showSnackbar("Vui lòng chọn ngày sinh");
      return;
    }

    setState(() => _isLoading = true);

    final requestBody = {
      "email": _emailController.text,
      "password": _passwordController.text,
      "confirmPassword": _confirmController.text,
      "phoneNumber": _phoneController.text,
      "dob": _dob!.toIso8601String(),
    };

    // TODO: Call register use case
    await Future.delayed(const Duration(seconds: 2)); // Giả lập

    setState(() => _isLoading = false);

    _showSnackbar("Đăng ký thành công!");
    // TODO: Navigate or clear form
  }

  void _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 100),
      lastDate: now,
      locale: const Locale('vi'),
    );
    if (picked != null) setState(() => _dob = picked);
  }

  void _showSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF0DC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 24),
                Image.asset("assets/images/snapspot_square.jpg", height: 150), // logo

                const SizedBox(height: 32),
                const Text(
                  "ĐĂNG KÝ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                const SizedBox(height: 24),

                TextFormField(
                  controller: _emailController,
                  decoration: _inputDecoration("Email"),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Vui lòng nhập email' : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: _inputDecoration("Mật khẩu"),
                  validator: (value) => value != null && value.length >= 6
                      ? null
                      : 'Mật khẩu phải từ 6 ký tự',
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _confirmController,
                  obscureText: true,
                  decoration: _inputDecoration("Xác nhận mật khẩu"),
                  validator: (value) =>
                  value == _passwordController.text ? null : 'Mật khẩu không khớp',
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: _inputDecoration("Số điện thoại"),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Vui lòng nhập số điện thoại' : null,
                ),
                const SizedBox(height: 16),

                InkWell(
                  onTap: _pickDate,
                  child: InputDecorator(
                    decoration: _inputDecoration("Ngày sinh"),
                    child: Text(
                      _dob != null
                          ? DateFormat("dd/MM/yyyy").format(_dob!)
                          : "Chọn ngày sinh",
                      style: TextStyle(color: _dob != null ? Colors.black : Colors.grey),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _onRegisterPressed,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("ĐĂNG KÝ", style: TextStyle(color: Colors.white)),
                  ),
                ),

                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Đã có tài khoản?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                        );
                      },
                      child: const Text("Đăng nhập", style: TextStyle(color: Colors.blue)),
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

  InputDecoration _inputDecoration(String hint) => InputDecoration(
    hintText: hint,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    filled: true,
    fillColor: Colors.white,
  );
}
