# Extension of existing Hash class
class Hash
  # Returns a new hash containing resulting of a recursive merge between two hashes
  # new_hash: the hash to merge
  #  h1 = { :key1 => :val1, :key2 => { :key21 => :val21 } }
  #  h2 = { :key2 => { :key22 => :val22 }, :key3 => val3 }
  #  h1.deep_marge! h2 #=> { :key1 => val1, :key2 => { :key21 => :val21. :key22 => :val22 }, test3 => val3 }
  #  h1 #=> { :key1 => :val1, :key2 => { :key21 => :val21 } }
  def deep_merge(new_hash)
    self.clone.deep_merge! new_hash
  end

  # Adds the contents of new_hash to another hash recusively
  # new_hash: the hash to merge
  #  h1 = { :key1 => :val1, :key2 => { :key21 => :val21 } }
  #  h2 = { :key2 => { :key22 => :val22 }, :key3 => val3 }
  #  h1.deep_marge! h2
  #  h1 #=> { :key1 => val1, :key2 => { :key21 => :val21. :key22 => :val22 }, test3 => val3 }
  def deep_merge!(new_hash)
    merge! new_hash do |key, v1, v2|
      if v1.is_a? Hash
        v1.deep_merge! v2
      else
        self[key] = v2
      end
    end
  end
end
