import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:simohin/pages/home_page.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class AddPage extends StatelessWidget {
  // variabel global
  final GlobalKey<_HasilPengukuranState> hasilPengukuran = GlobalKey();
// firebase
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  // controller
  TextEditingController namaC = TextEditingController();
  TextEditingController usiaC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pengukuran"),
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ));
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // nama
              TextField(
                controller: namaC,
                autocorrect: false,
                maxLength: 24,
                keyboardType: TextInputType.name,
                toolbarOptions: ToolbarOptions(copy: true, paste: true),
                decoration: InputDecoration(
                    label: Text(
                  "Nama",
                  style: TextStyle(color: Colors.grey),
                )),
              ),
              // tanggal lahir
              TextField(
                controller: usiaC,
                autocorrect: false,
                maxLength: 3,
                keyboardType: TextInputType.number,
                toolbarOptions: ToolbarOptions(copy: true, paste: true),
                decoration: InputDecoration(
                  label: Text(
                    "Usia/tahun",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              // Pengukuran
              Center(
                child: Text(
                  "Pengukuran",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(height: 24),
              HasilPengukuran(key: hasilPengukuran),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
          margin: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          width: double.infinity,
          height: 47,
          child: ElevatedButton(
              onPressed: () {
                // data pengukuran
                var diastolik = hasilPengukuran.currentState?.diastolik;
                var sistolik = hasilPengukuran.currentState?.sistolik;
                var pulse = hasilPengukuran.currentState?.pulse;
                // send data to firestore
                firestore.collection('simohin').add({
                  'nama': namaC.text,
                  'usia': int.parse(usiaC.text),
                  'diastolik': diastolik,
                  'sistolik': sistolik,
                  'pulse': pulse,
                });
                // pindah ke halaman home dan data berhasil dikirim
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ));
// snackbar data berhasil disimpan
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('berhasil'),
                      content: Text('Data Berhasil di Simpan'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Menutup dialog
                          },
                          child: Text('Tutup'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text("Simpan Data"))),
    );
  }
}

class LoadingIndikator extends StatefulWidget {
  const LoadingIndikator({
    Key? key,
  }) : super(key: key);

  @override
  State<LoadingIndikator> createState() => _LoadingIndikatorState();
}

class _LoadingIndikatorState extends State<LoadingIndikator> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      width: 140,
      child: Lottie.asset(
        'assets/lotties/loading_add-data.json', // Lokasi berkas Lottie di dalam assets
        // Atur parameter sesuai kebutuhan
      ),
    );
  }
}

class LoadingIndikatorNilai extends StatelessWidget {
  const LoadingIndikatorNilai({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      width: 25,
      child: Lottie.asset(
        'assets/lotties/loading.json', // Lokasi berkas Lottie di dalam assets
        // Atur parameter sesuai kebutuhan
      ),
    );
  }
}

class HasilPengukuran extends StatefulWidget {
  const HasilPengukuran({super.key});

  @override
  State<HasilPengukuran> createState() => _HasilPengukuranState();
}

class _HasilPengukuranState extends State<HasilPengukuran> {
  // firebase
  final DatabaseReference _databaseReference =
      // ignore: deprecated_member_use
      FirebaseDatabase.instance.reference();
  // controller

  // variabel pengukuran
  var diastolik = 0;
  var sistolik = 0;
  var pulse = 0;
  bool isLoading = false;

  void myDelayedFunction() {
    print('Delayed function executed!');
    setState(() {
      isLoading = false; // Set isLoading kembali ke false setelah selesai
    });
  }

  void executeDelayedFunction() {
    setState(() {
      isLoading = true; // Menampilkan indikator loading
    });
  }

// diastolik
  Future<void> fetchDiastolik() async {
    // firebase instance
    // ignore: deprecated_member_use
    // diastolik
    final response = await http.get(Uri.parse(
        'https://tugas-akhir-f9264-default-rtdb.asia-southeast1.firebasedatabase.app/diastolik.json'));
    if (response.statusCode == 200) {
      // Data berhasil diambil
      var responseData = jsonDecode(response.body);
      setState(() {
        var diastolik_balita = responseData['diastolik_balita'];
        diastolik = diastolik_balita;
      });
    } else {
      // Gagal mengambil data
      print('Failed to fetch data. Status code: ${response.statusCode}');
    }
  }

  // sistolik
  Future<void> fetchSistolik() async {
    final response = await http.get(Uri.parse(
        'https://tugas-akhir-f9264-default-rtdb.asia-southeast1.firebasedatabase.app/sistolik.json'));
    if (response.statusCode == 200) {
      // Data berhasil diambil
      var responseData = jsonDecode(response.body);
      setState(() {
        var sistolik_balita = responseData['sistolik_balita'];
        sistolik = sistolik_balita;
      });
    } else {
      // Gagal mengambil data
      print('Failed to fetch data. Status code: ${response.statusCode}');
    }
  }

  // diastolik
  Future<void> fetchDetak() async {
    final response = await http.get(Uri.parse(
        'https://tugas-akhir-f9264-default-rtdb.asia-southeast1.firebasedatabase.app/detak.json'));
    print(response.statusCode);
    if (response.statusCode == 200) {
      // Data berhasil diambil
      var responseData = jsonDecode(response.body);
      setState(() {
        var detak_jantung = responseData['detak_jantung'];
        pulse = detak_jantung;
      });
    } else {
      // Gagal mengambil data
      print('Failed to fetch data. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    print("ini is load: $isLoading");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // header
            Text(
              "Detak Jantung",
              style: TextStyle(color: Colors.grey),
            ),
            Text(
              "Sistolik",
              style: TextStyle(color: Colors.grey),
            ),
            Text(
              "Diastolik",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        SizedBox(height: 8),
        Divider(
          color: Colors.grey.withOpacity(0.7),
          height: 3, // Atur tinggi garis sesuai kebutuhan
          thickness: 0.8, // Atur ketebalan garis sesuai kebutuhan
        ),
        SizedBox(height: 8),
        // data dari api
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Text(
                "$pulse",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            Container(
              child: Text(
                "$sistolik",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            Container(
              child: Text(
                "$diastolik",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Align(
          alignment: Alignment.bottomRight,
          child: ElevatedButton(
              onPressed: () async {
                executeDelayedFunction();
                // perbarui variabel diastolik
                print("tombol ditekan");
                // _databaseReference
                //     .child('diastolik')
                //     .update({'diastolik_balita': 0});
                // // perbarui variabel diastolik
                // _databaseReference
                //     .child('sistolik')
                //     .update({'sistolik_balita': 0});
                // // perbarui variabel diastolik
                // _databaseReference.child('detak').update({'detak_jantung': 0});
                // data terbaru
                await Future.delayed(
                  Duration(seconds: 72),
                  () {
                    fetchDiastolik();
                    fetchSistolik();
                    fetchDetak();
                  },
                );
                print("proses selesai selama 1 menit");
                myDelayedFunction();
              },
              child: Icon(Icons.add)),
        ),
        SizedBox(height: 8),
        isLoading == true ? Center(child: LoadingIndikator()) : SizedBox(),
      ],
    );
  }
}
