# Extension of existing File class.
class << File
    # Returns the extension of a file.
    # path: the path of the file
    # dot: starting from the end, number of dots to count before cuting extension.
    def extname(path, dot = 1)
        pattern = (0...dot).inject('') { |pat,x| pat << '\.[^\.]+' } << '$'
        ext = File.basename(path).match(pattern).to_s
        ext.empty? ? "" : ext[1..ext.length]
    end
end
