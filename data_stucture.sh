# ini adalah pelajaran ke dua membahas data structure di redis

docker run -d --name belajarredis -p 7070:6379 -v "D:\belajar-redis-dasar\data:/data" redis:latest

# ! Strukter Data di redis
lists ->  Struktur data Linked List yang berisi data string
sets -> Koleksi data string yang tidak berurut
Hashes -> Struktur data key-value
sort sets -> Struktur data seperti Sets, namun berurut
stream -> Struktur dat Struktur data Linked List yang berisi data string
Koleksi data string yang tidak berurut
Struktur data key-value
Struktur data seperti Sets, namun berurut
Struktur data seperti log yang selalu bertambah dibelakang 
Struktur data koordinat
Struktur data untuk melakukan estimasi kardinalitas dari Set
a seperti log yang selalu bertambah dibelakang 
Geospatial -> Struktur data koordinat
hyperloglog -> Struktur data untuk melakukan estimasi kardinalitas dari Set

# ! Chapter pertama : list 
# kumpulan data string mirip array.
# bisa digunakan untuk stack atau queue
# datanya berurutan, dan tidak dijimamin unique

# syntak
lpush -> tambah ke kiri
rpush -> tambah ke kanan
lpop -> keluar dari kiri
rpop -> tambah dari kiri
lrange -> melihat
dan lain lain -> https://redis.io/commands/?group=list

# ?  contoh list stack fifo
lpush stack "ibrohim"
lpush stack "mush'ab"
lpush stack "ahmad"

lrange stack 0 40

lpop stack 1
lpop stack 1
lpop stack 1

lrange stack 0 40


# ! contoh list queue lifo
lpush contohqueue "ibrohim"
lpush contohqueue "mush'ab"
lpush contohqueue "ahmad"

lrange contohqueue 0 40

rpop contohqueue 1
rpop contohqueue 1
rpop contohqueue 1

lrange stack 0 40

# ! Chater 2 : Sets
# tidak berurutan, namun dijamin unique
# digunakan jika buduh data unique

# syntak
sadd -> menambahkan sets
scard -> menghitung total data
smembers -> melihat semua data
srem -> mengambil data
dan lain lain -> https://redis.io/commands/?group=set

# ! Contoh sets
sadd race "eko" "budy" "joko"
sadd race "eko" "budy" "rully" "ibrohim"
scard race
smembers race
srem ibrohim sairony

# ! Capter 3 : Membandingkan sets

# syntak
sdiff -> melihat data yang berbeda dari sets pertama dengan sets lainnya
sinter -> melihat data yang sama dari beberapa sets
sunion -> melihat gabungan unik dari beberapa sets

# ! contoh
sadd race1 budi joko
sadd race2 budi nugroho joko morro
sadd race3 joko morro rully hidayat

sdiff race1 race3 # ? hasilnya budi karena -> budi gk ada di race2
sdiff race1 race2 # ? hasilnya empty array karena -> joko dan budi ada juga di race2
sinter race1 race2 # ? hasilnya budi joko karena -> datanya ada juga di race2
sinter race1 race2 race3 # ? hasilnya joko karena -> joko ada di race1 race2 race3
sunion race1 race2 race3 # ? hasilnya budi joko nugraha morro rully hidayat -> menggabungkan semua lalu menampilkan data yang unique

# ! Chapter 3 : Hashes
# struktur data berbentuk pair (key value)


# sintak 
hset 
hget -> menampikan value tertentu 
hgetall -> menampilkan semua key dan valuenya 

# ! Contoh hashes
hset student:1 name "Ibrohim Sairony" value 100 address Madiun
hset student:2 name "Budy Nugraha" value 90 address Bandung
hset student:3 name "Joko Morro" value 84 address Cirebon

hget student:3
hget student:2 name

hset student:2 value 99  # mengedit value student:2  | yang tidak ada dibuatkan - yang sudah ada diubah |

# ! Chapter 4 : Hashes increment decrement

# sintak
hincrby

# ! Contoh 
hincrby student:1 value -10  # Menguarangi 10
hincrby student:1 value 5   # Menambah 5



