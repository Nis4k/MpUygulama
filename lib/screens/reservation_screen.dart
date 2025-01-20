import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/reservation.dart';

class ReservationScreen extends StatefulWidget {
  final int studentId;

  const ReservationScreen({super.key, required this.studentId});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  String? selectedDay;
  String? selectedTime;
  final List<String> weekDays = [
    'Pazartesi',
    'Salı',
    'Çarşamba',
    'Perşembe',
    'Cuma'
  ];
  final List<String> timeSlots = [
    '08:00',
    '09:00',
    '10:00',
    '11:00',
    '12:00',
    '13:00',
    '14:00',
    '15:00',
    '16:00',
    '17:00'
  ];

  @override
  void initState() {
    super.initState();
    _checkWeeklyReservation();
  }

  Future<void> _checkWeeklyReservation() async {
    final hasReservation =
        await DatabaseHelper.instance.hasWeeklyReservation(widget.studentId);

    if (hasReservation && mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Uyarı'),
          content: const Text('Bu hafta için randevu hakkınızı kullandınız.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Tamam'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Randevu Oluştur'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Gün Seçin:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: weekDays.map((day) {
                return ChoiceChip(
                  label: Text(day),
                  selected: selectedDay == day,
                  onSelected: (selected) {
                    setState(() {
                      selectedDay = selected ? day : null;
                      selectedTime = null;
                    });
                  },
                );
              }).toList(),
            ),
            if (selectedDay != null) ...[
              const SizedBox(height: 24),
              const Text(
                'Saat Seçin:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: timeSlots.map((time) {
                  return ChoiceChip(
                    label: Text(time),
                    selected: selectedTime == time,
                    onSelected: (selected) {
                      setState(() {
                        selectedTime = selected ? time : null;
                      });
                    },
                  );
                }).toList(),
              ),
            ],
            if (selectedDay != null && selectedTime != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  final reservation = Reservation(
                    id: 0,
                    studentId: widget.studentId,
                    date: selectedDay!,
                    time: selectedTime!,
                  );

                  // Veritabanına randevu ekleniyor
                  await DatabaseHelper.instance.createReservation(reservation);

                  // Eğer ekleme başarılıysa, kullanıcıya bildirim göster
                  if (mounted) {
                    // Dialog'u göster
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Başarılı'),
                        content: const Text(
                          'Randevunuz oluşturulmuştur. Randevu saatinden 5 dakika önce çamaşırhanede bulununuz.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Dialog'u kapat
                              Navigator.of(context)
                                  .pop(); // Önceki sayfaya geri dön
                            },
                            child: const Text('Tamam'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: const Text('Randevu Oluştur'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
