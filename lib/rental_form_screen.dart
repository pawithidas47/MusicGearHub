import 'package:flutter/material.dart';
import 'model/digital_instrument.dart';
import 'model/instrument_rental.dart';
import 'rental_list_screen.dart'; // ✅ Import global rentalList

class RentalFormScreen extends StatefulWidget {
  final DigitalInstrument instrument;
  final Function(InstrumentRental) onRentalComplete;

  const RentalFormScreen({
    Key? key,
    required this.instrument,
    required this.onRentalComplete,
  }) : super(key: key);

  @override
  _RentalFormScreenState createState() => _RentalFormScreenState();
}

class _RentalFormScreenState extends State<RentalFormScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  int _calculateRentalDays() {
    if (_startDate != null && _endDate != null) {
      return _endDate!.difference(_startDate!).inDays;
    }
    return 0;
  }

  double _calculateTotalCost() {
    return widget.instrument.pricePerDay * _calculateRentalDays();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('กรอกข้อมูลการเช่า'),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ข้อมูลเครื่องดนตรี
              Text(
                'เครื่องดนตรี: ${widget.instrument.name}',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 20),

              // ฟอร์มกรอกชื่อผู้เช่า
              _buildTextField(
                controller: _nameController,
                label: 'ชื่อผู้เช่า',
                icon: Icons.person,
              ),
              const SizedBox(height: 10),

              // ฟอร์มกรอกเบอร์โทรศัพท์
              _buildTextField(
                controller: _phoneController,
                label: 'เบอร์โทรศัพท์',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),

              // ฟอร์มเลือกวันที่เริ่ม
              _buildDateField(
                label: 'วันที่เริ่ม',
                selectedDate: _startDate,
                onDateSelected: (date) {
                  setState(() {
                    _startDate = date;
                  });
                },
              ),
              const SizedBox(height: 10),

              // ฟอร์มเลือกวันที่สิ้นสุด
              _buildDateField(
                label: 'วันที่สิ้นสุด',
                selectedDate: _endDate,
                onDateSelected: (date) {
                  setState(() {
                    _endDate = date;
                  });
                },
              ),
              const SizedBox(height: 20),

              // ปุ่มยืนยันการเช่า
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    final rentalDays = _calculateRentalDays();
                    if (rentalDays > 0) {
                      final totalCost = _calculateTotalCost();
                      final rental = InstrumentRental(
                        rentalID: null,
                        instrument: widget.instrument,
                        renterName: _nameController.text,
                        renterPhone: _phoneController.text,
                        startDate: _startDate!,
                        endDate: _endDate!,
                        rentalDays: rentalDays,
                        totalCost: totalCost,
                      );

                      widget.onRentalComplete(rental); // ✅ บันทึกข้อมูล
                      rentalList.add(rental); // ✅ ใช้ global rentalList

                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('เช่าทำสำเร็จ'),
                          content: Text(
                              'คุณเช่า ${widget.instrument.name} เรียบร้อยแล้ว\n'
                              'ค่าบริการ: ฿${totalCost.toStringAsFixed(2)}'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: const Text('กลับหน้าหลัก'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RentalListScreen(),
                                  ),
                                );
                              },
                              child: const Text('ดูรายการที่เช่า'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('กรุณากรอกข้อมูลวันที่เริ่มต้นและสิ้นสุดให้ถูกต้อง'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'ยืนยันการเช่า',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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

  // ฟังก์ชันสร้างฟอร์มข้อความ
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        keyboardType: keyboardType,
      ),
    );
  }

  // ฟังก์ชันสร้างฟอร์มเลือกวันที่
Widget _buildDateField({
  required String label,
  required DateTime? selectedDate,
  required Function(DateTime) onDateSelected,
}) {
  return Row(
    children: [
      Text(
        label,
        style: TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.7)),
      ),
      IconButton(
        icon: const Icon(Icons.calendar_today),
        onPressed: () async {
          final DateTime? chosenDate = await showDatePicker(
            context: context,
            initialDate: selectedDate ?? DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          if (chosenDate != null) {
            onDateSelected(chosenDate); // ใช้ chosenDate แทน selectedDate
          }
        },
      ),
      if (selectedDate != null) Text('${selectedDate.toLocal()}'),
    ],
  );
}
}
