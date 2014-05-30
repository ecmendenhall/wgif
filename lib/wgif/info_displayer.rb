module WGif
  class InfoDisplayer

    GIGA_SIZE = 1073741824.0
    MEGA_SIZE = 1048576.0
    KILO_SIZE = 1024.0
  
    def display(file_name)
      file_size = readable_file_size(File.size("#{file_name}").to_f)
      puts "#{file_name} is #{file_size}" 
    end
  
    def readable_file_size(size)

      if size < KILO_SIZE
        abb, div = "Bytes", 1
      elsif size < MEGA_SIZE
        abb, div = "KB", KILO_SIZE
      elsif size < GIGA_SIZE
        abb, div = "MB", MEGA_SIZE
      else
        abb, div = "GB", GIGA_SIZE
      end
    
      "%.3f #{abb}" % (size / div)
    end 
  end
end