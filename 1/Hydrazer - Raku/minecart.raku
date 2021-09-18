my List \TrackArr = "bruh.txt".IO.lines>>.comb;

my Array enum Dir (
  up => [-1, 0],
  down => [1, 0],
  left => [0, -1],
  right => [0, 1]
);

my Array @pos-arr;
my Int ($ind, $jnd) = 0, 0;
my Dir $curr-dir = Dir::right;


loop {
  say TrackArr.&animation($ind, $jnd);

  ($ind, $jnd, $curr-dir) = TrackArr.&get-next-step($ind, $jnd, $curr-dir);

  @pos-arr.push(["[$jnd, $ind]"]);

  say @pos-arr.&time-stamps([10, 15 ... 30]);

  sleep .25;
  print qx[clear];
}


sub animation(List \TrackArr, Int \ind, Int \jnd --> Str) {
  TrackArr.kv.map(-> \i, @line {
    @line.kv.map(-> \j, \item {
      [i, j] eqv [ind, jnd] ?? "C" !! item
    })
  })>>.join.join("\n");
}

sub time-stamps(Array @pos-arr, Array \time-arr --> Str) {
  time-arr.grep(* < @pos-arr).map(-> $time {"Time $time: @pos-arr[$time]"}).join("\n")
}

sub get-next-step(List \TrackArr, Int \ind, Int \jnd, Dir \curr-dir --> Array)  {
  my Str \curr-item = TrackArr[ind][jnd];
  my Dir \new-dir = get-next-direction(curr-dir, curr-item);
  my Int (\new-i, \new-j) = new-dir.Array Z+ ind, jnd;

  [new-i, new-j, new-dir]
}

sub get-next-direction(Dir \direction, Str \item --> Dir) {
  given direction, item {
    when (Dir::left, "╚") | (Dir::right, "╝") {
      Dir::up
    }

    when (Dir::left, "╔") | (Dir::right, "╗") {
      Dir::down
    }

    when (Dir::up, "╗") | (Dir::down, "╝") {
      Dir::left
    }

    when (Dir::up, "╔") | (Dir::down, "╚") {
      Dir::right
    }

    default {
      direction
    }
  }
}
