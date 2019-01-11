#!/usr/bin/env ruby

require 'retrospectives'

include Retrospectives

members =  [{name: 'Neelakshi', sheet_key: '1iYqA1irBBpktV3ssvxeZRuzkzAZ9RFqYcqI26kJUrSI', sheet_index: 1}
            # {name: 'Rohan', sheet_key: '1tZw7R_b40JogGRhXbVKRXaQpDlOB7JX-gd_DuPg_4tw', sheet_index: 1},
            # {name: 'Dinesh', sheet_key: '1qwx--iJ14ZI9hUgumdixove9aeoQU-oZibKi80QLICQ', sheet_index: 1}
          ]


if(ARGV[0].to_s.empty? || ARGV[1].to_s.empty? )
  puts("Usage: ruby #{__FILE__} Ticket_ids(comma separated) date_range. Example:")
  abort("\nruby #{__FILE__} CE-2421,CE-1987,CE-2422 '20171001 - 20171015'")
end

tickets = ARGV[0].split(',')
google_json_path = ENV['HOME'] + '/google_auth.json'

hours_spent = Hash.new(0)

retro = RetroSetup.new
retro.time_frame = ARGV[1]
retro.members = members

retro.add_tickets(tickets)
retro.authenticate_google_drive(google_json_path)
FetchHours.from_timesheet(retro)

total_hours = 0
retro.members.each do |member|
  puts "#{member.name} #{member.hours_spent_timesheet}"
  member.hours_spent_timesheet.values.map { |val| total_hours+= val }
end

puts "total hours : #{total_hours}"
