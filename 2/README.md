The minecarts from last week are so very cool that we now want to generate new tracks for them. However, typing the weird characters by hand is a bit of a pain so your task is to draw the full track based on instructions given as input. The input consists of space separated instructions that tell the direction the track continues in and how many tracks should be laid in that direction, for example `E11` means you need to lay 11 tracks to the east. The track starts from the top left corner which is always '╔'. Like last week, the track may also cross itself.

Example input: 
```E5 S6 E5 N4 W3 N2 E7 S2 W2 S4 E12 N4 W4 S9 W3 N2 E11 N9 E7 S4 W4 S3 E4 S4 W13 S2 W9 N5 W8 S2 E4 S3 W3 N1 W4 S1 W2 N4 E3 N4 W3 N4```
This should generate a track like this:
```
╔════╗ ╔══════╗             ╔══════╗
║    ║ ║      ║             ║      ║
║    ║ ╚══╗ ╔═╝     ╔═══╗   ║      ║
║    ║    ║ ║       ║   ║   ║      ║
║    ║    ║ ║       ║   ║   ║  ╔═══╝
╚══╗ ║    ║ ║       ║   ║   ║  ║    
   ║ ╚════╝ ╚═══════╬═══╝   ║  ║    
   ║                ║       ║  ╚═══╗
   ║ ╔═══════╗      ║       ║      ║
╔══╝ ║       ║   ╔══╬═══════╝      ║
║    ╚═══╗   ║   ║  ║              ║
║        ║   ║   ╚══╝ ╔════════════╝
║ ╔═══╗  ║   ║        ║             
╚═╝   ╚══╝   ╚════════╝             
```
Bonus task for extra credit: make a tool that allows you to draw tracks like this by moving around with arrow keys.
