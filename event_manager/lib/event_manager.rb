require 'erb'
require 'csv'
require 'google/apis/civicinfo_v2'

def clean_zipcode(zipcode)
    zipcode.to_s.rjust(5,'0')[0..4]
end

def legislators_by_zipcode(zip)
    civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
    civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

    begin
        civic_info.representative_info_by_address(
            address: zip,
            levels: 'country',
            roles: ['legislatorUpperBody', 'legislatorLowerBody']
        ).officials
    rescue => exception
        'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
    end
end

def save_thank_you_letter(id, form_letter)
    Dir.mkdir('output') unless Dir.exist?('output')
    filename = "output/thanks_#{id}.html"

    File.open(filename,'w') do |file|
        file.puts form_letter
    end
end

def clean_phone_numbers(phnumber)
    phnumber.gsub(/[()\-,. ]/,'')
  if phnumber.length==10
      phnumber
  elsif phnumber.length==11 && phnumber[0]=="1"
      phnumber = phnumber[1..-1]
  else
      "bad number"
  end  
end

def most_common_hours
    contents = CSV.open('event_attendees.csv',headers: true, header_converters: :symbol)
    register_hour = Array.new()
    contents.each do |row|
        reg_date = row[:regdate]
        reg_hour = Time.strptime(reg_date, '%M/%d/%y %k:%M').strftime('%k')
        register_hour = register_hour.push(reg_hour)
    end
    most_common_hour = register_hour.reduce(Hash.new(0)) do |hash, hour|
        hash[hour] += 1
        hash
    end
    puts "The most common hour is: #{most_common_hour.max_by{|_k, v| v}[0]}:00 "
end

def most_common_days
    contents = CSV.open('event_attendees.csv',headers: true, header_converters: :symbol)
    register_day = Array.new()
    contents.each do |row|
        reg_date = row[:regdate]
        reg_day = Time.strptime(reg_date, '%M/%d/%y %k:%M').strftime('%^A')
        register_day = register_day.push(reg_day)
        end
    most_common_day = register_day.reduce(Hash.new(0)) do |hash, day|
        hash[day]+=1
        hash
    end
    puts "The most common day is: #{most_common_day.max_by{|_k, v| v}[0]}"
end

puts 'Event Manager Initialized!'

File.exist? 'event_attendees.csv'

contents = CSV.open('event_attendees.csv',headers: true, header_converters: :symbol)

template_letter = File.read('form_letter.erb')
erb_template = ERB.new template_letter

contents.each do |row|
    #id = row[0]
    #name = row[:first_name]

    #zipcode = clean_zipcode(row[:zipcode])

    #phnumber = clean_phone_numbers(row[:homephone])

    #egislators = legislators_by_zipcode(zipcode)

    #form_letter = erb_template.result(binding)

    #save_thank_you_letter(id, form_letter)
    
end
most_common_days
most_common_hours

