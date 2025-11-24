<details>
<Summary><b>📃Daftar Anggota Kelompok</b></Summary>
    
1. A. Sheriqa Dewina Ihsan (2406360722)
2. Muhammad Rafi Sugianto (2406357135)
3. Elizabeth Meilanny Sitanggang (2406433522)
4. Vidia Qonita Ahmad (2406345381)
5. Angelo Johenry Apituley (2406428825)
6. Nisriina Wakhdah Haris (2406360445)

</details>

<details>
<Summary><b>⚽ Deskripsi Aplikasi</b></Summary>

Aplikasi "Beyond90" merupakan portal informasi olahraga yang berfokus pada dunia sepak bola profesional. Aplikasi ini dirancang untuk menjadi pusat informasi interaktif bagi penggemar sepak bola, dengan menyajikan data dan profil lengkap mengenai pemain, klub, dan statistik pertandingan dalam satu platform yang menarik dan mudah diakses.

Melalui Beyond90, pengguna dapat menjelajahi biodata pemain, melihat perjalanan karier mereka dari klub ke klub, hingga membandingkan performa pemain melalui statistik seperti jumlah gol, assist, dan kartu. Selain itu, pengguna juga dapat mengetahui pencapaian pemain dalam bentuk trofi, penghargaan individu, dan kontribusi mereka di berbagai kompetisi.

Aplikasi ini tidak hanya menyajikan informasi data mentah, tetapi juga dirancang dengan tampilan visual yang rapi dan responsif serta fitur interaktif seperti pencarian pemain, filter berdasarkan klub atau negara, dan kolom komentar bagi pengguna untuk berdiskusi.

Bagi penggemar sepak bola, Beyond90 memberikan pengalaman informatif dan menyenangkan untuk: - Mengenal lebih dekat idola mereka melalui profil pemain. - Melihat perbandingan performa antar pemain atau klub. - Menemukan klub dengan ranking dan statistik terbaik. - Berinteraksi dengan sesama penggemar melalui komentar dan diskusi.

Kebermanfaatan aplikasi ini juga dapat diperluas untuk pelajar, jurnalis olahraga, dan analis data, yang dapat memanfaatkan dataset pemain dan klub sebagai referensi dalam penulisan artikel, riset performa, atau pembuatan konten sepak bola.

</details>

<details> <Summary><b>📱 Daftar Modul Implementasi Flutter (Mobile Client)</b></Summary>

Aplikasi mobile ini dikembangkan menggunakan pendekatan modular, di mana setiap fitur utama dibangun sebagai modul mandiri yang ditempatkan dalam folder lib/screen/[nama_modul]. Pendekatan ini memastikan setiap bagian aplikasi mudah dikembangkan, diuji, dan dipelihara oleh anggota tim yang berbeda. Berikut adalah penjelasan menyeluruh mengenai setiap modul yang telah diimplementasikan.

1. Modul Pemain (players) — Muhammad Rafi Sugianto
    Modul pemain menangani seluruh halaman yang berhubungan dengan data pemain. Struktur datanya dibuat lewat beberapa model seperti Player,         CareerHistory, SeasonStats, dan Achievement. Semua model ini bertugas mengubah data JSON dari API jadi objek yang bisa dipakai di aplikasi.
    Untuk berkomunikasi dengan server, modul ini memakai PlayerApiService, yang berfungsi mengambil daftar pemain, detail pemain, maupun riwayat dan statistik musiman.
    
    Tampilan utamanya ada tiga:
        - PlayerListScreen untuk menampilkan daftar pemain,
        - PlayerDetailScreen untuk melihat informasi lengkap seorang pemain,
        - PlayerCard, widget kecil untuk menampilkan ringkasan pemain di dalam list.
2. Modul Klub (clubs) — Elizabeth Meilanny Sitanggang
    Modul klub berisi seluruh informasi mengenai klub, termasuk profil dan ranking. Datanya ditangani oleh model Club dan ClubRanking.
    Semua pemanggilan API dilakukan lewat ClubApiService—mulai dari mengambil daftar klub sampai detail dan ranking musimannya.
    Halaman yang ditampilkan ke pengguna:
        - ClubListScreen untuk daftar klub,
        - ClubDetailScreen untuk deskripsi lengkap,
        - ClubRankingScreen untuk melihat ranking klub di musim tertentu.
3. Modul Event (events) — Vidia Qonita Ahmad
    Modul event digunakan untuk menampilkan kompetisi yang sedang berlangsung atau pernah berlangsung, beserta siapa saja yang ikut di dalamnya. Struktur data event disusun lewat model Event dan EventParticipation.
    EventApiService menangani operasi API, termasuk mengambil daftar event, detail event, dan mengelola data partisipasi (khusus admin).
    Untuk tampilan, tersedia:
        - EventListScreen, daftar event,
        - EventDetailScreen, yang menunjukkan detail dan daftar peserta event.
