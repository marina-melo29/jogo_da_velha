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

    continue_game
  end

  def continue_game
    bot_steps = 0

    until @end_game
      turn = check_turn
      empty_boxes = possibilities

      if turn == 1
        # Vez do player
        puts 'sua vez!'
        puts 'digite um número de 1 a 9'

        player_step = get_step
        valid_step = valid_step?(player_step, empty_boxes)

        if valid_step == false
          player_step = request_step_until_valid
        else
          player_step -= 1
        end

        win = will_step_get_a_win?(1, player_step)

        @boxes[player_step] = 1

        draw_figure(@boxes)

        @end_game = true if win
      else
        # Vez do bot
        puts 'vez do oponente . . .'

        sleep(2) # esperar 2 segundos antes de continuar (pra não printar tão rápido, e ficar mais natural)

        bot_step = bot_turn(empty_boxes, bot_steps)
        win = will_step_get_a_win?(0, bot_step)

        @boxes[bot_step] = 0

        draw_figure(@boxes)

        @end_game = true if win

        bot_steps += 1
      end

      @rounds += 1
    end
  end

  def check_turn
    return 1 if @rounds.even? # confere se é par

    # 1 => player (X)
    # 0 => bot (o)

    0
  end

  def possibilities
    possibilities = []

    @boxes.each_with_index do |box, index|
      next if box > 0

      possibilities << index
    end

    possibilities
  end

  def bot_turn(empty_boxes, bot_steps)
    return empty_boxes.sample if bot_steps.zero? # Se for a primeira jogada do robô, então escolher aleatório.

    win_possibilities = win_possibilities(empty_boxes, 0)
    opponent_win_possibilities = win_possibilities(empty_boxes, 1)

    return win_possibilities.first if win_possibilities.count > 0

    return opponent_win_possibilities.first if opponent_win_possibilities.count > 0

    empty_boxes.sample
  end

  def win_possibilities(empty_boxes, turn)
    response = []

    empty_boxes.each do |empty_box|
      result = will_step_get_a_win?(turn, empty_box)

      next if result == false

      response << empty_box
    end

    response
  end

  def will_step_get_a_win?(turn, step)
    # turn será sempre 0 ou 1
    simulated_boxes = @boxes.deep_dup

    simulated_boxes.each_with_index do |_box, index|
      next unless index == step - 1

      simulated_boxes[index] = turn
    end

    situation = check_game_situation(turn, simulated_boxes)

    situation[:game_win]
  end

  def check_game_situation(turn, boxes = @boxes)
    sum = 0
    filled = 0

    boxes.each_with_index do |box, index|
      next unless box == turn

      sum += index
      filled += 1
    end

    return build_hash(turn, true, false) if (sum % 3 == 0) && (filled >= 3)

    build_hash(turn, false, false)
  end

  def build_hash(turn, game_win, draw)
    {
      game_win: game_win,
      turn: turn,
      draw: draw
    }
  end

  def request_step_until_valid
    invalid_step_message
    valid_step = 0

    until @valid_step
      puts 'Por Favor, digite um valor válido:'

      step = get_step
      # Se o usuario digitar uma String, o to_i irá transformar em 0, e não passará na validação.

      if valid_step?(step)
        @valid_step = true
        valid_step = step
      end
    end

    valid_step - 1 # -1 pois os cálculos se baseiam nas caixas de 0 a 8, e não 1 a 9.
  end

  def valid_step?(step, empty_boxes)
    return true if step.instance_of?(Integer) && (step >= 1) && (step <= 9)

    empty_boxes.include?(step - 1)

    false
  end

  def get_step
    gets.chomp.to_i
  end

  def invalid_step_message
    puts 'Você não digitou uma jogada válida!'
  end

  def define_initial_empty_boxes
    for i in 0..8
      @boxes << -1
    end
  end

  def draw_figure(item)
    puts ''
    puts "_#{validate_item(item[0])}_|_#{validate_item(item[1])}_|_#{validate_item(item[2])}_"
    puts "_#{validate_item(item[3])}_|_#{validate_item(item[4])}_|_#{validate_item(item[5])}_"
    puts " #{validate_item(item[6])} | #{validate_item(item[7])} | #{validate_item(item[8])} "
    puts ''
  end

  def validate_item(turn)
    return '_' if turn.nil? || turn.negative?

    return 'x' if turn > 0

    'o'
  end
end
