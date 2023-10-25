# Rounds:
# se for impar -> vez do bot
# se par -> vez do player

class Start < GameIntro
  def initialize
    @y_positions = [0, 1, 2]
    @x_positions = [0, 1, 2]
    @boxes = []
    @valid_step = false
    @end_game = false
    @rounds = 0

    call
  end

  def call
    define_initial_empty_boxes

    draw_figure([])

    first_player_step = gets.chomp
    valid_step = valid_step?(first_player_step)
    
    valid_step ? continue_game : request_step_until_valid
  end

  def continue_game
    @rounds += 1

    while !end_game 
      turn = check_turn
      empty_boxes = possibilities

      if turn == 1 
        # Vez do player
      else 
        # Vez do bot

        bot_turn
      end
    end
  end

  def check_turn
    return 1 if @rounds%2 == 0 # confere se é par
    # 1 => player (X)
    # 0 => bot (o)

    0
  end

  def possibilities
    possibilities = []

    @boxes.each_with_index do |row, index_row|
      row.each_with_index do |box, index_box|
        index = index_row + index_box

        if box < 0 
          possibilities << index
        end
      end
    end

    possibilities
  end

  def bot_turn
    puts 'fazendo'
  end

  def request_step_until_valid
    invalid_step_message
    valid_step = 0

    while !@valid_step
      puts 'Por Favor, digite um valor válido:'

      step = gets.chomp.to_i
      # Se o usuario digitar uma String, o to_i irá transformar em 0, e não passará na validação.
      
      if valid_step?(step)        
        @valid_step = true
        valid_step = step        
      end
    end
    
    valid_step - 1 # -1 pois os cálculos se baseiam nas caixas de 0 a 8, e não 1 a 9.
  end

  def valid_step?(step)
    return true if (step.class == Integer) && (step >= 1) && (step <= 9)
    
    false
  end

  def invalid_step_message 
    puts 'Você não digitou uma jogada válida!'
  end

  def define_initial_empty_boxes
    @y_positions.each do |position_y| 
      @boxes << [-1,-1,-1]
    end

    # Resultado:
    # [ [-1, -1, -1], [-1, -1, -1], [-1, -1, -1] ]
    # -1 => vazio, não foi preenchido ainda.
  end
end