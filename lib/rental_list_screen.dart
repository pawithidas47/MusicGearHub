import 'package:flutter/material.dart';
import 'model/instrument_rental.dart';

List<InstrumentRental> rentalList = [];

class RentalListScreen extends StatefulWidget {
  const RentalListScreen({Key? key}) : super(key: key);

  @override
  _RentalListScreenState createState() => _RentalListScreenState();
}

class _RentalListScreenState extends State<RentalListScreen> {
  // ฟังก์ชันคืนเครื่องดนตรี (ลบรายการ)
  void _returnInstrument(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('คืนเครื่องดนตรี'),
        content: const Text('ต้องการคืนเครื่องดนตรีนี้หรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                rentalList.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: const Text('คืนเครื่องดนตรี',
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // ฟังก์ชันแก้ไขชื่อและเบอร์โทร
  void _editContactDetails(int index) {
    TextEditingController nameController =
        TextEditingController(text: rentalList[index].renterName);
    TextEditingController phoneController =
        TextEditingController(text: rentalList[index].renterPhone);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('แก้ไขข้อมูลผู้เช่า'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'ชื่อผู้เช่า'),
            ),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'เบอร์โทรศัพท์'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                rentalList[index] = InstrumentRental(
                  rentalID: rentalList[index].rentalID,
                  rentalDays: rentalList[index].rentalDays,
                  instrument: rentalList[index].instrument,
                  renterName: nameController.text,
                  renterPhone: phoneController.text,
                  startDate: rentalList[index].startDate,
                  endDate: rentalList[index].endDate,
                  totalCost: rentalList[index].totalCost,
                );
              });
              Navigator.pop(context);
            },
            child: const Text('บันทึก', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 101, 51, 218), // แถบสีม่วงที่ด้านบน
        title: const Text('รายการเช่า'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          },
        ),
      ),
      body: rentalList.isEmpty
          ? const Center(child: Text('ไม่มีรายการเช่า'))
          : ListView.builder(
              itemCount: rentalList.length,
              itemBuilder: (context, index) {
                final rental = rentalList[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('🎸 ${rental.instrument.name}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('👤 ชื่อ: ${rental.renterName}'),
                        Text('📞 เบอร์: ${rental.renterPhone}'),
                        Text('📅 วันที่เริ่ม: ${rental.startDate.toLocal()}'),
                        Text('📅 วันที่สิ้นสุด: ${rental.endDate.toLocal()}'),
                        Text(
                            '💰 ค่าเช่า: ฿${rental.totalCost.toStringAsFixed(2)}'),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => _editContactDetails(index),
                              icon: const Icon(Icons.edit, color: Colors.white),
                              label: const Text('แก้ไข'),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue),
                            ),
                            ElevatedButton.icon(
                              onPressed: () => _returnInstrument(index),
                              icon:
                                  const Icon(Icons.delete, color: Colors.white),
                              label: const Text('คืนเครื่องดนตรี'),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
