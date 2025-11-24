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

Setiap modul diimplementasikan sebagai fitur independen dalam folder lib/screen/[nama_modul].

1. Manajemen Data Pemain (Feature: players) (Muhammad Rafi Sugianto)

    Fokus: Pengambilan data profil dan statistik pemain dari API.

  - Data Models (lib/screen/players/data/models/):
  
    player_model.dart (Player, CareerHistory, SeasonStats, Achievement) → Struktur data untuk deserialisasi JSON.
  
  - API Services (lib/screen/players/data/services/):
  
    player_api_service.dart → Logika pemanggilan endpoint API untuk GET Daftar, Detail, Riwayat, dan Statistik pemain.
  
  - Presentation (lib/screen/players/presentation/):
  
    PlayerListScreen (screen/player_list_screen.dart) → Menampilkan daftar pemain.
  
    PlayerDetailScreen (screen/player_detail_screen.dart) → Menampilkan detail profil, statistik, riwayat karier, dan pencapaian.
  
    PlayerCard (widgets/player_card.dart) → Widget kartu untuk ringkasan pemain dalam daftar.

2. Manajemen Data Klub (Feature: clubs) (Elizabeth Meilanny Sitanggang)

    Fokus: Pengambilan data profil klub dan ranking.

  - Data Models (lib/screen/clubs/data/models/):
  
    club_model.dart (Club, ClubRanking) → Struktur data untuk deserialisasi JSON.
  
  - API Services (lib/screen/clubs/data/services/):
  
    club_api_service.dart → Logika pemanggilan endpoint API untuk GET Daftar Klub, Detail Klub, dan Ranking Musiman.
  
  - Presentation (lib/screen/clubs/presentation/):
  
    ClubListScreen (screen/club_list_screen.dart) → Menampilkan daftar klub.
  
    ClubDetailScreen (screen/club_detail_screen.dart) → Menampilkan detail informasi klub.
    
    ClubRankingScreen (screen/ranking_list_screen.dart) → Menampilkan daftar ranking klub.

3. Event Kompetisi (Feature: events) (Vidia Qonita Ahmad)

    Fokus: Menampilkan informasi event dan partisipan.

  - Data Models (lib/screen/events/data/models/):
  
    event_model.dart (Event, EventParticipation) → Struktur data event dan partisipasi.
  
  - API Services (lib/screen/events/data/services/):
  
    event_api_service.dart → Logika pemanggilan API untuk GET Daftar Event dan Detail Event.
  
  - Fungsi untuk POST/PUT/DELETE data Partisipasi (untuk admin).
  
    Presentation (lib/screen/events/presentation/):
  
    EventListScreen (screen/event_list_screen.dart) → Menampilkan daftar event.
  
    EventDetailScreen (screen/event_detail_screen.dart) → Menampilkan detail event dan daftar partisipan.

4. Pencarian & Filter (Feature: search) (A. Sheriqa Dewina Ihsan)

    Fokus: Menerjemahkan input pengguna menjadi parameter API dan menampilkan hasil gabungan.

  - API Interaction (lib/screen/search/data/services/):
  
    Menggunakan PlayerApiService dan ClubApiService yang sudah ada, dengan penambahan parameter query / filter.
  
  - State Management (lib/screen/search/presentation/bloc/):
  
    SearchBloc/Cubit → Mengelola state kata kunci, jenis pencarian (pemain/klub), dan status loading hasil.
  
  - Presentation (lib/screen/search/presentation/):
  
    SearchScreen (screen/search_screen.dart) → Antarmuka untuk input pencarian.
    
    SearchResultsWidget (widgets/search_results_widget.dart) → Menampilkan hasil yang dikelompokkan (pemain/klub) dari Views search_players / search_clubs API.
  
    SearchHistoryWidget (widgets/search_history_widget.dart) → Menampilkan riwayat pencarian pengguna (opsional: penyimpanan lokal).

5. Komentar & Interaksi Pengguna (Feature: comments) (Angelo Johenry Apituley)

    Fokus: Mengelola interaksi pengguna (CRUD komentar) terkait entitas (pemain/klub).

  - Data Models (lib/screen/comments/data/models/):
  
    comment_model.dart → Struktur data komentar.
  
  - API Services (lib/screen/comments/data/services/):
  
    comment_api_service.dart → Logika GET daftar komentar, POST komentar baru, PUT/DELETE komentar (membutuhkan otorisasi).
  
  - Presentation (lib/screen/comments/presentation/):
  
    CommentSectionWidget (widgets/comment_section_widget.dart) → Widget yang dapat disematkan di Detail Pemain (PlayerDetailScreen) atau Detail Klub (ClubDetailScreen).
  
    CommentForm (widgets/comment_form.dart) → Input komentar baru.

6. Galeri Media (Feature: media_gallery) (Nisriina Wakhdah Haris)

    Fokus: Menampilkan media (foto/video) terkait pemain atau klub.

  - Data Models (lib/screen/media_gallery/data/models/):
  
    media_model.dart → Struktur data media.
  
  - API Services (lib/screen/media_gallery/data/services/):
  
    media_api_service.dart → Logika GET daftar media dan POST/PUT/DELETE media (khusus admin, memerlukan penanganan multipart form-data untuk upload file).
  
  - Presentation (lib/screen/media_gallery/presentation/):
  
    GalleryListScreen (screen/gallery_list_screen.dart) → Menampilkan galeri foto/video untuk entitas terkait.
  
    MediaUploadForm (widgets/media_upload_form.dart) → Form untuk upload media (khusus admin).
    
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

1. Client mengirimkan Request ke Web Service
   Aplikasi client tidak dapat berkomunikasi langsung dengan database namun hanya bisa mengakses data melalui endpoint API yang disediakan oleh PWS. Request biasanya berupa HTPP, yaitu GET, POST, PUT/PATCH, dan DELETE

2. Web service menerima dan memvalidasi request
   Setelah client mengirimkan request, PWS akan menerima request tersebut dan mengecek format data, parameter, autentikasi, dan memastikan request sesuai dengan aturan API. Apabila request dari client tidak valid, maka PWS akan mengembalikan error ke client

3. Web service berinteraksi dengan database
   Jika request dari client valid, maka web service akan mengolah data sesuai logika yang sudah dibuat pada aplikasi sebelumnya, seperti add, update, dan delete data

4. Web sevice mengembalikan response ke client
   Setelah proses yang berkaitan dengan database selesai, API akan mengirimkan response dalam format JSON yang berisi status, pesan yang sesuai, dan data yang dihasilkan pada tahap sebelumnya (jika ada)

5. Client menampilkan atau mengolah data
   Aplikasi client akan menerima JSON yang dikirimkan oleh web service dan kemudian terdapat beberapa hal yang dapat dilakukan, seperti:
   - Menampilkannya ke user
   - Menyimpannya ke dalam local storage
   - Memperbarui tampilan UI
   - Menampilkan pesan error
    
</details>
