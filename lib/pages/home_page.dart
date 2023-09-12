import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:simohin/pages/add_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Stream<QuerySnapshot> simohins =
      FirebaseFirestore.instance.collection('simohin').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // welcome card
            CardWelcome(),
            Padding(
              padding: const EdgeInsets.only(left: 24, top: 12),
              child: Text(
                "Riwayat Pengukuran",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 24),
            // CardPengukuran(),
            // get data from database
            StreamBuilder<QuerySnapshot>(
              stream: simohins,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                // jika terjadi error
                if (snapshot.hasError) {
                  return Center(child: Text("terjadi kesalahan"));
                }

                // check apakah ada data
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Center(
                      child: Container(
                        height: 200,
                        width: 200,
                        child: Lottie.asset(
                          'assets/lotties/loading_action.json', // Lokasi berkas Lottie di dalam assets
                          // Atur parameter sesuai kebutuhan
                        ),
                      ),
                    ),
                  );
                }
                // jika terdapat data
                final data = snapshot.requireData;
                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.size,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 24, right: 24, bottom: 24),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                16), // Atur radius sesuai keinginan
                            side: BorderSide(
                              color: Color.fromARGB(
                                  255, 243, 188, 188), // Set border color here
                              width: 2, // Set border width here
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Nama: ${data.docs[index]['nama']}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400)),
                                SizedBox(height: 4),
                                Text("Usia: ${data.docs[index]['usia']}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400)),
                                SizedBox(height: 4),
                                Text(
                                    "Detak Jantung: ${data.docs[index]['pulse']} bpm",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400)),
                                SizedBox(height: 8),
                                Divider(
                                  color: Colors.grey.withOpacity(0.7),
                                  height:
                                      3, // Atur tinggi garis sesuai kebutuhan
                                  thickness:
                                      0.8, // Atur ketebalan garis sesuai kebutuhan
                                ),
                                SizedBox(height: 8),
                                Center(
                                    child: Text("Tekanan Darah",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400))),
                                SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text("Sistolik",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400)),
                                    Text("Diastolik",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400)),
                                    // Text("Klasifikasi",
                                    //     style: TextStyle(
                                    //         fontSize: 16,
                                    //         fontWeight: FontWeight.w400)),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Divider(
                                  color: Colors.grey.withOpacity(0.7),
                                  height:
                                      3, // Atur tinggi garis sesuai kebutuhan
                                  thickness:
                                      0.8, // Atur ketebalan garis sesuai kebutuhan
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text("${data.docs[index]['sistolik']}",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400)),
                                    Text("${data.docs[index]['diastolik']}",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400)),
                                    // Text("Normal",
                                    //     style: TextStyle(
                                    //         fontSize: 16,
                                    //         fontWeight: FontWeight.w400)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// welcome card
class CardWelcome extends StatelessWidget {
  const CardWelcome({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(16), // Atur radius sesuai keinginan
          side: BorderSide(
            color: Color.fromARGB(255, 250, 129, 129), // Set border color here
            width: 2, // Set border width here
          ),
        ),
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height / 2.5,
          child: Padding(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Hallo, Selamat datang..",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    )),
                SizedBox(height: 20),
                Text(
                    "Rutinlah memeriksa tekanan darah secara berkala sebagai langkah preventif untuk menjaga kesehatan ",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1)),
                SizedBox(height: 12),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddPage(),
                        )),
                    child: Text("Periksalah"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*
card content 

*/
