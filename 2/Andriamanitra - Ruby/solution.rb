tracks = Hash.new(' ')

Position = Struct.new(:x, :y)
pos = Position.new(0, 0)

prevdir = 'N'
max_x = 0
max_y = 0

pieces = {
    'NE' => '╔', 'WS' => '╔',
    'NW' => '╗', 'ES' => '╗',
    'SE' => '╚', 'WN' => '╚',
    'SW' => '╝', 'EN' => '╝',
    'N' => '║', 'S' => '║',
    'W' => '═', 'E' => '═',
    '+' => '╬'
}

gets.split.each{|line|
    dir = line[0]
    turn = prevdir + dir
    steps = line[1..].to_i

    tracks[[*pos]] = pieces[turn]
    
    steps.times do
        case dir
        when 'N' then pos.y -= 1
        when 'S' then pos.y += 1
        when 'E' then pos.x += 1
        when 'W' then pos.x -= 1
        end
        
        if tracks[[*pos]] != ' '
            tracks[[*pos]] = pieces['+']
        else
            tracks[[*pos]] = pieces[dir]
        end
    end
    max_x = pos.x if pos.x > max_x
    max_y = pos.y if pos.y > max_y
    prevdir = dir
}

(0..max_y).each do |y|
    (0..max_x).each do |x|
        print tracks[[x,y]]
    end
    puts
end
