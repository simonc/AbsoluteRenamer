# Extension of existing String class
class String
    # Returns a camelized version of a string
    # word_separator: a regular expression used to separate words.
    #    str = "hello.THE world"
    #    str.camelize           # => "Hello.The World"
    #    str.camelize(/[\.]/)   # => "Hello.The world"
    #    str                    # => "hello.THE world"
    def camelize(word_separators = /[\W_]/)
        self.clone.camelize!(word_separators)
    end

    # Camelizes a string and returns it.
    #    str = "Hello.THE World"
    #    str.camelize!                  # => "Hello.The World"
    #    str.camelize!(/[\.]/)          # => "Hello.The World"
    #    str                            # => "Hello.The World"
    def camelize!(word_separators = /[\W_]/)
        self.downcase!
        self.each_char.each_with_index do |c,i|
            if self[i-1].chr =~ word_separators or i.zero?
                self[i] = c.upcase if c =~ /[a-z]/
            end
        end
        self
    end
end
