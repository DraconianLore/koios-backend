# frozen_string_literal: true

module CyphersHelper
  def letter?(letter)
    letter =~ /[[:punct:][:digit:]]/
  end

  def cypher(type, message)
    puts message
    case type
    when 'reverse'
      return c_reverse(message)
    when 'number'
      return c_number(message)
    when /^letterShift/
      return c_letterShift(type[-1].to_i, message)
    when /^letterSlip/
      return c_letterSlip(type[-1].to_i, message)
    end
  end

  def instructions(type)
    case type
    when 'reverse'
      'Write the message in reverse'
    when 'number'
      example = "a becomes #{cypher(type, 'a')}, c becomes #{cypher(type, 'c')}, z becomes #{cypher(type, 'z')}"
      "Replace each letter by its position in the alphabet \nFor example: #{example}"
    when /^letterShift/
      example = "a becomes #{cypher(type, 'a')}, c becomes #{cypher(type, 'c')}, z becomes #{cypher(type, 'z')}"
      "Shift each letter to the right by #{type[-1]} characters \nFor example: #{example}"
    when /^letterSlip/
      example = "a becomes #{cypher(type, 'a')}, c becomes #{cypher(type, 'c')}, z becomes #{cypher(type, 'z')}"
      "Shift each letter to the left by #{type[-1]} characters \nFor example: #{example}"
    end
  end

  def c_reverse(msg)
    msg.reverse
  end

  def c_number(msg)
    result = []
    msg = msg.chars
    msg.each do |letter|
      if letter != ' ' && !letter?(letter)
        letter = letter[0].ord - 96
        letter = "0#{letter}" if letter < 10
        result.push(letter)
      else
        result.push(letter)
      end
    end
    result.join('')
  end

  def c_letterShift(num, message)
    result = []
    message = message.chars
    message.each do |letter|
      if letter != ' ' && !letter?(letter)
        letter = letter[0].ord
        letter += num
        if letter > 122
          letter -= 122
          letter = 96 + letter
        end
        letter = letter.chr
        result.push(letter)
      else
        result.push(letter)
      end
    end
    result.join('')
  end

  def c_letterSlip(num, message)
    result = []
    message = message.chars
    message.each do |letter|
      if letter != ' ' && !letter?(letter)
        letter = letter[0].ord
        letter -= num
        if letter < 97
          letter -= 97
          letter = 123 + letter
        end
        letter = letter.chr
        result.push(letter)
      else
        result.push(letter)
      end
    end
    result.join('')
  end
end
