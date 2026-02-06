# Mengaktifkan pakai docker container
docker run -d --name belajarredis -p 7070:6379 -v "D:\belajar-redis-dasar\redis.conf:/custom/redis.conf" -v "D:\belajar-redis-dasar\data:/data" redis:latest redis-server /custom/redis.conf

# untuk pindah antar database
select 0
select 3
select 27

# ! Strings
set name "Ibrohim"
get name
exists name keylain
keys *
keys na*
append name " Sairony"
del name

# ! Operasi Range Data String
setrange name 7 " Hendra"
getrange name 7 13

# ! Operasi Multiple Data String
mset joko 300 budi 400 rully 500
mget joko budi rully

# ! Operasi Expiration Data String
expire joko 5  # Setelah 5 detik data hilang
set ahmad "Ahmad Sairony" ex 10
ttl joko  # time to live    

# ! Increment dan Decrement
incr counter # otomatis dibuatkan key jika data belum ada
decr counter
incrby counter 10 # value langsung dijumlah ke 10
decrby counter 5 # dikurangi 10

# ! Flush
flushdb # menghapus semua data di databse tertentu (database yang sedang diakses)
flushall # menghapus semua data di semua databse

#! Pipeline
# Operasi Pipeline Menggunkaan Redis Cli
# redis-cli -h host -p port -n database  --pipe < nama_file

redis-cli -n 0 --pipe < input_file.txt 

Get-Content input_file.txt | docker exec -i belajarredis redis-cli -n 1 --pipe # ! Kalau di windows dan menggunakan docker.


# ! Transaction
# konsepnya mirip bulk bukan mirip sql biasa
multi
exec
discard

# ! Monitor
monitor

# ! Server Information
info # melihat semua info tentang sistem server redis
config get <key> # melihat info tertentu saja seperti database
config get database
config get bind
config get save
config get ....

# ! Client Connection (Information)
client list
client id
client kill ip:port

# ! Protected Mode
# * Caranya tinggal mengaktifkan di config-nya

# ! Security
# * Tambahkan ke config-nya
user default on +@connection
user ibrohim on +@all ~* >rahasia  

# ! Persistence
#  defaultnya adalah save 3600 1 300 100 60 10000 # ! Setiap 1 jam kalau minimal ada 1 data berubah, atau dlaam 5 menit minimal ada 100 data berubah atau 1 menit minimal ada 10000 data yang berubah maka save
# * Bisa diganti di config-nya

# * Save Manual
save   # save secara syncronus.
bgsave # save secara asyncronus


# ! Eviction
# Pengaturan saat terjadi kondisi memori sudah penuh. # ? apakah semua perintah akan ditolak, (ini bahaya) atau data yang jarang terpakai dihaps
# * Pengaturannya di config
