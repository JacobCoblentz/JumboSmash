require 'csv'
namespace :scrape do
  desc "generate json array of all names"
  task :json => :environment do
    puts "[#{Whitelist.all.map {|w| "\"#{w.name}\"" }.join(',')}]"
  end

  desc "clean csv of non @tufts.edu"
  task :clean => :environment do
    while line = STDIN.gets do
      if line.end_with? "@tufts.edu\n"
        puts line
      end
    end
  end
end
