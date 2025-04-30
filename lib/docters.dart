import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.lightBlue,
      debugShowCheckedModeBanner: false,
      title: 'تطبيق الأطباء',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Cairo', // يمكنك استخدام خط عربي مثل Cairo
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 18),
        ),
        // textDirection: TextDirection.rtl, // اتجاه النص من اليمين لليسار
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', 'US'), // يمكنك إضافة اللغات المطلوبة هنا
        Locale('ar', 'AE'),
      ],

      // localizationsDelegates: [
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate,
      // ],
      // supportedLocales: [
      //   Locale('ar', 'SA'), // اللغة العربية
      //   Locale('en', 'US'), // اللغة الإنجليزية
      // ],
      home: const HomeScreen(),
    );
  }
}

class Doctor {
  final String name;
  final String specialty;
  final double rating;
  final double price;
  final String image;

  Doctor({
    required this.name,
    required this.specialty,
    required this.rating,
    required this.price,
    required this.image,
  });
  @override
  String toString() {
    return 'Doctor{name: $name, specialty: $specialty, rating: $rating, price: $price, image: $image}';
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          'تطبيق الأطباء',
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildFeatureButton(
              context,
              'اختر طبيبك',
              Icons.medical_services,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DoctorListScreen()),
              ),
            ),
            const SizedBox(height: 20),
            _buildFeatureButton(
              context,
              'حجز موعد',
              Icons.calendar_today,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AppointmentScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureButton(BuildContext context, String text, IconData icon,
      VoidCallback onPressed) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 30),
        label: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(text, style: Theme.of(context).textTheme.titleLarge),
        ),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}

class DoctorListScreen extends StatelessWidget {
  final List<Doctor> doctors = [
    Doctor(
      name: 'د. أحمد محمد',
      specialty: 'أمراض القلب',
      rating: 4.8,
      price: 84,
      image: 'images/about1.webp',
    ),
    Doctor(
      name: 'د. فاطمة علي',
      specialty: 'الأمراض الجلدية',
      rating: 4.6,
      price: 75,
      image: 'images/blog1.webp',
    ),
    Doctor(
      name: 'د.ياسر الياسر',
      specialty: 'الأمراض الباطنية',
      rating: 8.6,
      price: 100,
      image: 'images/blog2.webp',
    ),
    Doctor(
      name: 'د. داود دودي',
      specialty: 'جراح اعصاب',
      rating: 88.4,
      price: 150,
      image: 'images/blog3.webp',
    ),
  ];

  DoctorListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('قائمة الأطباء'),
      ),
      body: ListView.builder(
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          final doctor = doctors[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(doctor.image),
              ),
              title: Text(doctor.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(doctor.specialty),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      Text(' ${doctor.rating}'),
                    ],
                  ),
                ],
              ),
              trailing: Text('${doctor.price} ريال/جلسة',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              onTap: () => _showDoctorDetails(context, doctor),
            ),
          );
        },
      ),
    );
  }

  void _showDoctorDetails(BuildContext context, Doctor doctor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(doctor.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('التخصص: ${doctor.specialty}'),
            Text('التقييم: ${doctor.rating}'),
            Text('السعر: ${doctor.price} ريال/جلسة'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }
}

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('حجز موعد'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'اسم المريض',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'يرجى إدخال الاسم' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'رقم الجوال',
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value!.isEmpty ? 'يرجى إدخال رقم الجوال' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'اختر التاريخ',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
                validator: (value) =>
                    value!.isEmpty ? 'يرجى اختيار التاريخ' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _timeController,
                decoration: const InputDecoration(
                  labelText: 'اختر الوقت',
                  prefixIcon: Icon(Icons.access_time),
                ),
                readOnly: true,
                onTap: () => _selectTime(context),
                validator: (value) =>
                    value!.isEmpty ? 'يرجى اختيار الوقت' : null,
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                icon: const Icon(Icons.book_online),
                label: const Text('تأكيد الحجز'),
                onPressed: () => _submitForm(context),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
      locale: const Locale('ar'), // تحديد اللغة العربية
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd', 'ar').format(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        _timeController.text = picked.format(context);
      });
    }
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('تم الحجز بنجاح'),
          content: const Text('تم تأكيد موعدك بنجاح!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text('موافق'),
            ),
          ],
        ),
      );
    }
  }
}
