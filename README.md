# PBP Kelompok A03 - ReadMe

[![Development](https://github.com/PeBePe/readme-mobile/actions/workflows/development.yml/badge.svg)](https://github.com/PeBePe/readme-mobile/actions/workflows/development.yml)
[![Pre-Release](https://github.com/PeBePe/readme-mobile/actions/workflows/pre-release.yml/badge.svg)](https://github.com/PeBePe/readme-mobile/actions/workflows/pre-release.yml)
[![Release](https://github.com/PeBePe/readme-mobile/actions/workflows/release.yml/badge.svg)](https://github.com/PeBePe/readme-mobile/actions/workflows/release.yml)
[![Build status](https://build.appcenter.ms/v0.1/apps/2d3b6ed5-320d-49b8-839c-914eec592af9/branches/main/badge)](https://appcenter.ms)

📱[Tautan APK](https://install.appcenter.ms/orgs/pebepe-a03/apps/readme/distribution_groups/public)📱

🗓️[Tautan Berita Acara](https://docs.google.com/spreadsheets/d/1FQarcMZwNFbVh-kgUBArrFmDKMuh1LxWWnzMtjlbBY0/edit#gid=1658173906)🗓️

<details>
    <summary>Anggota Kelompok</summary>

## Anggota Kelompok
- Muhammad Daffa'I Rafi Prasetyo (2206029191)
- Rafi Irsyad Saharso (2206082221)
- Khalisha Hana Aida Putri (2206081484)
- Fahmi Ramadhan (2206026473)
- Nabiilah Putri Safa (2206030426)
</details>

<details>
    <summary>Cerita Aplikasi</summary>

## Cerita Aplikasi
ReadMe adalah aplikasi yang kami buat untuk meningkatkan tingkat literasi di kalangan masyarakat Indonesia dari segala usia. Aplikasi ini menawarkan serangkaian fitur yang memungkinkan pengguna untuk berinteraksi dengan dunia literasi dan buku dengan sangat menarik. Berikut adalah beberapa fitur utama dari aplikasi ReadMe:

1. **_Loyalty Points_**:
Pengguna akan mendapatkan _loyalty points_ sebagai bentuk penghargaan setiap kali mereka berkontribusi di dalam aplikasi. _Loyalty points_ dapat dikumpulkan dan diperoleh melalui berbagai kegiatan seperti memberikan _review_, membagikan _post_, atau membuat _quotes_. Hal ini dapat memberikan insentif bagi pengguna untuk menambah semangat membaca dan berliterasi.

2. **_Review_ Buku**:
Pengguna dapat memberikan ulasan terhadap buku-buku yang telah mereka baca. Setiap ulasan memberikan pengguna _loyalty points_ yang dapat dikumpulkan dan digunakan untuk membeli lebih banyak buku di dalam fitur _shop_. Hal ini mendorong pengguna untuk semangat berpartisipasi aktif dalam aplikasi.

3. **_Posting_**:
Fitur _Posting_ memungkinkan pengguna untuk berbagi pemikiran, ulasan, diskusi, atau rekomendasi terkait buku. Terdapat fitur _like_ di tiap unggahan dan pengguna mendapatkan loyalty points berdasarkan jumlah _like_ yang diterima. Hal ini tentu dapat menciptakan interaksi sosial yang lebih aktif dan memperluas wawasan literasi.

4. **_Quotes_**:
Pengguna dapat membuat _quote_ inspiratif atau berbagi _quote_ dari buku yang mereka suka. Mereka dapat mengutip maksimal tiga _quote_ dari orang lain. _Quotes_ yang dikutip ini akan ditampilkan pada halaman profil pengguna, memberikan pengguna kesempatan untuk berbagi pemikiran dan ide-ide favorit mereka. _Loyalty points_ diberikan berdasarkan jumlah _quote_ buatan pengguna yang dikutip oleh pengguna lain.

5. **_Shop_ dan Penggunaan _Loyalty Points_**:
Fitur Shop memungkinkan pengguna untuk menggunakan loyalty points yang mereka kumpulkan untuk mendapatkan buku yang mereka inginkan. Ini menciptakan insentif tambahan bagi pengguna untuk terus berpartisipasi dalam komunitas literasi dan memberikan nilai nyata pada setiap kontribusi mereka.

6. **_Wishlist_**:
Pengguna dapat membuat daftar buku yang ingin mereka baca di masa mendatang melalui fitur _Wishlist_. Hal ini memudahkan pengguna untuk melacak dan menemukan buku-buku yang menarik minat mereka.

Dengan fitur-fitur ini, Kami berharap aplikasi ReadMe tidak hanya menjadi platform literasi yang interaktif tetapi juga dapat membangun komunitas di sekitar kecintaan terhadap membaca. Aplikasi ini bertujuan untuk menciptakan lingkungan yang mendukung pertukaran ide dan pengalaman literasi, menjadikan literasi sebagai pengalaman yang lebih berharga.
</details>

<details>
    <summary>Daftar modul</summary>

## Daftar Modul
Berikut adalah modul-modul yang akan kami implementasikan.
1. Modul Review (PIC: Muhammad Daffa'I Rafi Prasetyo) :
    - Pengguna bisa memberikan review terhadap buku. (Create)
    - Pengguna bisa melihat review yang diberikan oleh dirinya dan Pengguna yang lain. (Read)
    - Pengguna bisa menghapus review miliknya. (Delete)
    - Pengguna bisa mengedit review yang diberikan. (Update)
    - Pengguna akan mendapatkan loyalty setiap review yang ia diberikan.
    - Loyalty bisa digunakan untuk menukar buku pada shop.
1. Modul Shop (PIC: Fahmi Ramadhan) :
    - Pengguna bisa melihat list buku yang dapat ditukar beserta stok dll. (View)
    - Pengguna bisa melihat detail buku. (View)
    - Pengguna bisa memasukkan buku ke keranjang. (Create).
    - Pengguna bisa mengedit stok buku yang hendak dibeli pada keranjang. (Update)
    - Pengguna bisa checkout buku yang berhasil masuk ke keranjang, dan buku yang di keranjang akan menjadi kosong. (Delete)
    - Poin loyalty Pengguna akan berkurang sesuai total harga yang tertulis di keranjang. (Update)
    - Setelah berhasil membeli buku, buku yang berada pada toko akan berkurang (Update)
    - Buku yang berhasil di checkout masuk ke inventory Pengguna (Create).
2. Modul Post (PIC: Rafi Irsyad Saharso) :
    - Pengguna bisa membagikan sesuatu dalam bentuk posting yang berkaitan dengan buku (Create)
    - Pengguna bisa melihat postingan orang lain (View)
    - Pengguna bisa mengedit postingan miliknya sendiri (Update)
    - Pengguna bisa menghapus postingan miliknya sendiri (Delete)
    - Pengguna bisa memberikan like terhadap postingan (Update)
    - Pengguna mendapatkan sejumlah loyalty poin tiap like yang di dapat dari postingannya (Update)
3. Modul Quotes (PIC: Khalisha Hana Aida Putri) :
    - Pengguna bisa membuat quotes, hanya 1 quote diperbolehkan untuk 1 akun (Create)
    - Pengguna bisa mencari dan melihat quotes buatan orang lain (View)
    - Pada tampilan daftar quotes, akan ditampilkan berapa banyak quote tersebut digunakan oleh Pengguna lain. (View)
    - Pengguna dapat mengutip quotes buatan orang lain sebanyak maksimal 3 quotes (Update)
    - Quotes yang dikutip oleh pengguna akan tampil pada halaman profile (Update).
    - Pembuat quote akan mendapatkan sejumlah poin loyalty tiap quote buatannya dikutip oleh Pengguna lain. (Update)
    - Pengguna dapat menghapus quotes buatannya sendiri (Delete)
    - Pengguna dapat mengedit quotes buatannya sendiri (Update)
4. Modul Wishlist (PIC: Nabiilah Putri Safa) : 
    - Pengguna bisa menambahkan buku ke wishlist. (Create).
    - Pengguna bisa membuat note saat menambahkan buku ke wishlist (Create).
    - Pengguna bisa mengedit/menghapus note yang sudah dibuat sebelumnya (Update).
    - Terdapat halaman untuk menampilkan buku-buku yang sudah dimasukkan ke wishlist (View).
    - Pengguna bisa menggunakan fitur search untuk mencari buku yang sudah dimasukkan ke wishlist (View).
    - Pengguna bisa menghapus buku dari wishlist (Delete).

</details>

<details>
    <summary>Role Pengguna</summary>

## Role Pengguna
Hanya terdapat 1 role pada aplikasi kami yaitu role Pengguna atau User yang dapat mengakses semua fitur diatas. User memiliki akses penuh ke seluruh fitur aplikasi, termasuk memberikan ulasan terhadap buku, membuat posting, menciptakan kutipan, berbelanja dengan loyalty points, dan mengelola daftar buku di Wishlist. Mereka dapat berpartisipasi secara aktif dalam aplikasi kami, berinteraksi dengan pengguna lain, dan mendapatkan loyalty points sebagai bentuk penghargaan atas kontribusi mereka dalam membangun pengalaman berliterasi dan membaca.
</details>

<details>
    <summary>Alur Pengintegrasian dengan Aplikasi Web</summary>
Berikut adalah langkah-langkah yang akan dilakukan untuk mengintegrasikan aplikasi dengan server web.

1. Mengimplementasikan sebuah wrapper class dengan menggunakan library http dan map untuk mendukung penggunaan cookie-based authentication pada aplikasi.
2. Mengimplementasikan REST API pada Django (views.py) dengan menggunakan JsonResponse atau Django JSON Serializer.
3. Mengimplementasikan desain front-end untuk aplikasi berdasarkan desain website yang sudah ada sebelumnya.
4. Melakukan integrasi antara front-end dengan back-end dengan menggunakan konsep asynchronous HTTP.
</details>
