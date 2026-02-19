# Pelajaran ke -3 : Redis PubSub

# modelnya broadcast dan menggunakan at-most-once-semantic

# ! JIka tidak ada Subscribe atau consumer maka data akan langsung hilang

# Syntax
subscribe -> untuk membuat subscribe / consumer
pubsub channels-> melihat channel yang ada subscribenya
publish -> mengirim pesan ke channel

# ! Contoh

subscribe chat notification
subscribe chat
pubsub channels
publish notification "welcome to my app" 
publish chat "welcome to my chat app" 