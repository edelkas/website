# Ruby script to produce the final HTML files by inserting the desired content
# stored in the plain txt files inside the bare HTML file that contains
# the common structure of all pages of the site. The title of the section
# has to be specified as a parameter.
# Note: ERB could be used for this purpose more efficiently.
#
# Eddy, Feb 2020.

if ARGV.length == 0
  entries = Dir.entries("plain")
  puts entries
  files = entries.select{ |f| File.file?("plain/" + f) }.map{ |f| f[0..-5].downcase }
  #folders = entries.select{ |f| File.directory?(f) }.reject{ |f| f == "." || f == ".." }
  #subfiles = folders.map{ |f| [f, Dir.entries(f).select{ |f| File.file?(f) }.map{ |f| f[0..-5].downcase }] }.to_h
  #puts subfiles
else
  files = ARGV.map(&:downcase)
end

def update_file(file)
  if !File.exist?("plain/" + file + ".txt")
    puts "File " + file + ".txt not found."
    return
  end

  # Use titleize (Rails) to capitalize all initial letters
  bare = File.read("bare.html")
  content = File.read("plain/" + file + ".txt")
  full = bare.gsub("ruby_content", content)
              .gsub("ruby_title", (file == "index" ? "home" : file).capitalize)
              .gsub("ruby_date", Time.now.strftime("%Y-%m-%d"))
  File.write(file + ".html", full)
end

files.each{ |f| update_file(f) }
