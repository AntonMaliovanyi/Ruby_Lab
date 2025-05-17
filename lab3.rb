require 'json'
require 'yaml'

class Contact
  attr_accessor :name, :numbers

  def initialize(name, numbers = [])
    @name = name
    @numbers = numbers.uniq
  end

  def add_numbers(new_numbers)
    @numbers = new_numbers
  end

  def to_h
    { @name => @numbers }
  end
end

class ContactBook
  def initialize
    @contacts = {}
  end

  def all
    @contacts
  end

  def add(name, numbers)
    if @contacts.key?(name)
      @contacts[name].add_numbers(numbers)
    else
      @contacts[name] = Contact.new(name, numbers)
    end
  end

  def edit(name, new_numbers)
    return false unless @contacts.key?(name)

    @contacts[name].numbers = new_numbers.uniq
    true
  end

  def delete(name)
    !!@contacts.delete(name)
  end

  def search(query)
    @contacts.select { |name, _| name.downcase.include?(query.downcase) }
  end

  def to_hash
    @contacts.transform_values(&:numbers)
  end

  def load_from_hash(data)
    return false unless data.is_a?(Hash) && data.values.all? { |v| v.is_a?(Array) }

    @contacts = data.map do |name, numbers|
      [name.to_s, Contact.new(name.to_s, numbers)]
    end.to_h
    true
  end
end

class FileManager
  def self.save(filename, format, data)
    case format
    when 'json'
      File.write(filename, JSON.pretty_generate(data))
      'Contacts saved to JSON.'
    when 'yaml'
      File.write(filename, data.to_yaml)
      'Contacts saved to YAML.'
    else
      'Unknown format.'
    end
  rescue => e
    "Error saving file: #{e.message}"
  end

  def self.load(filename, format)
    case format
    when 'json'
      JSON.parse(File.read(filename))
    when 'yaml'
      YAML.load_file(filename)
    else
      'Unknown format.'
    end
  rescue => e
    "Error loading file: #{e.message}"
  end
end

class ContactManagerApp
  def initialize
    @book = ContactBook.new
  end

  def run
    loop do
      show_menu
      choice = gets.strip

      case choice
      when '1' then view_contacts
      when '2' then add_contact
      when '3' then edit_contact
      when '4' then delete_contact
      when '5' then search_contacts
      when '6' then save_contacts
      when '7' then load_contacts
      when '0'
        puts 'Goodbye!'
        break
      else
        puts 'Invalid option. Try again.'
      end
    end
  end

  private

  def show_menu
    puts "\nContact Manager (input number from 1 to 7)"
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

  def add_contact
    print 'Enter contact name: '
    name = gets.strip
    if @book.all.key?(name)
      print 'Contact already exists. Add more numbers? (yes/no): '
      return unless gets.strip.downcase == 'yes'
    end
    print 'Enter phone numbers separated by commas: '
    numbers = gets.strip.split(',').map(&:strip)
    @book.add(name, numbers)
    puts 'Contact added or updated.'
  end

  def view_contacts
    if @book.all.empty?
      puts 'No contacts available.'
    else
      @book.all.each do |name, contact|
        puts "#{name}: #{contact.numbers.join(', ')}"
      end
    end
  end

  def edit_contact
    print 'Enter the name of the contact to edit: '
    name = gets.strip
    unless @book.all.key?(name)
      puts 'Contact not found.'
      return
    end
    puts "Current numbers: #{@book.all[name].numbers.join(', ')}"
    print 'Enter new phone numbers to replace existing ones: '
    numbers = gets.strip.split(',').map(&:strip)
    @book.edit(name, numbers)
    puts 'Contact updated.'
  end

  def delete_contact
    print 'Enter the name of the contact to delete: '
    name = gets.strip
    if @book.delete(name)
      puts 'Contact deleted.'
    else
      puts 'Contact not found.'
    end
  end

  def search_contacts
    print 'Enter name or part of it to search: '
    query = gets.strip
    results = @book.search(query)
    if results.empty?
      puts 'No contacts found.'
    else
      results.each do |name, contact|
        puts "#{name}: #{contact.numbers.join(', ')}"
      end
    end
  end

  def save_contacts
    print 'Format (json/yaml): '
    format = gets.strip.downcase
    print 'Filename: '
    filename = gets.strip
    message = FileManager.save(filename, format, @book.to_hash)
    puts message
  end

  def load_contacts
    print 'Format (json/yaml): '
    format = gets.strip.downcase
    print 'Filename: '
    filename = gets.strip
    data = FileManager.load(filename, format)
    if data.is_a?(Hash) && @book.load_from_hash(data)
      puts 'Contacts loaded successfully.'
    elsif data.is_a?(String)
      puts data
    else
      puts 'Invalid contact data structure.'
    end
  end
end

ContactManagerApp.new.run
