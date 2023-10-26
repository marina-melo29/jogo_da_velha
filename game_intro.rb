require 'byebug'
require 'active_support'
require 'active_support/core_ext/object/blank'

# load 'teste.rb'

class GameIntro
  def initialize
    call
  end

  def call
    call_tutorial = tutorial
    return if call_tutorial != 's'

    puts 'QUE OS JOGOS COMECEM!!!'

    start_game
  end

  def start_game
    load 'start.rb'

    Start.new
  end

  def tutorial
    puts '-----------------------------------------------------------------------------------'
    puts 'Você iniciará o jogo da velha, e será sempre o X.'
    puts 'Sempre que for sua vez, digite um número de 1 a 9 para escolher o quadrado quer preencher.'
    puts 'exemplo das posições abaixo:'
    draw_initial_figure([1, 2, 3, 4, 5, 6, 7, 8, 9])
    puts "Pronto?? Digite 's' para continuar"
    puts '-----------------------------------------------------------------------------------'

    input = gets.chomp
  end

  def draw_initial_figure(item)
    puts ''
    puts "_#{validate_item(item[0])}_|_#{validate_item(item[1])}_|_#{validate_item(item[2])}_"
    puts "_#{validate_item(item[3])}_|_#{validate_item(item[4])}_|_#{validate_item(item[5])}_"
    puts " #{validate_item(item[6])} | #{validate_item(item[7])} | #{validate_item(item[8])} "
    puts ''
  end

  def validate_item(item)
    return item if item.present?

    '_'
  end
end
