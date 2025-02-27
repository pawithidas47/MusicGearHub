import 'package:flutter/material.dart';
import 'instrument_detail_screen.dart';
import 'model/digital_instrument.dart';
import 'rental_list_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'ทั้งหมด';
  String searchQuery = '';

  final List<DigitalInstrument> instruments = [
    DigitalInstrument(instrumentID: 1, name: 'Keyboard X100', type: 'Keyboard', brand: 'Yamaha', pricePerDay: 200, imagePath: 'assets/images/aa.jpg'),
    DigitalInstrument(instrumentID: 2, name: 'Stage Piano P200', type: 'Keyboard', brand: 'Roland', pricePerDay: 300, imagePath: 'assets/images/a.jpg'),
    DigitalInstrument(instrumentID: 3, name: 'Digital Piano PX870', type: 'Keyboard', brand: 'Casio', pricePerDay: 250, imagePath: 'assets/images/b.jpg'),
    DigitalInstrument(instrumentID: 4, name: 'MIDI Keyboard MK300', type: 'Keyboard', brand: 'Akai', pricePerDay: 180, imagePath: 'assets/images/c.jpg'),
    DigitalInstrument(instrumentID: 5, name: 'Electric Guitar Z200', type: 'Guitar', brand: 'Fender', pricePerDay: 300, imagePath: 'assets/images/d.jpg'),
    DigitalInstrument(instrumentID: 6, name: 'Bass Guitar B500', type: 'Guitar', brand: 'Ibanez', pricePerDay: 280, imagePath: 'assets/images/e.jpg'),
    DigitalInstrument(instrumentID: 7, name: 'Acoustic Guitar A100', type: 'Guitar', brand: 'Taylor', pricePerDay: 220, imagePath: 'assets/images/f.jpg'),
    DigitalInstrument(instrumentID: 8, name: 'Jazz Guitar J300', type: 'Guitar', brand: 'Gibson', pricePerDay: 350, imagePath: 'assets/images/g.jpg'),
    DigitalInstrument(instrumentID: 9, name: 'Digital Drum D500', type: 'Drum', brand: 'Roland', pricePerDay: 400, imagePath: 'assets/images/h.jpg'),
    DigitalInstrument(instrumentID: 10, name: 'E-Drum Set E700', type: 'Drum', brand: 'Yamaha', pricePerDay: 450, imagePath: 'assets/images/i.jpg'),
    DigitalInstrument(instrumentID: 11, name: 'Compact Drum Pad CP300', type: 'Drum', brand: 'Alesis', pricePerDay: 300, imagePath: 'assets/images/j.jpg'),
    DigitalInstrument(instrumentID: 12, name: 'Synthesizer S700', type: 'Synthesizer', brand: 'Korg', pricePerDay: 350, imagePath: 'assets/images/k.jpg'),
    DigitalInstrument(instrumentID: 13, name: 'Analog Synth A500', type: 'Synthesizer', brand: 'Moog', pricePerDay: 400, imagePath: 'assets/images/m.jpg'),
    DigitalInstrument(instrumentID: 14, name: 'Modular Synth M800', type: 'Synthesizer', brand: 'Behringer', pricePerDay: 380, imagePath: 'assets/images/n.jpg'),
    DigitalInstrument(instrumentID: 15, name: 'Electronic Violin V900', type: 'Violin', brand: 'Yamaha', pricePerDay: 250, imagePath: 'assets/images/o.jpg'),
    DigitalInstrument(instrumentID: 16, name: 'Silent Violin SV100', type: 'Violin', brand: 'Roland', pricePerDay: 270, imagePath: 'assets/images/p.jpg'),
    DigitalInstrument(instrumentID: 17, name: 'MIDI Controller M300', type: 'Controller', brand: 'Akai', pricePerDay: 180, imagePath: 'assets/images/q.jpg'),
    DigitalInstrument(instrumentID: 18, name: 'DJ Controller DJX700', type: 'Controller', brand: 'Pioneer', pricePerDay: 280, imagePath: 'assets/images/r.jpg'),
    DigitalInstrument(instrumentID: 19, name: 'Mixing Console MX900', type: 'Controller', brand: 'Behringer', pricePerDay: 350, imagePath: 'assets/images/s.jpg'),
  ];

  @override
  Widget build(BuildContext context) {
    List<DigitalInstrument> filteredInstruments = instruments.where((instrument) {
      bool matchesCategory = selectedCategory == 'ทั้งหมด' || instrument.type == selectedCategory;
      bool matchesSearch = instrument.name.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Gear Hub'),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'ค้นหาเครื่องดนตรี...',
                      prefixIcon: Icon(Icons.search, color: Colors.deepPurple),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30), // ทำให้ช่องค้นหามุมมน
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: selectedCategory,
                  items: ['ทั้งหมด', 'Keyboard', 'Guitar', 'Drum', 'Synthesizer', 'Violin', 'Controller']
                      .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                  dropdownColor: Colors.white,
                  elevation: 8,
                  style: TextStyle(color: Colors.deepPurple),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredInstruments.length,
                itemBuilder: (context, index) {
                  final instrument = filteredInstruments[index];
                  return Card(
                    elevation: 8,
                    shadowColor: Colors.black45,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(instrument.imagePath, width: 60, height: 60, fit: BoxFit.cover),
                      ),
                      title: Text('${instrument.name} (${instrument.brand})', style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('ราคา: ${instrument.pricePerDay} บาท/วัน', style: TextStyle(color: Colors.grey[600])),
                      trailing: Icon(Icons.arrow_forward_ios, color: Colors.deepPurple),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InstrumentDetailScreen(instrument: instrument),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RentalListScreen(),
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'หน้าหลัก'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'รายการที่เช่า'),
        ],
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 10,
      ),
    );
  }
}
