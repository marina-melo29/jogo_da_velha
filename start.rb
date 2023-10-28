# Rounds:
# se for impar -> vez do bot
# se par -> vez do player

class Start < GameIntro
  WINNING_COMBINATIONS = [
    [0, 1, 2], [3, 4, 5], [6, 7, 8], # Linhas horizontais
    [0, 3, 6], [1, 4, 7], [2, 5, 8], # Colunas verticais
    [0, 4, 8], [2, 4, 6] # Diagonais
  ]

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

        player_step = player_turn
        win = will_step_get_a_win?(1, player_step)

        @boxes[player_step] = 1

        draw_figure(@boxes)
        end_game_check(win)
      else
        # Vez do bot
        puts 'vez do oponente . . .'
        sleep(2) # esperar 2 segundos antes de continuar (pra não printar tão rápido, e ficar mais natural)

        bot_turn = bot_turn(empty_boxes, bot_steps)
        win = will_step_get_a_win?(0, bot_turn)

        @boxes[bot_turn] = 0

        draw_figure(@boxes)
        end_game_check(win)

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
      next if box >= 0

      possibilities << index
    end

    possibilities
  end

  def player_turn
    player_step = get_step
    valid_step = valid_step?(player_step)

    if valid_step == false
      player_step = request_step_until_valid
    else
      player_step -= 1
    end

    player_step
  end

  def bot_turn(empty_boxes, bot_steps)
    return empty_boxes.sample if bot_steps.zero? # Se for a primeira jogada do robô, então escolher aleatório.

    win_possibilities = win_possibilities(empty_boxes, 0)
    opponent_win_possibilities = win_possibilities(empty_boxes, 1)

    return win_possibilities.first if win_possibilities.count > 0

    return opponent_win_possibilities.first if opponent_win_possibilities.count > 0

    empty_boxes.sample
  end

  def end_game_check(win)
    if win
      @end_game = true
      final_win_message(check_turn)
    elsif game_ended_in_draw?
      @end_game = true
      draw_message
    end
  end

  def game_ended_in_draw?
    return true if @boxes.all? { |box| box != -1 }

    false
  end

  def win_possibilities(empty_boxes, turn)
    response = []

    # empty_boxes serão as posições vazias (de 0 a 8)

    empty_boxes.each do |empty_box|
      result = will_step_get_a_win?(turn, empty_box)

      next if result == false

      response << empty_box
    end

    response
  end

  def will_step_get_a_win?(turn, chosen_step)
    simulated_boxes = @boxes.deep_dup

    simulated_boxes.each_with_index do |_box, index|
      next unless index == chosen_step

      simulated_boxes[index] = turn
    end

    check_game_win(turn, simulated_boxes)
  end

  def check_game_win(turn, boxes = @boxes)
    win = false

    WINNING_COMBINATIONS.each do |combo|
      win = true if combo.all? { |position| boxes[position] == turn }
    end

    win
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

      chosen_step = get_step
      # Se o usuario digitar uma String, o to_i irá transformar em 0, e não passará na validação.

      if valid_step?(chosen_step)
        @valid_step = true
        valid_step = chosen_step
      end
    end

    valid_step - 1 # -1 pois os cálculos se baseiam nas caixas de 0 a 8, e não 1 a 9.
  end

  def valid_step?(chosen_step)
    return false if possibilities.exclude?(chosen_step - 1)

    return true if chosen_step.instance_of?(Integer) && (chosen_step >= 1) && (chosen_step <= 9)

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

  def final_win_message(turn)
    if turn.positive?
      congratulation_message
    else
      lost_message
    end
  end

  def congratulation_message
    puts '=============================='
    puts '   PARABÉENS!! VOCÊ GANHOU!'
    puts '=============================='
  end

  def lost_message
    puts '=============================='
    puts '         VOCÊ PERDEU!         '
    puts '=============================='
  end

  def draw_message
    puts '=============================='
    puts '            EMPATE            '
    puts '=============================='
  end
end
