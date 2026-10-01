# Week04 – SongPlayer

little music app, 2 pages, plays songs + shows time

- **page 1:** playlist with 3 songs, how long each one is + the total. there's a mini player at the bottom so you can pause without opening anything
- **page 2:** now playing. cover, a slider with time played / time left (drag it to skip around), play/pause, back/next. when a song ends the next one just starts
- audio is `AVAudioPlayer`, the mp3s live in `SongPlayer/Audio`
- time is a `Timer` that ticks 4x a sec to move the slider

songs: One More Time (Daft Punk), Diamonds (Young Thug ft. Gunna), Fractal Chapel (musicovermind, free on Pixabay)
