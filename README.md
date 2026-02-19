# 📚 Belajar Redis Dasar

## 📑 Daftar Isi

1. [Pengaturan Container Docker](#-pengaturan-container-docker)
2. [Pemilihan Database](#-pemilihan-database)
3. [Operasi String](#-operasi-string)
4. [Operasi Range Data String](#-operasi-range-data-string)
5. [Operasi Multiple Data String](#-operasi-multiple-data-string)
6. [Operasi Expiration (TTL)](#-operasi-expiration-ttl)
7. [Operasi Increment & Decrement](#-operasi-increment--decrement)
8. [Operasi Flush Database](#-operasi-flush-database)
9. [Pipeline](#-pipeline)
10. [Transaksi (Transaction)](#-transaksi-transaction)
11. [Monitoring](#-monitoring)
12. [Informasi Server](#-informasi-server)
13. [Koneksi Client](#-koneksi-client)
14. [Protected Mode](#-protected-mode)
15. [Security & Authentication](#-security--authentication)
16. [Persistence (Penyimpanan Data)](#-persistence-penyimpanan-data)
17. [Eviction Policy](#-eviction-policy)
18. [Struktur Data di Redis](#-struktur-data-di-redis)

---

## 🐳 Pengaturan Container Docker

### Menjalankan Redis di Docker

Untuk memulai Redis server dalam container Docker dengan konfigurasi custom, gunakan perintah berikut:

```bash
docker run -d --name belajarredis -p 7070:6379 \
  -v "D:\belajar-redis-dasar\redis.conf:/custom/redis.conf" \
  -v "D:\belajar-redis-dasar\data:/data" \
  redis:latest redis-server /custom/redis.conf
```

**Penjelasan:**

- `-d` : Menjalankan container di background
- `--name belajarredis` : Memberikan nama container
- `-p 7070:6379` : Memetakan port lokal 7070 ke port Redis 6379
- `-v` : Melakukan volume mounting untuk config dan data persistence

---

## 🔄 Pemilihan Database

Redis memiliki multiple databases (default 25 databases). Untuk berpindah antar database, gunakan command `SELECT`:

```bash
select 0      # Beralih ke database 0 (default)
select 3      # Beralih ke database 3
select 27     # Beralih ke database 27
```

**Catatan:** Jumlah database dapat dikonfigurasi di `redis.conf` dengan directive `databases`

---

## 📝 Operasi String

String adalah tipe data paling dasar di Redis. Operasi yang dapat dilakukan:

### SET & GET

Menyimpan dan mengambil nilai string:

```bash
set name "Ibrohim"      # Menyimpan value pada key 'name'
get name                # Mengambil value dari key 'name'
```

### EXISTS

Mengecek keberadaan key:

```bash
exists name keylain     # Cek apakah key 'name' atau 'keylain' ada
```

### KEYS

Mencari key berdasarkan pattern:

```bash
keys *                  # Menampilkan semua key
keys na*               # Menampilkan key yang dimulai dengan 'na'
```

### APPEND

Menambahkan text ke akhir value:

```bash
append name " Sairony"  # Menambahkan " Sairony" ke value 'name'
```

### DEL

Menghapus key:

```bash
del name                # Menghapus key 'name'
```

---

## 📍 Operasi Range Data String

Operasi untuk memanipulasi sebagian dari string value:

### SETRANGE

Menimpa sebagian string dari posisi tertentu:

```bash
setrange name 7 " Hendra"  # Menimpa value 'name' mulai dari posisi 7
```

### GETRANGE

Mengambil sebagian dari string:

```bash
getrange name 7 13          # Mengambil karakter dari posisi 7 sampai 13
```

**Catatan:** Posisi string dimulai dari 0

---

## 🔗 Operasi Multiple Data String

Operasi untuk bekerja dengan multiple key-value pairs sekaligus:

### MSET

Menyimpan multiple key-value pairs:

```bash
mset joko 300 budi 400 rully 500   # Menyimpan 3 key-value pairs
```

### MGET

Mengambil values dari multiple keys:

```bash
mget joko budi rully               # Mengambil values dari 3 keys
```

---

## ⏳ Operasi Expiration (TTL)

TTL (Time To Live) memungkinkan key otomatis dihapus setelah waktu tertentu:

### EXPIRE

Menset masa berlaku untuk key yang sudah ada:

```bash
set joko 300
expire joko 5           # Key 'joko' akan dihapus setelah 5 detik
```

### SET dengan EX

Menyimpan value dengan TTL dalam satu command:

```bash
set ahmad "Ahmad Sairony" ex 10    # String dengan TTL 10 detik
```

### TTL

Melihat sisa waktu hidup key (dalam detik):

```bash
ttl joko                # Menampilkan waktu tersisa
# Output: 5 (5 detik) atau -2 (key sudah expired) atau -1 (no expiration)
```

---

## 📊 Operasi Increment & Decrement

Operasi aritmatika untuk nilai numerik:

### INCR

Menambah value sebesar 1:

```bash
incr counter            # Otomatis membuat key jika belum ada, value = 1
incr counter            # Value sekarang = 2
```

### DECR

Mengurangi value sebesar 1:

```bash
decr counter            # Value berkurang 1
```

### INCRBY

Menambah value dengan jumlah spesifik:

```bash
incrby counter 10       # Menambah counter sebesar 10
```

### DECRBY

Mengurangi value dengan jumlah spesifik:

```bash
decrby counter 5        # Mengurangi counter sebesar 5
```

---

## 🗑️ Operasi Flush Database

Operasi untuk menghapus data secara massal:

### FLUSHDB

Menghapus semua data dalam database yang sedang aktif:

```bash
flushdb                 # Hapus semua key di database sekarang
```

### FLUSHALL

Menghapus semua data di semua database:

```bash
flushall                # Hapus semua key di semua database (HATI-HATI!)
```

**⚠️ Peringatan:** Kedua command ini bersifat destructive dan tidak dapat di-undo

---

## 🚀 Pipeline

Pipeline memungkinkan mengirim multiple commands sekaligus tanpa menunggu response setiap command. Ini meningkatkan performa secara signifikan.

### Format Pipeline File

File input untuk pipeline harus mengikuti Redis Protocol. Untuk mengirim data dari file ke Redis:

```bash
# Unix/Linux/Mac
redis-cli -n 0 --pipe < input_file.txt

# Windows dengan Docker
Get-Content input_file.txt | docker exec -i belajarredis redis-cli -n 1 --pipe
```

**Catatan:**

- `-n 0` : Menentukan database (0 dalam contoh ini)
- `--pipe` : Mode pipeline
- `input_file.txt` : File berisi commands dalam Redis Protocol format

### Format Input File

```
set budi Budi
set ibrohim "Ibrohim Sairony"
set eko Eko
set abdul "Abdul Dudu"
```

---

## 📌 Transaksi (Transaction)

Transaksi di Redis memastikan sekumpulan commands dieksekusi secara atomic (semua atau tidak sama sekali). Konsepnya mirip dengan bulk operations, bukan SQL transaction.

### MULTI

Memulai transaksi:

```bash
multi                   # Mulai mode transaksi
```

### EXEC

Mengeksekusi semua commands yang telah di-queue:

```bash
exec                    # Eksekusi semua commands dalam transaksi
```

### DISCARD

Membatalkan transaksi:

```bash
discard                 # Batalkan transaksi tanpa mengeksekusi
```

### Contoh Transaksi Lengkap

```bash
multi
set key1 value1
set key2 value2
incr counter
exec                    # Semua 3 command dijalankan sekaligus
```

---

## 📡 Monitoring

Command untuk memonitor aktivitas Real-time di Redis server:

### MONITOR

Menampilkan semua commands yang dijalankan pada server:

```bash
monitor                 # Lihat semua command yang masuk
```

**Kegunaan:**

- Debug aplikasi
- Melihat traffic secara real-time
- Identifikasi commands yang tidak efisien

**Catatan:** MONITOR dapat menggunakan resource yang besar pada server dengan traffic tinggi

---

## 🖥️ Informasi Server

Command untuk mendapatkan informasi tentang Redis server:

### INFO

Menampilkan informasi lengkap tentang sistem server Redis:

```bash
info                    # Menampilkan SEMUA info server
```

### CONFIG GET

Menampilkan konfigurasi spesifik:

```bash
config get database     # Jumlah database
config get bind         # Bind address
config get save         # Konfigurasi save/persistence
config get *            # Menampilkan semua konfigurasi
```

**Informasi yang Tersedia:**

- Server info: Redis version, OS, uptime, dll
- Clients: Jumlah client, blocked clients, dll
- Memory: Used memory, mem fragmentation, dll
- Persistence: RDB, AOF status
- Stats: Total connections, commands processed, dll
- Replication: Master/slave info
- CPU: CPU time used
- Keyspace: Database info dan key count

---

## 👥 Koneksi Client

Command untuk mengelola koneksi client:

### CLIENT LIST

Menampilkan daftar semua client yang terhubung:

```bash
client list             # Lihat semua client yang connected
```

Informasi yang ditampilkan:

- `addr` : IP address dan port client
- `fd` : File descriptor
- `name` : Nama client
- `age` : Durasi koneksi (detik)
- `idle` : Idle time (detik)
- `flags` : Flag client (master, replica, dll)

### CLIENT ID

Melihat ID dari client yang sedang terhubung:

```bash
client id               # Tampilkan ID klien sekarang
```

### CLIENT KILL

Memutus koneksi client tertentu:

```bash
client kill ip:port     # Putuskan koneksi dari IP:PORT tertentu
```

---

## 🔐 Protected Mode

Protected Mode adalah fitur keamanan untuk melindungi Redis instance dari akses tidak sah.

### Pengaturan Protected Mode

Di dalam `redis.conf`:

```
protected-mode yes
```

**Perilaku Protected Mode:**

- Ketika enabled dan password tidak diatur untuk user default
- Redis hanya menerima koneksi dari lokal (IPv4: 127.0.0.1, IPv6: ::1)
- Koneksi dari host lain akan ditolak

**Kapan Disable (tidak disarankan):**

- Jika sudah memiliki authentication yang kuat
- Jika Redis dilindungi oleh firewall
- Hanya untuk development environment

---

## 🔒 Security & Authentication

Fitur security Redis untuk membatasi akses dan operasi:

### User Configuration

Di dalam `redis.conf`, buat user dengan permission tertentu:

```
user default on +@connection
```

**User Default (Administrator):**

- Memiliki akses penuh ke semua commands
- Diperlukan saat pertama kali setup

### User dengan Limited Permission

```
user ibrohim on +@all ~* >rahasia
```

**Penjelasan:**

- `user ibrohim` : Nama user
- `on` : User enabled (dapat juga `off` untuk disable)
- `+@all` : Permission untuk semua commands
  - `+@connection` : Hanya connection commands
  - `+@read` : Hanya read commands
  - `+@write` : Hanya write commands
  - `+@admin` : Hanya admin commands
  - `+command` : Command spesifik
- `~*` : Pattern key yang dapat diakses (\* = semua key)
- `>rahasia` : Password (harus minimal 8 karakter)

### Best Practices Security:

1. Selalu gunakan password yang kuat
2. Batasi permission user sesuai kebutuhan
3. Gunakan protected-mode untuk development
4. Gunakan firewall atau VPN untuk production
5. Update Redis version secara regular

---

## 💾 Persistence (Penyimpanan Data)

Persistence adalah fitur untuk menyimpan data Redis ke disk sehingga data tetap ada jika server restart.

### RDB (Redis Database)

RDB adalah snapshot dari seluruh dataset pada waktu tertentu.

**Konfigurasi Default di redis.conf:**

```
save 3600 1 300 100 60 10000
```

**Artinya:**

- Setiap 3600 detik (1 jam) jika minimal 1 key berubah → save
- Setiap 300 detik (5 menit) jika minimal 100 key berubah → save
- Setiap 60 detik jika minimal 10000 key berubah → save

**Konfigurasi Lain:**

```
rdbcompression yes      # Kompresi RDB file dengan LZF
rdbchecksum yes         # Tambahkan CRC64 checksum
dbfilename dump.rdb     # Nama file RDB
dir ./                  # Direktori penyimpanan
```

### Commands Persistence Manual

#### SAVE

Menyimpan data secara synchronous (blocking):

```bash
save                    # Save secara blocking
```

**Catatan:** Server akan freeze saat save, tidak ideal untuk production

#### BGSAVE

Menyimpan data secara asynchronous (background):

```bash
bgsave                  # Save di background, server tetap responsive
```

**Direkomendasikan:** Gunakan BGSAVE untuk production environment

### AOF (Append Only File)

AOF mencatat setiap write command yang dijalankan.

**Keuntungan:**

- Lebih durabel (dapat menyimpan setiap change)
- Lebih fleksibel (rewrite policy dapat dikustomisasi)

**Kerugian:**

- File bisa lebih besar dibanding RDB
- Sedikit lebih lambat dibanding RDB

### Configuration di redis.conf:

```
# RDB Settings
save 3600 1 300 100 60 10000
stop-writes-on-bgsave-error yes

# AOF Settings (jika digunakan)
appendonly no           # Disable by default
appendfilename "appendonly.aof"
appendfsync everysec    # Sync every second
```

---

## 🎯 Eviction Policy

Eviction adalah policy yang dijalankan ketika Redis memory sudah penuh. Policy menentukan key mana yang harus dihapus untuk membuat ruang untuk data baru.

### Kondisi Eviction:

Ketika memory Redis mencapai limit yang ditentukan (`maxmemory`), eviction policy akan menentukan tindakan yang diambil.

### Tipe-Tipe Eviction Policy:

1. **No Eviction (default)**

   ```
   maxmemory-policy noeviction
   ```

   - Menolak semua write commands kalau memory penuh
   - Berbahaya untuk production (aplikasi akan error)

2. **LRU (Least Recently Used)**

   ```
   maxmemory-policy allkeys-lru
   ```

   - Hapus key yang jarang diakses
   - `allkeys-lru` : Hapus dari semua key
   - `volatile-lru` : Hanya hapus key dengan TTL

3. **LFU (Least Frequently Used)**

   ```
   maxmemory-policy allkeys-lfu
   ```

   - Hapus key yang paling jarang digunakan
   - `allkeys-lfu` : Hapus dari semua key
   - `volatile-lfu` : Hanya hapus key dengan TTL

4. **Random**

   ```
   maxmemory-policy allkeys-random
   ```

   - Hapus key secara random
   - `allkeys-random` : Dari semua key
   - `volatile-random` : Hanya dari key dengan TTL

5. **TTL Based**

   ```
   maxmemory-policy volatile-ttl
   ```

   - Hapus key dengan TTL paling dekat expiration

### Konfigurasi Memory Limit:

```
maxmemory 256mb         # Limit memory ke 256 MB
maxmemory-policy allkeys-lru
```

### Best Practices:

1. Selalu set `maxmemory` untuk mencegah memory overflow
2. Pilih policy sesuai use case aplikasi
3. Monitor memory usage menggunakan `INFO memory`
4. Untuk cache: gunakan `allkeys-lru`
5. Untuk session store: gunakan `volatile-lru` (dengan TTL)

---

## 💾 Struktur Data di Redis

Redis mendukung berbagai macam struktur data kompleks selain String.

### List

Struktur data _Linked List_ yang berisi koleksi string. Data disimpan berurutan dan bisa duplikat. Berguna untuk implementasi _stack_ (dengan `LPUSH`/`LPOP`) atau _queue_ (dengan `LPUSH`/`RPOP`).

**Contoh Perintah:**

- `LPUSH mylist "A"`: Menambah "A" ke kiri (awal) list.
- `RPUSH mylist "B"`: Menambah "B" ke kanan (akhir) list.
- `LPOP mylist`: Mengambil dan menghapus elemen dari kiri.
- `RPOP mylist`: Mengambil dan menghapus elemen dari kanan.
- `LRANGE mylist 0 -1`: Melihat semua elemen dalam list.

### Sets

Koleksi data string yang tidak berurut dan dijamin unik. Berguna jika Anda hanya perlu menyimpan data unik tanpa mempedulikan urutan.

**Contoh Perintah:**

- `SADD myset "A" "B" "C"`: Menambah anggota ke set.
- `SMEMBERS myset`: Melihat semua anggota set.
- `SISMEMBER myset "A"`: Cek apakah "A" adalah anggota set.
- `SREM myset "C"`: Menghapus anggota dari set.
- `SUNION set1 set2`: Menggabungkan dua set.
- `SINTER set1 set2`: Mencari irisan (anggota yang sama) dari dua set.
- `SDIFF set1 set2`: Mencari perbedaan antara dua set.

### Hashes

Struktur data _key-value pair_, mirip seperti objek atau dictionary. Setiap hash bisa memiliki banyak field dan value.

**Contoh Perintah:**

- `HSET user:1 name "Ibrohim" age 25`: Menyimpan data user.
- `HGET user:1 name`: Mengambil value dari field 'name'.
- `HGETALL user:1`: Mengambil semua field dan value dari hash.
- `HINCRBY user:1 age 1`: Menambah nilai field numerik.

### Sorted Sets

Struktur data seperti Sets (data unik), namun setiap anggota memiliki _score_ (nilai numerik) yang digunakan untuk mengurutkan data. Sangat berguna untuk leaderboard atau ranking.

**Contoh Perintah:**

- `ZADD ranking 100 "eko" 90 "budi"`: Menambah anggota dengan score.
- `ZRANGE ranking 0 -1`: Melihat anggota berdasarkan urutan score (terkecil ke terbesar).
- `ZREVRANGE ranking 0 -1`: Melihat anggota berdasarkan urutan score terbalik.
- `ZRANGE ranking 0 -1 WITHSCORES`: Melihat anggota beserta score-nya.

### Stream

Struktur data _append-only_ seperti log. Data ditambahkan di akhir dan setiap entri memiliki ID unik (biasanya timestamp). Cocok untuk mencatat event, sensor data, atau sebagai message broker dengan _consumer groups_.

**Contoh Perintah:**

- `XADD mystream * level "info" msg "hello"`: Menambah entri baru.
- `XREAD COUNT 10 STREAMS mystream 0`: Membaca data dari stream.
- `XGROUP CREATE mystream mygroup $ MKSTREAM`: Membuat consumer group.
- `XREADGROUP GROUP mygroup consumer-1 COUNT 1 STREAMS mystream >`: Membaca data sebagai bagian dari group.

### Geospatial

Struktur data khusus untuk menyimpan koordinat geografis (longitude, latitude) dan melakukan query berbasis lokasi.

**Contoh Perintah:**

- `GEOADD seller:location 107.123 -6.234 "seller1"`: Menambah lokasi.
- `GEODIST seller:location "seller1" "seller2" km`: Menghitung jarak antara dua titik.
- `GEOSEARCH seller:location FROMLONLAT 107.12 -6.23 BYRADIUS 5 km`: Mencari titik dalam radius tertentu.

### HyperLogLog

Struktur data probabilistik untuk melakukan estimasi kardinalitas (jumlah data unik) dari sebuah set dengan penggunaan memori yang sangat efisien. Anda tidak bisa mengambil datanya kembali, hanya bisa menghitung estimasi jumlahnya.

**Contoh Perintah:**

- `PFADD unique:visitors "user1" "user2"`: Menambahkan data.
- `PFCOUNT unique:visitors`: Menghitung estimasi jumlah data unik.

### Pub/Sub

Redis Pub/Sub (Publish/Subscribe) adalah sistem pengiriman pesan di mana _publisher_ mengirim pesan ke sebuah _channel_, tanpa mengetahui siapa _subscriber_ (penerima) pesannya. Sebaliknya, _subscriber_ menerima pesan dari channel yang mereka minati tanpa mengetahui siapa _publisher_-nya.

- **Model**: Menggunakan model _broadcast_, di mana satu pesan dari publisher akan dikirim ke semua subscriber di channel yang sama.
- **Pengiriman**: Sifatnya _fire and forget_ (_at-most-once delivery_). Jika tidak ada subscriber yang sedang mendengarkan di sebuah channel, pesan yang dikirim ke channel tersebut akan hilang dan tidak akan pernah diterima.

**Contoh Perintah:**

- `SUBSCRIBE channel1 channel2`: Klien mulai mendengarkan pesan dari `channel1` dan `channel2`.
- `PUBLISH channel1 "Hello"`: Mengirim pesan "Hello" ke semua subscriber di `channel1`.
- `PUBSUB CHANNELS`: Melihat daftar channel yang aktif (memiliki setidaknya satu subscriber).

## 📋 Kesimpulan

Redis adalah in-memory data store yang powerful dengan fitur-fitur lengkap untuk:

- **Caching** : Penyimpanan cache yang cepat
- **Session Store** : Penyimpanan session aplikasi
- **Real-time Analytics** : Analisis data real-time
- **Message Queue** : Antrian pesan
- **Leaderboard** : Ranking dan scoring

Dengan memahami semua konsep di atas, Anda sudah memiliki fondasi yang kuat untuk menggunakan Redis dalam aplikasi production.

**Tips Selanjutnya:**

- Pelajari Redis Cluster untuk scalability
- Pelajari Redis Streams untuk messaging
- Praktik dengan use case nyata di aplikasi Anda

---

_Dokumentasi dibuat berdasarkan pembelajaran Redis dasar. Untuk informasi lebih lengkap, kunjungi [redis.io](https://redis.io)_