# ! Chapter 5 : Sorted Sets

# syntax
zadd key score value
zcard key
zrange key start end
zrange key start end byscore
zrange key start end withscore
zrem key value
zremrangebyscore key min max
dan lain lain -> https://redis.io/commands/?group=sorted-set

# ! Contoh
zadd rangking 100 eko
zadd rangking 90 budi
zadd rangking 95 joko

zrange rangking 0 5 # hasilnya : budi joko eko, berurut dari paling kecil scorenya ke paling besar
zrange rangking 95 100 byscore # Defaulnya byindex
zrange rangking 0 -1 withscore # dari index pertama - terakir lalu tampilkan juga scorenya

# ! Chapter 5 : Stream
# mirip log, data akan bertambah terus di belakang (append-only)
# bentuknya key value mirip hash tapi ada id nya


# Syntax
xadd key id field value field value ... -> menambah data ke dalam stream nya
XADD key [NOMKSTREAM] [KEEPREF | DELREF | ACKED]
  [IDMPAUTO producer-id | IDMP producer-id idempotent-id]
  [<MAXLEN | MINID> [= | ~] threshold [LIMIT count]] <* | id>
  field value [field value ...]

xread count streams key id -> membaca data
XREAD [COUNT count] [BLOCK milliseconds] STREAMS key [key ...] id
  [id ...]

# ! Contoh

xadd application.log * level "info" message "Contoh info message"
xadd application.log * level error message "Contoh error message"
xadd application.log * level warning message "Contoh warning message"

xread count 10 streams application.log 0
xread count 2 streams application.log 0

xread count 10 block 0 streams application.log 1771483618955-0

# ! Chapter 5 : masalah di streams, solusi pakai -> Consumer Group
# untuk mencegah race condition

# sytax
xgroup create -> buat group cousumer
xgroup createconsumer -> buat cousumer
x

# ! Contoh

xgroup create registration member $ mkstream # $ untuk alias id terakhir, mkstream untuk membuat stream baru, kalau stream belum ada akan error
xgroup createconsumer registration member member-consumer-1
xgroup createconsumer registration member member-consumer-2
xadd registration * userId 1
xadd registration * userId 2
xadd registration * userId 3
xadd registration * userId 4

xreadgroup group member member-consumer-1  count 1 block 0 streams registration > # > penanda id apapun yang belum di read
xreadgroup group member member-consumer-2  count 1 block 0 streams registration > 

# ! Chapter ? : Geospatial / koordinat

# syntax
geoadd
geopos
geodis -> melihat Jarak, diukur kilometer / meter
georadius
geosearch 

# ! Contoh
geoadd seller.location 107.123423 -6.234345 seller1
geoadd seller.location 107.123483 -6.234545 seller2

geopos seller.location seller1
geopos seller.location seller2

geodist seller.location seller1 seller2 km
geodist seller.location seller1 seller2 m

geosearch seller.location fromlonlat 107.123463 -6.234545 byradius 1 km  -> mencari seller-seller yang ada dalam radius 1 km


# ! Chapter ? : hyperloglog
# Struktur data probabilistik untuk melakukan estimasi kardinalitas (jumlah data unik) dari set
# mirip sets untuk menyimpan data unik, tapi hyperloglog datanya tidak bisa digunakan lagi. namun hanya bisa menghitung jumlahnya saja.
# contoh kasus, menghitung data pengunjung... kita tidak butuh menyimpan nama pengunjungnya, tapi untuk menghitung jumlah pengunjungnya saja, (dan pengunjung yang sama gk akan dianggap)

# syntax
pfadd
pfcount -> melihat jumlah data

# ! Contoh 
pfadd visitor eko budi joko rully
pfadd visitor eko santi sinta joko 

pfcount visitor
del visitor

# ! Struktur data lainnya
bitmaps -> jarang digunakan
bitfields -> jarang digunakan
json -> untuk redis yang berbayar
timeseries -> untuk redis yang berbayar
probabilitas -> untuk redis yang berbayar