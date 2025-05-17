require 'json'
require 'yaml'

def add_contact(contacts)
  print 'Enter contact name: '
  name = gets.strip
  if contacts.key?(name)
    print 'Contact already exists. Add more numbers? (yes/no): '
    return unless gets.strip.downcase == 'yes'
  end

  print 'Enter phone numbers separated by commas: '
  numbers = gets.strip.split(',').map(&:strip)
  contacts[name] ||= []
  contacts[name] |= numbers 
  puts 'Contact added or updated.'
end

def view_contacts(contacts)
  if contacts.empty?
    puts 'No contacts available.'
  else
    contacts.each do |name, numbers|
      puts "#{name}: #{numbers.join(', ')}"
    end
  end
end

def edit_contact(contacts)
  print 'Enter the name of the contact to edit: '
  name = gets.strip
  unless contacts.key?(name)
    puts 'Contact not found.'
    return
  end

  puts "Current numbers: #{contacts[name].join(', ')}"
  print 'Enter new phone numbers to replace existing ones: '
  new_numbers = gets.strip.split(',').map(&:strip)
  contacts[name] = new_numbers
  puts 'Contact updated.'
end

def delete_contact(contacts)
  print 'Enter the name of the contact to delete: '
  name = gets.strip
  if contacts.delete(name)
    puts 'Contact deleted.'
  else
    puts 'Contact not found.'
  end
end

def search_contacts(contacts)
  print 'Enter name or part of it to search: '
  query = gets.strip.downcase
  results = contacts.select { |name, _| name.downcase.include?(query) }

  if results.empty?
    puts 'No contacts found.'
  else
    results.each { |name, numbers| puts "#{name}: #{numbers.join(', ')}" }
  end
end

def save_contacts(contacts)
  print 'Format (json/yaml): '
  format = gets.strip.downcase
  print 'Filename: '
  filename = gets.strip

  begin
    case format
    when 'json'
      File.write(filename, JSON.pretty_generate(contacts))
      puts 'Contacts saved to JSON.'
    when 'yaml'
      File.write(filename, contacts.to_yaml)
      puts 'Contacts saved to YAML.'
    else
      puts 'Unknown format.'
    end
  rescue => e
    puts "Error saving file: #{e.message}"
  end
end

def load_contacts
  print 'Format (json/yaml): '
  format = gets.strip.downcase
  print 'Filename: '
  filename = gets.strip

  begin
    data = case format
           when 'json'
             JSON.parse(File.read(filename))
           when 'yaml'
             YAML.load_file(filename)
           else
             puts 'Unknown format.'
             return {}
           end

    if data.is_a?(Hash) && data.values.all? { |v| v.is_a?(Array) }
      data
    else
      puts 'Invalid contact data structure.'
      {}
    end
  rescue => e
    puts "Error loading file: #{e.message}"
    {}
  end
end

def show_menu
  puts "\nContact Manager"
  puts '1. View all contacts'
  puts '2. Add a contact'
  puts '3. Edit a contact'
  puts '4. Delete a contact'
  puts '5. Search contacts'
  puts '6. Save contacts to file'
  puts '7. Load contacts from file'
  puts '0. Exit'
  print 'Choose an option: '
end


contacts = {}

loop do
  show_menu
  choice = gets.strip

  case choice
  when '1'
    view_contacts(contacts)
  when '2'
    add_contact(contacts)
  when '3'
    edit_contact(contacts)
  when '4'
    delete_contact(contacts)
  when '5'
    search_contacts(contacts)
  when '6'
    save_contacts(contacts)
  when '7'
    contacts = load_contacts
  when '0'
    puts 'Goodbye!'
    break
  else
    puts 'Invalid option. Try again.'
  end
end
