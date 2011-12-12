# Conway's Game of Life. Default map size is 80 x 40, 80 cycles

columns = ARGV[0] ? ARGV[0].to_i : 80
rows = ARGV[1] ? ARGV[1].to_i : 40
cycles = ARGV[2] ? ARGV[2].to_i : 200

class Habitat
  attr_reader :columns, :rows
  def initialize(columns, rows)
    @columns = columns
    @rows = rows
    @total_spots = rows * columns
    @quarter_count = @total_spots/4
    @initial_creatures = []
    @first_map = []
    (@total_spots/100).times do
      @initial_creatures << rand(@quarter_count) + @quarter_count
    end
    
    1.upto(@total_spots) do 
      @first_map << "."
    end
    
    @initial_creatures.each do |ic|
      @first_map[ic] = "O"
      @first_map[ic+1] = "O"
      @first_map[ic+40] = "O"
      @first_map[ic+2] = "O"
    end
  end
  
  def evolve_once(arr)
    new_arr = []
    
    1.upto(arr.size) do
      new_arr << "."
    end
    
    arr.each_with_index do |ea, num|
      left_edge = true if num % @columns == 0
      right_edge = true if (num+1) % @columns == 0
      top_row = true if num < @columns
      bottom_row = true if num > arr.size-(@columns+1)
      n_total = 0
      neighbors = []
      neighbors << num - (@columns+1) unless top_row || left_edge
      neighbors << num - @columns unless top_row
      neighbors << num - (@columns-1) unless top_row || right_edge
      neighbors << num - 1 unless left_edge
      neighbors << num + 1 unless right_edge
      neighbors << num + (@columns-1) unless bottom_row || left_edge
      neighbors << num + @columns unless bottom_row
      neighbors << num + (@columns+1) unless bottom_row || right_edge
      
      neighbors.each do |nn|
        n_total += 1 if arr[nn] == "O"
      end
      
      new_arr[num] = "O" if n_total == 3      
      new_arr[num] = "O" if (n_total == 2 && ea == "O")
    end
    
    return new_arr
  end
  
  def print_map(map_array)
    num = 0
    while num < map_array.size
      if (num + 1) % @columns == 0 && num != 0
        puts map_array[num]
      else
        print map_array[num]
      end
      num += 1
    end
    puts "~~~~~~~~~~~ Map Boundary ~~~~~~~~~~~"
  end
  
  def show_first_map
    puts "Showing first map"
    print_map(@first_map)
  end
  
  def run_simulation(cycles, f_map = @first_map)
    @next_map = []
    print_map(f_map)
    if cycles > 0
      @next_map = evolve_once(f_map)
      sleep 0.1
      run_simulation(cycles-1, @next_map)
    else
      puts "~~~~~~~~~~~ The End ~~~~~~~~~~~"
    end
  end
  
end

my_world = Habitat.new(columns, rows)
my_world.show_first_map
my_world.run_simulation(cycles)

