import 'package:flutter/material.dart';
import 'rental_form_screen.dart';
import 'model/digital_instrument.dart';
import 'model/instrument_rental.dart';

class InstrumentDetailScreen extends StatefulWidget {
  final DigitalInstrument instrument;

  const InstrumentDetailScreen({Key? key, required this.instrument})
      : super(key: key);

  @override
  _InstrumentDetailScreenState createState() => _InstrumentDetailScreenState();
}

class _InstrumentDetailScreenState extends State<InstrumentDetailScreen> {
  List<InstrumentRental> rentalList = [];

  void _handleRentalComplete(InstrumentRental rental) {
    setState(() {
      rentalList.add(rental);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายละเอียดเครื่องดนตรี'),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // รูปเครื่องดนตรี
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    widget.instrument.imagePath,
                    width: 350,
                    height: 220,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Text('ไม่สามารถโหลดรูปได้');
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ข้อมูลเครื่องดนตรีในฟอร์ม
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.instrument.name,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'ประเภท: ${widget.instrument.type}',
                      style: TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.7)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'แบรนด์: ${widget.instrument.brand}',
                      style: TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.7)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'ราคา: ${widget.instrument.pricePerDay} บาท/วัน',
                      style: TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.7)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ปุ่มเช่าเครื่องดนตรี
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RentalFormScreen(
                          instrument: widget.instrument,
                          onRentalComplete: _handleRentalComplete,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                    shadowColor: Colors.deepPurple.withOpacity(0.3),
                  ),
                  child: Text(
                    'เช่าเครื่องดนตรีนี้',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // สีข้อความในปุ่ม
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