4. Modul Pencarian (search) — A. Sheriqa Dewina Ihsan
    Modul pencarian memudahkan pengguna menemukan pemain atau klub berdasarkan kata kunci tertentu. Modul ini memanfaatkan PlayerApiService dan ClubApiService untuk mengambil data sesuai parameter pencarian.
    Fitur riwayat pencarian ini dapat:
        - menyimpan history,
        - menghapus satu item history, bahkan menghapus seluruh history jika pengguna ingin membersihkan semuanya.
    Antarmukanya terdiri dari:
        - SearchScreen sebagai halaman input pencarian,
        - SearchResultsWidget untuk menampilkan hasil,
        - SearchHistoryWidget untuk menampilkan daftar riwayat dan tombol delete/delete all.
5. Modul Komentar (comments) — Angelo Johenry Apituley
    Modul komentar dipakai untuk menampilkan dan mengelola komentar pada halaman pemain maupun klub. Datanya diatur oleh CommentModel, sedangkan CommentApiService mengurus GET, POST, PUT, dan DELETE komentar.
    Di bagian UI, tersedia:
        - CommentSectionWidget yang ditaruh di halaman detail pemain atau klub,
        - CommentForm untuk menulis komentar baru.
6. Modul Galeri Media (media_gallery) — Nisriina Wakhdah Haris
    Modul ini menangani tampilan foto dan video terkait pemain atau klub. Data disusun lewat MediaModel.
    API-nya dikelola lewat MediaApiService: mengambil daftar media, menambah media baru, mengedit, atau menghapus media—khususnya untuk admin.
    Tampilan yang disediakan:
        - GalleryListScreen untuk melihat galeri,
        - MediaUploadForm untuk admin mengunggah foto atau video.
        
</details>
<details>
<Summary><b>📚Sumber initial dataset kategori utama produk</b></Summary>

Sumber Dataset: <br>
1. Dataset untuk Player: https://www.kaggle.com/datasets/vivovinco/20222023-football-player-stats <br>
2. Dataset untuk Club: https://www.kaggle.com/datasets/vivovinco/20222023-football-team-stats <br>
Deskripsi Singkat: Dataset ini berisi statistik lengkap pemain sepak bola dari berbagai liga dunia pada musim 2022–2023, mencakup nama pemain, klub, posisi, jumlah pertandingan, gol, assist, dan metrik performa lainnya.

</details>

<details>
<Summary><b>👤 Role Pengguna</b></Summary>

1. Pengunjung (User Biasa)
    - Melihat profil pemain & klub. 
    - Menggunakan fitur pencarian & filter. 
    - Memberikan komentar. 
2. Admin 
    - Mengelola data pemain, klub, dan event
    - Mengelola komentar. 
    - Mengupload media (foto/video).

</details>

<details>
<Summary><b>🖇️Tautan deployment PWS dan link design</b></Summary> 

1. PWS = https://pbp.cs.ui.ac.id/a.sheriqa/beyond-90
2. Link Design = ristek.link/figmaB11

</details>

<details>
    <Summary><b>📲Penjelasan Alur Pengintegrasian Data Aplikasi dengan Aplikasi Web (PWS) Berbasis Web Service</b></Summary>

Integrasi data antara aplikasi (ex: aplikasi mobile atau desktop) dengan aplikasi web (PWS) dilakukan melalui sebuah web service yang berfungsi sebagai perantara komunikasi antara client dan server. Berikut ini adalah alur pengintegrasiannya:

1. Client mengirimkan Request ke Web Service<br>
   Aplikasi client tidak dapat berkomunikasi langsung dengan database namun hanya bisa mengakses data melalui endpoint API yang disediakan oleh PWS. Request biasanya berupa HTPP, yaitu GET, POST, PUT/PATCH, dan DELETE

2. Web service menerima dan memvalidasi request<br>
   Setelah client mengirimkan request, PWS akan menerima request tersebut dan mengecek format data, parameter, autentikasi, dan memastikan request sesuai dengan aturan API. Apabila request dari client tidak valid, maka PWS akan mengembalikan error ke client

3. Web service berinteraksi dengan database<br>
   Jika request dari client valid, maka web service akan mengolah data sesuai logika yang sudah dibuat pada aplikasi sebelumnya, seperti add, update, dan delete data

4. Web sevice mengembalikan response ke client<br>
   Setelah proses yang berkaitan dengan database selesai, API akan mengirimkan response dalam format JSON yang berisi status, pesan yang sesuai, dan data yang dihasilkan pada tahap sebelumnya (jika ada)

5. Client menampilkan atau mengolah data<br>
   Aplikasi client akan menerima JSON yang dikirimkan oleh web service dan kemudian terdapat beberapa hal yang dapat dilakukan, seperti:
   - Menampilkannya ke user
   - Menyimpannya ke dalam local storage
   - Memperbarui tampilan UI
   - Menampilkan pesan error
    
</details>
