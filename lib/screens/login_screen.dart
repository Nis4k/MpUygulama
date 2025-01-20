import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/student.dart';
import 'reservation_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _roomController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Çamaşırhane Giriş'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                "assets/background.jpg"), // Burada arka plan görselinizi belirtiyorsunuz
            fit: BoxFit.cover, // Görselin ekranı tamamen kaplamasını sağlar
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Ad Soyad',
                    filled: true,
                    fillColor: Colors
                        .white, // Giriş kutularının arka planını beyaz yapıyoruz
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen adınızı ve soyadınızı girin';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _roomController,
                  decoration: const InputDecoration(
                    labelText: 'Oda Numarası',
                    filled: true,
                    fillColor: Colors
                        .white, // Aynı şekilde oda numarası kutusu için de beyaz arka plan
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen oda numaranızı girin';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final student = Student(
                        name: _nameController.text,
                        roomNumber: _roomController.text,
                      );

                      final id =
                          await DatabaseHelper.instance.createStudent(student);

                      if (id != 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ReservationScreen(studentId: id),
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Kayıt başarısız, tekrar deneyin!")),
                      );
                    }
                  },
                  child: const Text('Giriş'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roomController.dispose();
    super.dispose();
  }
}
