module CyphersHelper
    def letter?(letter)
       letter =~ /[[:punct:]]/ 
    end

    def cypher(type, message)
        puts message
        case type
        when "reverse"
            return c_reverse(message)
        when /^letterShift/
            return c_letterShift(type[-1].to_i, message)
        when /^letterSlip/
            return c_letterSlip(type[-1].to_i, message)
        end
    end

    def instructions(type)
        case type
        when "reverse"
            return "Write the message in reverse"
        when /^letterShift/
            example = "a becomes #{cypher(type, "a")}, c becomes #{cypher(type, "c")}, z becomes #{cypher(type, "z")}"
            return "Shift each letter to the right by #{type[-1]} characters \nFor example: #{example}"
        when /^letterSlip/
            example = "a becomes #{cypher(type, "a")}, c becomes #{cypher(type, "c")}, z becomes #{cypher(type, "z")}"
            return "Shift each letter to the left by #{type[-1]} characters \nFor example: #{example}"
        end
    end

    def c_reverse(msg)
        msg.reverse
    end

    def c_letterShift(num, message)
        result = []
        message = message.chars
        message.each do |letter|
            if letter != " " && !letter?(letter)
                letter = letter[0].ord
                letter = letter + num
                if letter > 122
                    letter = letter - 122
                    letter = 96 + letter
                end
                letter = letter.chr
                result.push(letter)
            else
                result.push(letter)
            end
        end
        result.join("")
    end
    def c_letterSlip(num, message)
        result = []
        message = message.chars
        message.each do |letter|
            if letter != " " && !letter?(letter)
                letter = letter[0].ord
                letter = letter - num
                if letter < 97
                    letter = letter - 97
                    letter = 123 + letter
                end
                letter = letter.chr
                result.push(letter)
            else
                result.push(letter)
            end
        end
        result.join("")
    end
end
